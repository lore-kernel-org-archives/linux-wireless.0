Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EEBC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C05E21850
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbfDQVma (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:42:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:20166 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387624AbfDQVm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 17:42:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 14:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="224441213"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2019 14:42:28 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Michael Chan" <michael.chan@broadcom.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v7 17/21] x86/clearcpuid: Support multiple clearcpuid options
Date:   Wed, 17 Apr 2019 14:34:07 -0700
Message-Id: <1555536851-17462-18-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently only one kernel option "clearcpuid=" can be picked up by
kernel during boot time.

In some cases, user may want to clear a few cpu caps. This may be
useful to replace endless (new) kernel options like nosmep, nosmap,
etc.

Add support of multiple clearcpuid options to allow user to clear
multiple cpu caps.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cmdline.h |  3 +++
 arch/x86/kernel/fpu/init.c     | 30 ++++++++++++++++++++----------
 arch/x86/lib/cmdline.c         | 17 +++++++++++++++--
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/cmdline.h b/arch/x86/include/asm/cmdline.h
index 6faaf27e8899..059e29558bb3 100644
--- a/arch/x86/include/asm/cmdline.h
+++ b/arch/x86/include/asm/cmdline.h
@@ -5,5 +5,8 @@
 int cmdline_find_option_bool(const char *cmdline_ptr, const char *option);
 int cmdline_find_option(const char *cmdline_ptr, const char *option,
 			char *buffer, int bufsize);
+int cmdline_find_option_in_range(const char *cmdline_ptr, int cmdline_size,
+				 const char *option, char *buffer, int bufsize,
+				 char **arg_pos);
 
 #endif /* _ASM_X86_CMDLINE_H */
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 6abd83572b01..88bbba7ee96a 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -243,16 +243,31 @@ static void __init fpu__init_system_ctx_switch(void)
 	WARN_ON_FPU(current->thread.fpu.initialized);
 }
 
+static void __init clear_cpuid(void)
+{
+	char arg[32], *argptr, *option_pos, clearcpuid_option[] = "clearcpuid";
+	int bit, cmdline_size;
+
+	/* Find each option in boot_command_line and clear specified cpu cap. */
+	cmdline_size = COMMAND_LINE_SIZE;
+	while (cmdline_find_option_in_range(boot_command_line, cmdline_size,
+					    clearcpuid_option, arg,
+					    sizeof(arg), &option_pos) >= 0) {
+		/* Chang command line range for next search. */
+		cmdline_size = option_pos - boot_command_line + 1;
+		argptr = arg;
+		if (get_option(&argptr, &bit) &&
+		    bit >= 0 && bit < NCAPINTS * 32)
+			setup_clear_cpu_cap(bit);
+	}
+}
+
 /*
  * We parse fpu parameters early because fpu__init_system() is executed
  * before parse_early_param().
  */
 static void __init fpu__init_parse_early_param(void)
 {
-	char arg[32];
-	char *argptr = arg;
-	int bit;
-
 	if (cmdline_find_option_bool(boot_command_line, "no387"))
 		setup_clear_cpu_cap(X86_FEATURE_FPU);
 
@@ -271,12 +286,7 @@ static void __init fpu__init_parse_early_param(void)
 	if (cmdline_find_option_bool(boot_command_line, "noxsaves"))
 		setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 
-	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
-				sizeof(arg)) &&
-	    get_option(&argptr, &bit) &&
-	    bit >= 0 &&
-	    bit < NCAPINTS * 32)
-		setup_clear_cpu_cap(bit);
+	clear_cpuid();
 }
 
 /*
diff --git a/arch/x86/lib/cmdline.c b/arch/x86/lib/cmdline.c
index 3261abb21ef4..9cf1a0773877 100644
--- a/arch/x86/lib/cmdline.c
+++ b/arch/x86/lib/cmdline.c
@@ -114,13 +114,15 @@ __cmdline_find_option_bool(const char *cmdline, int max_cmdline_size,
  * @option: option string to look for
  * @buffer: memory buffer to return the option argument
  * @bufsize: size of the supplied memory buffer
+ * @option_pos: pointer to the option if found
  *
  * Returns the length of the argument (regardless of if it was
  * truncated to fit in the buffer), or -1 on not found.
  */
 static int
 __cmdline_find_option(const char *cmdline, int max_cmdline_size,
-		      const char *option, char *buffer, int bufsize)
+		      const char *option, char *buffer, int bufsize,
+		      char **arg_pos)
 {
 	char c;
 	int pos = 0, len = -1;
@@ -164,6 +166,9 @@ __cmdline_find_option(const char *cmdline, int max_cmdline_size,
 				len = 0;
 				bufptr = buffer;
 				state = st_bufcpy;
+				if (arg_pos)
+					*arg_pos = (char *)cmdline -
+						   strlen(option) - 1;
 				break;
 			} else if (c == *opptr++) {
 				/*
@@ -211,5 +216,13 @@ int cmdline_find_option(const char *cmdline, const char *option, char *buffer,
 			int bufsize)
 {
 	return __cmdline_find_option(cmdline, COMMAND_LINE_SIZE, option,
-				     buffer, bufsize);
+				     buffer, bufsize, NULL);
+}
+
+int cmdline_find_option_in_range(const char *cmdline, int cmdline_size,
+				 char *option, char *buffer, int bufsize,
+				 char **arg_pos)
+{
+	return __cmdline_find_option(cmdline, cmdline_size, option, buffer,
+				     bufsize, arg_pos);
 }
-- 
2.19.1

