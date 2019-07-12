Return-Path: <SRS0=USiB=VJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6510C742A6
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 02:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88A082084B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 02:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfGLCPs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Jul 2019 22:15:48 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:41189 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726505AbfGLCPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jul 2019 22:15:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8CD04181D33FB;
        Fri, 12 Jul 2019 02:15:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: list61_6c0723a6be725
X-Filterd-Recvd-Size: 5469
Received: from XPS-9350 (unknown [172.58.27.57])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri, 12 Jul 2019 02:15:42 +0000 (UTC)
Message-ID: <b219cf41933b2f965572af515cf9d3119293bfba.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, kvalo@codeaurora.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
In-Reply-To: <20190712001708.170259-1-ndesaulniers@google.com>
References: <20190712001708.170259-1-ndesaulniers@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Date:   Thu, 11 Jul 2019 19:01:14 -0700
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-07-11 at 17:17 -0700, Nick Desaulniers wrote:
> Commit r353569 in prerelease Clang-9 is producing a linkage failure:
> 
> ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> in function `_iwl_fw_dbg_apply_point':
> dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'
> 
> when the following configs are enabled:
> - CONFIG_IWLWIFI
> - CONFIG_IWLMVM
> - CONFIG_KASAN
> 
> Work around the issue for now by marking the debug strings as `static`,
> which they probably should be any ways.
> 
> Link: https://bugs.llvm.org/show_bug.cgi?id=42580
> Link: https://github.com/ClangBuiltLinux/linux/issues/580
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> index e411ac98290d..f8c90ea4e9b4 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> @@ -2438,7 +2438,7 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
>  {
>  	u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
>  	u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
> -	const char err_str[] =
> +	static const char err_str[] =
>  		"WRT: ext=%d. Invalid %s name length %d, expected %d\n";

Better still would be to use the format string directly
in both locations instead of trying to deduplicate it
via storing it into a separate pointer.

Let the compiler/linker consolidate the format.
It's smaller object code, allows format/argument verification,
and is simpler for humans to understand.

---
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index e411ac98290d..25e6712932b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2438,17 +2438,17 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
 {
 	u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
 	u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
-	const char err_str[] =
-		"WRT: ext=%d. Invalid %s name length %d, expected %d\n";
 
 	if (img_name_len != IWL_FW_INI_MAX_IMG_NAME_LEN) {
-		IWL_WARN(fwrt, err_str, ext, "image", img_name_len,
+		IWL_WARN(fwrt, "WRT: ext=%d. Invalid %s name length %d, expected %d\n",
+			 ext, "image", img_name_len,
 			 IWL_FW_INI_MAX_IMG_NAME_LEN);
 		return;
 	}
 
 	if (dbg_cfg_name_len != IWL_FW_INI_MAX_DBG_CFG_NAME_LEN) {
-		IWL_WARN(fwrt, err_str, ext, "debug cfg", dbg_cfg_name_len,
+		IWL_WARN(fwrt, "WRT: ext=%d. Invalid %s name length %d, expected %d\n",
+			 ext, "debug cfg", dbg_cfg_name_len,
 			 IWL_FW_INI_MAX_DBG_CFG_NAME_LEN);
 		return;
 	}
@@ -2775,8 +2775,6 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		struct iwl_ucode_tlv *tlv = iter;
 		void *ini_tlv = (void *)tlv->data;
 		u32 type = le32_to_cpu(tlv->type);
-		const char invalid_ap_str[] =
-			"WRT: ext=%d. Invalid apply point %d for %s\n";
 
 		switch (type) {
 		case IWL_UCODE_TLV_TYPE_DEBUG_INFO:
@@ -2786,8 +2784,8 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			struct iwl_fw_ini_allocation_data *buf_alloc = ini_tlv;
 
 			if (pnt != IWL_FW_INI_APPLY_EARLY) {
-				IWL_ERR(fwrt, invalid_ap_str, ext, pnt,
-					"buffer allocation");
+				IWL_ERR(fwrt, "WRT: ext=%d. Invalid apply point %d for %s\n",
+					ext, pnt, "buffer allocation");
 				goto next;
 			}
 
@@ -2797,8 +2795,8 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		}
 		case IWL_UCODE_TLV_TYPE_HCMD:
 			if (pnt < IWL_FW_INI_APPLY_AFTER_ALIVE) {
-				IWL_ERR(fwrt, invalid_ap_str, ext, pnt,
-					"host command");
+				IWL_ERR(fwrt, "WRT: ext=%d. Invalid apply point %d for %s\n",
+					ext, pnt, "host command");
 				goto next;
 			}
 			iwl_fw_dbg_send_hcmd(fwrt, tlv, ext);


