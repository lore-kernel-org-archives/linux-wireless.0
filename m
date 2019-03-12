Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300EDC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F28D5217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfCLXIR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:08:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:27628 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfCLXIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744234"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:13 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 07/18] x86/split_lock: Enumerate #AC for split lock by MSR IA32_CORE_CAPABILITY
Date:   Tue, 12 Mar 2019 16:00:25 -0700
Message-Id: <1552431636-31511-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bits in MSR IA32_CORE_CAPABILITY enumerate features that are not
enumerated through CPUID. Currently bit 5 is defined to enumerate
feature of #AC for split lock accesses. All other bits are reserved now.

When the bit 5 is 1, the feature is supported and feature bit
X86_FEATURE_SPLIT_LOCK_DETECT is set. Otherwise, the feature is not
available.

The MSR IA32_CORE_CAPABILITY itself is enumerated by
CPUID.(EAX=0x7,ECX=0):EDX[30].

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h         |  5 ++
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/common.c       |  2 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 79 +++++++++++++++---------------
 arch/x86/kernel/cpu/intel.c        | 22 +++++++++
 5 files changed, 70 insertions(+), 39 deletions(-)

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
index 65b6af6cdc19..661719cbf458 100644
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
index 51ab37ba5f64..16b091bb62bd 100644
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
index fc3c07fe7df5..889390d51c17 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1029,3 +1029,25 @@ static const struct cpu_dev intel_cpu_dev = {
 
 cpu_dev_register(intel_cpu_dev);
 
+/**
+ * set_cpu_core_cap_bits - enumerate features supported in IA32_CORE_CAPABILITY
+ * @c: pointer to cpuinfo_x86
+ *
+ * Return: void
+ */
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
+		setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+}
-- 
2.19.1

