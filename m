Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E37FC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56FC620674
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389645AbfDXTlo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:41:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:15196 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbfDXTln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454886"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:40 -0700
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
Subject: [PATCH v8 07/15] x86/split_lock: Enumerate split lock detection by MSR_IA32_CORE_CAPABILITY
Date:   Wed, 24 Apr 2019 12:32:54 -0700
Message-Id: <1556134382-58814-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bits in MSR_IA32_CORE_CAPABILITY enumerate a few features that are not
enumerated through CPUID. Currently bit 5 is defined to enumerate
feature of split lock detection. All other bits are reserved now.

When bit 5 is 1, the feature is supported and feature bit
X86_FEATURE_SPLIT_LOCK_DETECT is set. Otherwise, the feature is not
available.

The MSR_IA32_CORE_CAPABILITY itself is enumerated by
CPUID.(EAX=0x7,ECX=0):EDX[30].

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h         |  5 ++
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/common.c       |  2 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 79 +++++++++++++++---------------
 arch/x86/kernel/cpu/intel.c        | 21 ++++++++
 5 files changed, 69 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index adc6cc86b062..4e03f53fc079 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -40,4 +40,9 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
+#ifdef CONFIG_CPU_SUP_INTEL
+void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
+#else
+static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
+#endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index eff25e2015a5..db0c1826d7ad 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -221,6 +221,7 @@
 #define X86_FEATURE_ZEN			( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
+#define X86_FEATURE_SPLIT_LOCK_DETECT	( 7*32+31) /* #AC for split lock */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3716e2bb028b..bbdd69dd4f5f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1105,6 +1105,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	cpu_set_bug_bits(c);
 
+	cpu_set_core_cap_bits(c);
+
 	fpu__init_system(c);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 2c0bd38a44ab..3d633f67fbd7 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -20,45 +20,46 @@ struct cpuid_dep {
  * but it's difficult to tell that to the init reference checker.
  */
 static const struct cpuid_dep cpuid_deps[] = {
-	{ X86_FEATURE_XSAVEOPT,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XSAVEC,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XSAVES,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_AVX,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_PKU,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_MPX,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XGETBV1,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_FXSR_OPT,		X86_FEATURE_FXSR      },
-	{ X86_FEATURE_XMM,		X86_FEATURE_FXSR      },
-	{ X86_FEATURE_XMM2,		X86_FEATURE_XMM       },
-	{ X86_FEATURE_XMM3,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM4_1,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM4_2,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM3,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_PCLMULQDQ,	X86_FEATURE_XMM2      },
-	{ X86_FEATURE_SSSE3,		X86_FEATURE_XMM2,     },
-	{ X86_FEATURE_F16C,		X86_FEATURE_XMM2,     },
-	{ X86_FEATURE_AES,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_SHA_NI,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_FMA,		X86_FEATURE_AVX       },
-	{ X86_FEATURE_AVX2,		X86_FEATURE_AVX,      },
-	{ X86_FEATURE_AVX512F,		X86_FEATURE_AVX,      },
-	{ X86_FEATURE_AVX512IFMA,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512PF,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512ER,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512CD,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512DQ,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512BW,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512VL,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512VBMI,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_VBMI2,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_GFNI,		X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VAES,		X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VPCLMULQDQ,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_VNNI,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_BITALG,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_4VNNIW,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_4FMAPS,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_VPOPCNTDQ, X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_XSAVEOPT,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XSAVEC,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XSAVES,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_AVX,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_PKU,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_MPX,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XGETBV1,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_FXSR_OPT,			X86_FEATURE_FXSR      },
+	{ X86_FEATURE_XMM,			X86_FEATURE_FXSR      },
+	{ X86_FEATURE_XMM2,			X86_FEATURE_XMM       },
+	{ X86_FEATURE_XMM3,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM4_1,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM4_2,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM3,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_PCLMULQDQ,		X86_FEATURE_XMM2      },
+	{ X86_FEATURE_SSSE3,			X86_FEATURE_XMM2,     },
+	{ X86_FEATURE_F16C,			X86_FEATURE_XMM2,     },
+	{ X86_FEATURE_AES,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_SHA_NI,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_FMA,			X86_FEATURE_AVX       },
+	{ X86_FEATURE_AVX2,			X86_FEATURE_AVX,      },
+	{ X86_FEATURE_AVX512F,			X86_FEATURE_AVX,      },
+	{ X86_FEATURE_AVX512IFMA,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512PF,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512ER,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512CD,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512DQ,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512BW,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512VL,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512VBMI,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_VBMI2,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_GFNI,			X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_VAES,			X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_VPCLMULQDQ,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_VNNI,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_BITALG,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_4VNNIW,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_4FMAPS,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_VPOPCNTDQ,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_SPLIT_LOCK_DETECT,	X86_FEATURE_CORE_CAPABILITY},
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3142fd7a9b32..86a3a646e0ce 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1029,3 +1029,24 @@ static const struct cpu_dev intel_cpu_dev = {
 
 cpu_dev_register(intel_cpu_dev);
 
+static void __init set_split_lock_detect(void)
+{
+	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+}
+
+void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
+{
+	u64 ia32_core_cap = 0;
+
+	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY))
+		return;
+
+	/*
+	 * If MSR_IA32_CORE_CAPABILITY exists, enumerate features that are
+	 * reported in the MSR.
+	 */
+	rdmsrl(MSR_IA32_CORE_CAPABILITY, ia32_core_cap);
+
+	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT)
+		set_split_lock_detect();
+}
-- 
2.19.1

