Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19061 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab0IHAYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 20:24:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 17:23:58 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Replacing the symbolic link to the hw.0 directory with a new directory 'hw' while retaining the contents. This will help with the cases where the driver fails to compile if the link was not setup properly.
Date: Tue, 7 Sep 2010 17:24:47 -0700
Message-ID: <1283905487-1471-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../include/common/AR6002/hw.0/analog_intf_reg.h   |   64 -
 .../ath6kl/include/common/AR6002/hw.0/analog_reg.h | 1932 --------------------
 .../ath6kl/include/common/AR6002/hw.0/apb_map.h    |   13 -
 .../ath6kl/include/common/AR6002/hw.0/gpio_reg.h   |  977 ----------
 .../include/common/AR6002/hw.0/mbox_host_reg.h     |  386 ----
 .../ath6kl/include/common/AR6002/hw.0/mbox_reg.h   |  481 -----
 .../ath6kl/include/common/AR6002/hw.0/rtc_reg.h    | 1163 ------------
 .../ath6kl/include/common/AR6002/hw.0/si_reg.h     |  186 --
 .../ath6kl/include/common/AR6002/hw.0/uart_reg.h   |  327 ----
 .../ath6kl/include/common/AR6002/hw.0/vmc_reg.h    |   76 -
 .../staging/ath6kl/include/common/AR6002/hw2.0/hw  |    1 -
 .../common/AR6002/hw2.0/hw/analog_intf_reg.h       |   64 +
 .../include/common/AR6002/hw2.0/hw/analog_reg.h    | 1932 ++++++++++++++++++++
 .../include/common/AR6002/hw2.0/hw/apb_map.h       |   13 +
 .../include/common/AR6002/hw2.0/hw/gpio_reg.h      |  977 ++++++++++
 .../include/common/AR6002/hw2.0/hw/mbox_host_reg.h |  386 ++++
 .../include/common/AR6002/hw2.0/hw/mbox_reg.h      |  481 +++++
 .../include/common/AR6002/hw2.0/hw/rtc_reg.h       | 1163 ++++++++++++
 .../ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h |  186 ++
 .../include/common/AR6002/hw2.0/hw/uart_reg.h      |  327 ++++
 .../include/common/AR6002/hw2.0/hw/vmc_reg.h       |   76 +
 21 files changed, 5605 insertions(+), 5606 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h
 delete mode 120000 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h

diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h
deleted file mode 100644
index 9c82767..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h
+++ /dev/null
@@ -1,64 +0,0 @@
-#ifndef _ANALOG_INTF_REG_REG_H_
-#define _ANALOG_INTF_REG_REG_H_
-
-#define SW_OVERRIDE_ADDRESS                      0x00000080
-#define SW_OVERRIDE_OFFSET                       0x00000080
-#define SW_OVERRIDE_SUPDATE_DELAY_MSB            1
-#define SW_OVERRIDE_SUPDATE_DELAY_LSB            1
-#define SW_OVERRIDE_SUPDATE_DELAY_MASK           0x00000002
-#define SW_OVERRIDE_SUPDATE_DELAY_GET(x)         (((x) & SW_OVERRIDE_SUPDATE_DELAY_MASK) >> SW_OVERRIDE_SUPDATE_DELAY_LSB)
-#define SW_OVERRIDE_SUPDATE_DELAY_SET(x)         (((x) << SW_OVERRIDE_SUPDATE_DELAY_LSB) & SW_OVERRIDE_SUPDATE_DELAY_MASK)
-#define SW_OVERRIDE_ENABLE_MSB                   0
-#define SW_OVERRIDE_ENABLE_LSB                   0
-#define SW_OVERRIDE_ENABLE_MASK                  0x00000001
-#define SW_OVERRIDE_ENABLE_GET(x)                (((x) & SW_OVERRIDE_ENABLE_MASK) >> SW_OVERRIDE_ENABLE_LSB)
-#define SW_OVERRIDE_ENABLE_SET(x)                (((x) << SW_OVERRIDE_ENABLE_LSB) & SW_OVERRIDE_ENABLE_MASK)
-
-#define SIN_VAL_ADDRESS                          0x00000084
-#define SIN_VAL_OFFSET                           0x00000084
-#define SIN_VAL_SIN_MSB                          0
-#define SIN_VAL_SIN_LSB                          0
-#define SIN_VAL_SIN_MASK                         0x00000001
-#define SIN_VAL_SIN_GET(x)                       (((x) & SIN_VAL_SIN_MASK) >> SIN_VAL_SIN_LSB)
-#define SIN_VAL_SIN_SET(x)                       (((x) << SIN_VAL_SIN_LSB) & SIN_VAL_SIN_MASK)
-
-#define SW_SCLK_ADDRESS                          0x00000088
-#define SW_SCLK_OFFSET                           0x00000088
-#define SW_SCLK_SW_SCLK_MSB                      0
-#define SW_SCLK_SW_SCLK_LSB                      0
-#define SW_SCLK_SW_SCLK_MASK                     0x00000001
-#define SW_SCLK_SW_SCLK_GET(x)                   (((x) & SW_SCLK_SW_SCLK_MASK) >> SW_SCLK_SW_SCLK_LSB)
-#define SW_SCLK_SW_SCLK_SET(x)                   (((x) << SW_SCLK_SW_SCLK_LSB) & SW_SCLK_SW_SCLK_MASK)
-
-#define SW_CNTL_ADDRESS                          0x0000008c
-#define SW_CNTL_OFFSET                           0x0000008c
-#define SW_CNTL_SW_SCAPTURE_MSB                  2
-#define SW_CNTL_SW_SCAPTURE_LSB                  2
-#define SW_CNTL_SW_SCAPTURE_MASK                 0x00000004
-#define SW_CNTL_SW_SCAPTURE_GET(x)               (((x) & SW_CNTL_SW_SCAPTURE_MASK) >> SW_CNTL_SW_SCAPTURE_LSB)
-#define SW_CNTL_SW_SCAPTURE_SET(x)               (((x) << SW_CNTL_SW_SCAPTURE_LSB) & SW_CNTL_SW_SCAPTURE_MASK)
-#define SW_CNTL_SW_SUPDATE_MSB                   1
-#define SW_CNTL_SW_SUPDATE_LSB                   1
-#define SW_CNTL_SW_SUPDATE_MASK                  0x00000002
-#define SW_CNTL_SW_SUPDATE_GET(x)                (((x) & SW_CNTL_SW_SUPDATE_MASK) >> SW_CNTL_SW_SUPDATE_LSB)
-#define SW_CNTL_SW_SUPDATE_SET(x)                (((x) << SW_CNTL_SW_SUPDATE_LSB) & SW_CNTL_SW_SUPDATE_MASK)
-#define SW_CNTL_SW_SOUT_MSB                      0
-#define SW_CNTL_SW_SOUT_LSB                      0
-#define SW_CNTL_SW_SOUT_MASK                     0x00000001
-#define SW_CNTL_SW_SOUT_GET(x)                   (((x) & SW_CNTL_SW_SOUT_MASK) >> SW_CNTL_SW_SOUT_LSB)
-#define SW_CNTL_SW_SOUT_SET(x)                   (((x) << SW_CNTL_SW_SOUT_LSB) & SW_CNTL_SW_SOUT_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct analog_intf_reg_reg_s {
-  unsigned char pad0[128]; /* pad to 0x80 */
-  volatile unsigned int sw_override;
-  volatile unsigned int sin_val;
-  volatile unsigned int sw_sclk;
-  volatile unsigned int sw_cntl;
-} analog_intf_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _ANALOG_INTF_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h
deleted file mode 100644
index cf562b8..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h
+++ /dev/null
@@ -1,1932 +0,0 @@
-#ifndef _ANALOG_REG_REG_H_
-#define _ANALOG_REG_REG_H_
-
-#define SYNTH_SYNTH1_ADDRESS                     0x00000000
-#define SYNTH_SYNTH1_OFFSET                      0x00000000
-#define SYNTH_SYNTH1_PWD_BIAS_MSB                31
-#define SYNTH_SYNTH1_PWD_BIAS_LSB                31
-#define SYNTH_SYNTH1_PWD_BIAS_MASK               0x80000000
-#define SYNTH_SYNTH1_PWD_BIAS_GET(x)             (((x) & SYNTH_SYNTH1_PWD_BIAS_MASK) >> SYNTH_SYNTH1_PWD_BIAS_LSB)
-#define SYNTH_SYNTH1_PWD_BIAS_SET(x)             (((x) << SYNTH_SYNTH1_PWD_BIAS_LSB) & SYNTH_SYNTH1_PWD_BIAS_MASK)
-#define SYNTH_SYNTH1_PWD_CP_MSB                  30
-#define SYNTH_SYNTH1_PWD_CP_LSB                  30
-#define SYNTH_SYNTH1_PWD_CP_MASK                 0x40000000
-#define SYNTH_SYNTH1_PWD_CP_GET(x)               (((x) & SYNTH_SYNTH1_PWD_CP_MASK) >> SYNTH_SYNTH1_PWD_CP_LSB)
-#define SYNTH_SYNTH1_PWD_CP_SET(x)               (((x) << SYNTH_SYNTH1_PWD_CP_LSB) & SYNTH_SYNTH1_PWD_CP_MASK)
-#define SYNTH_SYNTH1_PWD_VCMON_MSB               29
-#define SYNTH_SYNTH1_PWD_VCMON_LSB               29
-#define SYNTH_SYNTH1_PWD_VCMON_MASK              0x20000000
-#define SYNTH_SYNTH1_PWD_VCMON_GET(x)            (((x) & SYNTH_SYNTH1_PWD_VCMON_MASK) >> SYNTH_SYNTH1_PWD_VCMON_LSB)
-#define SYNTH_SYNTH1_PWD_VCMON_SET(x)            (((x) << SYNTH_SYNTH1_PWD_VCMON_LSB) & SYNTH_SYNTH1_PWD_VCMON_MASK)
-#define SYNTH_SYNTH1_PWD_VCO_MSB                 28
-#define SYNTH_SYNTH1_PWD_VCO_LSB                 28
-#define SYNTH_SYNTH1_PWD_VCO_MASK                0x10000000
-#define SYNTH_SYNTH1_PWD_VCO_GET(x)              (((x) & SYNTH_SYNTH1_PWD_VCO_MASK) >> SYNTH_SYNTH1_PWD_VCO_LSB)
-#define SYNTH_SYNTH1_PWD_VCO_SET(x)              (((x) << SYNTH_SYNTH1_PWD_VCO_LSB) & SYNTH_SYNTH1_PWD_VCO_MASK)
-#define SYNTH_SYNTH1_PWD_PRESC_MSB               27
-#define SYNTH_SYNTH1_PWD_PRESC_LSB               27
-#define SYNTH_SYNTH1_PWD_PRESC_MASK              0x08000000
-#define SYNTH_SYNTH1_PWD_PRESC_GET(x)            (((x) & SYNTH_SYNTH1_PWD_PRESC_MASK) >> SYNTH_SYNTH1_PWD_PRESC_LSB)
-#define SYNTH_SYNTH1_PWD_PRESC_SET(x)            (((x) << SYNTH_SYNTH1_PWD_PRESC_LSB) & SYNTH_SYNTH1_PWD_PRESC_MASK)
-#define SYNTH_SYNTH1_PWD_LODIV_MSB               26
-#define SYNTH_SYNTH1_PWD_LODIV_LSB               26
-#define SYNTH_SYNTH1_PWD_LODIV_MASK              0x04000000
-#define SYNTH_SYNTH1_PWD_LODIV_GET(x)            (((x) & SYNTH_SYNTH1_PWD_LODIV_MASK) >> SYNTH_SYNTH1_PWD_LODIV_LSB)
-#define SYNTH_SYNTH1_PWD_LODIV_SET(x)            (((x) << SYNTH_SYNTH1_PWD_LODIV_LSB) & SYNTH_SYNTH1_PWD_LODIV_MASK)
-#define SYNTH_SYNTH1_PWD_LOMIX_MSB               25
-#define SYNTH_SYNTH1_PWD_LOMIX_LSB               25
-#define SYNTH_SYNTH1_PWD_LOMIX_MASK              0x02000000
-#define SYNTH_SYNTH1_PWD_LOMIX_GET(x)            (((x) & SYNTH_SYNTH1_PWD_LOMIX_MASK) >> SYNTH_SYNTH1_PWD_LOMIX_LSB)
-#define SYNTH_SYNTH1_PWD_LOMIX_SET(x)            (((x) << SYNTH_SYNTH1_PWD_LOMIX_LSB) & SYNTH_SYNTH1_PWD_LOMIX_MASK)
-#define SYNTH_SYNTH1_FORCE_LO_ON_MSB             24
-#define SYNTH_SYNTH1_FORCE_LO_ON_LSB             24
-#define SYNTH_SYNTH1_FORCE_LO_ON_MASK            0x01000000
-#define SYNTH_SYNTH1_FORCE_LO_ON_GET(x)          (((x) & SYNTH_SYNTH1_FORCE_LO_ON_MASK) >> SYNTH_SYNTH1_FORCE_LO_ON_LSB)
-#define SYNTH_SYNTH1_FORCE_LO_ON_SET(x)          (((x) << SYNTH_SYNTH1_FORCE_LO_ON_LSB) & SYNTH_SYNTH1_FORCE_LO_ON_MASK)
-#define SYNTH_SYNTH1_PWD_LOBUF5G_MSB             23
-#define SYNTH_SYNTH1_PWD_LOBUF5G_LSB             23
-#define SYNTH_SYNTH1_PWD_LOBUF5G_MASK            0x00800000
-#define SYNTH_SYNTH1_PWD_LOBUF5G_GET(x)          (((x) & SYNTH_SYNTH1_PWD_LOBUF5G_MASK) >> SYNTH_SYNTH1_PWD_LOBUF5G_LSB)
-#define SYNTH_SYNTH1_PWD_LOBUF5G_SET(x)          (((x) << SYNTH_SYNTH1_PWD_LOBUF5G_LSB) & SYNTH_SYNTH1_PWD_LOBUF5G_MASK)
-#define SYNTH_SYNTH1_VCOREGBYPASS_MSB            22
-#define SYNTH_SYNTH1_VCOREGBYPASS_LSB            22
-#define SYNTH_SYNTH1_VCOREGBYPASS_MASK           0x00400000
-#define SYNTH_SYNTH1_VCOREGBYPASS_GET(x)         (((x) & SYNTH_SYNTH1_VCOREGBYPASS_MASK) >> SYNTH_SYNTH1_VCOREGBYPASS_LSB)
-#define SYNTH_SYNTH1_VCOREGBYPASS_SET(x)         (((x) << SYNTH_SYNTH1_VCOREGBYPASS_LSB) & SYNTH_SYNTH1_VCOREGBYPASS_MASK)
-#define SYNTH_SYNTH1_VCOREGLEVEL_MSB             21
-#define SYNTH_SYNTH1_VCOREGLEVEL_LSB             20
-#define SYNTH_SYNTH1_VCOREGLEVEL_MASK            0x00300000
-#define SYNTH_SYNTH1_VCOREGLEVEL_GET(x)          (((x) & SYNTH_SYNTH1_VCOREGLEVEL_MASK) >> SYNTH_SYNTH1_VCOREGLEVEL_LSB)
-#define SYNTH_SYNTH1_VCOREGLEVEL_SET(x)          (((x) << SYNTH_SYNTH1_VCOREGLEVEL_LSB) & SYNTH_SYNTH1_VCOREGLEVEL_MASK)
-#define SYNTH_SYNTH1_VCOREGBIAS_MSB              19
-#define SYNTH_SYNTH1_VCOREGBIAS_LSB              18
-#define SYNTH_SYNTH1_VCOREGBIAS_MASK             0x000c0000
-#define SYNTH_SYNTH1_VCOREGBIAS_GET(x)           (((x) & SYNTH_SYNTH1_VCOREGBIAS_MASK) >> SYNTH_SYNTH1_VCOREGBIAS_LSB)
-#define SYNTH_SYNTH1_VCOREGBIAS_SET(x)           (((x) << SYNTH_SYNTH1_VCOREGBIAS_LSB) & SYNTH_SYNTH1_VCOREGBIAS_MASK)
-#define SYNTH_SYNTH1_SLIDINGIF_MSB               17
-#define SYNTH_SYNTH1_SLIDINGIF_LSB               17
-#define SYNTH_SYNTH1_SLIDINGIF_MASK              0x00020000
-#define SYNTH_SYNTH1_SLIDINGIF_GET(x)            (((x) & SYNTH_SYNTH1_SLIDINGIF_MASK) >> SYNTH_SYNTH1_SLIDINGIF_LSB)
-#define SYNTH_SYNTH1_SLIDINGIF_SET(x)            (((x) << SYNTH_SYNTH1_SLIDINGIF_LSB) & SYNTH_SYNTH1_SLIDINGIF_MASK)
-#define SYNTH_SYNTH1_SPARE_PWD_MSB               16
-#define SYNTH_SYNTH1_SPARE_PWD_LSB               16
-#define SYNTH_SYNTH1_SPARE_PWD_MASK              0x00010000
-#define SYNTH_SYNTH1_SPARE_PWD_GET(x)            (((x) & SYNTH_SYNTH1_SPARE_PWD_MASK) >> SYNTH_SYNTH1_SPARE_PWD_LSB)
-#define SYNTH_SYNTH1_SPARE_PWD_SET(x)            (((x) << SYNTH_SYNTH1_SPARE_PWD_LSB) & SYNTH_SYNTH1_SPARE_PWD_MASK)
-#define SYNTH_SYNTH1_CON_VDDVCOREG_MSB           15
-#define SYNTH_SYNTH1_CON_VDDVCOREG_LSB           15
-#define SYNTH_SYNTH1_CON_VDDVCOREG_MASK          0x00008000
-#define SYNTH_SYNTH1_CON_VDDVCOREG_GET(x)        (((x) & SYNTH_SYNTH1_CON_VDDVCOREG_MASK) >> SYNTH_SYNTH1_CON_VDDVCOREG_LSB)
-#define SYNTH_SYNTH1_CON_VDDVCOREG_SET(x)        (((x) << SYNTH_SYNTH1_CON_VDDVCOREG_LSB) & SYNTH_SYNTH1_CON_VDDVCOREG_MASK)
-#define SYNTH_SYNTH1_CON_IVCOREG_MSB             14
-#define SYNTH_SYNTH1_CON_IVCOREG_LSB             14
-#define SYNTH_SYNTH1_CON_IVCOREG_MASK            0x00004000
-#define SYNTH_SYNTH1_CON_IVCOREG_GET(x)          (((x) & SYNTH_SYNTH1_CON_IVCOREG_MASK) >> SYNTH_SYNTH1_CON_IVCOREG_LSB)
-#define SYNTH_SYNTH1_CON_IVCOREG_SET(x)          (((x) << SYNTH_SYNTH1_CON_IVCOREG_LSB) & SYNTH_SYNTH1_CON_IVCOREG_MASK)
-#define SYNTH_SYNTH1_CON_IVCOBUF_MSB             13
-#define SYNTH_SYNTH1_CON_IVCOBUF_LSB             13
-#define SYNTH_SYNTH1_CON_IVCOBUF_MASK            0x00002000
-#define SYNTH_SYNTH1_CON_IVCOBUF_GET(x)          (((x) & SYNTH_SYNTH1_CON_IVCOBUF_MASK) >> SYNTH_SYNTH1_CON_IVCOBUF_LSB)
-#define SYNTH_SYNTH1_CON_IVCOBUF_SET(x)          (((x) << SYNTH_SYNTH1_CON_IVCOBUF_LSB) & SYNTH_SYNTH1_CON_IVCOBUF_MASK)
-#define SYNTH_SYNTH1_SEL_VCMONABUS_MSB           12
-#define SYNTH_SYNTH1_SEL_VCMONABUS_LSB           10
-#define SYNTH_SYNTH1_SEL_VCMONABUS_MASK          0x00001c00
-#define SYNTH_SYNTH1_SEL_VCMONABUS_GET(x)        (((x) & SYNTH_SYNTH1_SEL_VCMONABUS_MASK) >> SYNTH_SYNTH1_SEL_VCMONABUS_LSB)
-#define SYNTH_SYNTH1_SEL_VCMONABUS_SET(x)        (((x) << SYNTH_SYNTH1_SEL_VCMONABUS_LSB) & SYNTH_SYNTH1_SEL_VCMONABUS_MASK)
-#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_MSB          9
-#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB          9
-#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK         0x00000200
-#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_GET(x)       (((x) & SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK) >> SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB)
-#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_SET(x)       (((x) << SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB) & SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK)
-#define SYNTH_SYNTH1_PWUP_LODIV_PD_MSB           8
-#define SYNTH_SYNTH1_PWUP_LODIV_PD_LSB           8
-#define SYNTH_SYNTH1_PWUP_LODIV_PD_MASK          0x00000100
-#define SYNTH_SYNTH1_PWUP_LODIV_PD_GET(x)        (((x) & SYNTH_SYNTH1_PWUP_LODIV_PD_MASK) >> SYNTH_SYNTH1_PWUP_LODIV_PD_LSB)
-#define SYNTH_SYNTH1_PWUP_LODIV_PD_SET(x)        (((x) << SYNTH_SYNTH1_PWUP_LODIV_PD_LSB) & SYNTH_SYNTH1_PWUP_LODIV_PD_MASK)
-#define SYNTH_SYNTH1_PWUP_LOMIX_PD_MSB           7
-#define SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB           7
-#define SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK          0x00000080
-#define SYNTH_SYNTH1_PWUP_LOMIX_PD_GET(x)        (((x) & SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK) >> SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB)
-#define SYNTH_SYNTH1_PWUP_LOMIX_PD_SET(x)        (((x) << SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB) & SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK)
-#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MSB         6
-#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB         6
-#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK        0x00000040
-#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_GET(x)      (((x) & SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK) >> SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB)
-#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_SET(x)      (((x) << SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB) & SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK)
-#define SYNTH_SYNTH1_MONITOR_FB_MSB              5
-#define SYNTH_SYNTH1_MONITOR_FB_LSB              5
-#define SYNTH_SYNTH1_MONITOR_FB_MASK             0x00000020
-#define SYNTH_SYNTH1_MONITOR_FB_GET(x)           (((x) & SYNTH_SYNTH1_MONITOR_FB_MASK) >> SYNTH_SYNTH1_MONITOR_FB_LSB)
-#define SYNTH_SYNTH1_MONITOR_FB_SET(x)           (((x) << SYNTH_SYNTH1_MONITOR_FB_LSB) & SYNTH_SYNTH1_MONITOR_FB_MASK)
-#define SYNTH_SYNTH1_MONITOR_REF_MSB             4
-#define SYNTH_SYNTH1_MONITOR_REF_LSB             4
-#define SYNTH_SYNTH1_MONITOR_REF_MASK            0x00000010
-#define SYNTH_SYNTH1_MONITOR_REF_GET(x)          (((x) & SYNTH_SYNTH1_MONITOR_REF_MASK) >> SYNTH_SYNTH1_MONITOR_REF_LSB)
-#define SYNTH_SYNTH1_MONITOR_REF_SET(x)          (((x) << SYNTH_SYNTH1_MONITOR_REF_LSB) & SYNTH_SYNTH1_MONITOR_REF_MASK)
-#define SYNTH_SYNTH1_MONITOR_FB_DIV2_MSB         3
-#define SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB         3
-#define SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK        0x00000008
-#define SYNTH_SYNTH1_MONITOR_FB_DIV2_GET(x)      (((x) & SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK) >> SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB)
-#define SYNTH_SYNTH1_MONITOR_FB_DIV2_SET(x)      (((x) << SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB) & SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK)
-#define SYNTH_SYNTH1_MONITOR_VC2HIGH_MSB         2
-#define SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB         2
-#define SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK        0x00000004
-#define SYNTH_SYNTH1_MONITOR_VC2HIGH_GET(x)      (((x) & SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK) >> SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB)
-#define SYNTH_SYNTH1_MONITOR_VC2HIGH_SET(x)      (((x) << SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB) & SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK)
-#define SYNTH_SYNTH1_MONITOR_VC2LOW_MSB          1
-#define SYNTH_SYNTH1_MONITOR_VC2LOW_LSB          1
-#define SYNTH_SYNTH1_MONITOR_VC2LOW_MASK         0x00000002
-#define SYNTH_SYNTH1_MONITOR_VC2LOW_GET(x)       (((x) & SYNTH_SYNTH1_MONITOR_VC2LOW_MASK) >> SYNTH_SYNTH1_MONITOR_VC2LOW_LSB)
-#define SYNTH_SYNTH1_MONITOR_VC2LOW_SET(x)       (((x) << SYNTH_SYNTH1_MONITOR_VC2LOW_LSB) & SYNTH_SYNTH1_MONITOR_VC2LOW_MASK)
-#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MSB   0
-#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB   0
-#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK  0x00000001
-#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_GET(x) (((x) & SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK) >> SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB)
-#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_SET(x) (((x) << SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB) & SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK)
-
-#define SYNTH_SYNTH2_ADDRESS                     0x00000004
-#define SYNTH_SYNTH2_OFFSET                      0x00000004
-#define SYNTH_SYNTH2_VC_CAL_REF_MSB              31
-#define SYNTH_SYNTH2_VC_CAL_REF_LSB              29
-#define SYNTH_SYNTH2_VC_CAL_REF_MASK             0xe0000000
-#define SYNTH_SYNTH2_VC_CAL_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_CAL_REF_MASK) >> SYNTH_SYNTH2_VC_CAL_REF_LSB)
-#define SYNTH_SYNTH2_VC_CAL_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_CAL_REF_LSB) & SYNTH_SYNTH2_VC_CAL_REF_MASK)
-#define SYNTH_SYNTH2_VC_HI_REF_MSB               28
-#define SYNTH_SYNTH2_VC_HI_REF_LSB               26
-#define SYNTH_SYNTH2_VC_HI_REF_MASK              0x1c000000
-#define SYNTH_SYNTH2_VC_HI_REF_GET(x)            (((x) & SYNTH_SYNTH2_VC_HI_REF_MASK) >> SYNTH_SYNTH2_VC_HI_REF_LSB)
-#define SYNTH_SYNTH2_VC_HI_REF_SET(x)            (((x) << SYNTH_SYNTH2_VC_HI_REF_LSB) & SYNTH_SYNTH2_VC_HI_REF_MASK)
-#define SYNTH_SYNTH2_VC_MID_REF_MSB              25
-#define SYNTH_SYNTH2_VC_MID_REF_LSB              23
-#define SYNTH_SYNTH2_VC_MID_REF_MASK             0x03800000
-#define SYNTH_SYNTH2_VC_MID_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_MID_REF_MASK) >> SYNTH_SYNTH2_VC_MID_REF_LSB)
-#define SYNTH_SYNTH2_VC_MID_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_MID_REF_LSB) & SYNTH_SYNTH2_VC_MID_REF_MASK)
-#define SYNTH_SYNTH2_VC_LOW_REF_MSB              22
-#define SYNTH_SYNTH2_VC_LOW_REF_LSB              20
-#define SYNTH_SYNTH2_VC_LOW_REF_MASK             0x00700000
-#define SYNTH_SYNTH2_VC_LOW_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_LOW_REF_MASK) >> SYNTH_SYNTH2_VC_LOW_REF_LSB)
-#define SYNTH_SYNTH2_VC_LOW_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_LOW_REF_LSB) & SYNTH_SYNTH2_VC_LOW_REF_MASK)
-#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MSB        19
-#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB        15
-#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK       0x000f8000
-#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_GET(x)     (((x) & SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK) >> SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB)
-#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_SET(x)     (((x) << SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB) & SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK)
-#define SYNTH_SYNTH2_LOOP_CP_MSB                 14
-#define SYNTH_SYNTH2_LOOP_CP_LSB                 10
-#define SYNTH_SYNTH2_LOOP_CP_MASK                0x00007c00
-#define SYNTH_SYNTH2_LOOP_CP_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_CP_MASK) >> SYNTH_SYNTH2_LOOP_CP_LSB)
-#define SYNTH_SYNTH2_LOOP_CP_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_CP_LSB) & SYNTH_SYNTH2_LOOP_CP_MASK)
-#define SYNTH_SYNTH2_LOOP_RS_MSB                 9
-#define SYNTH_SYNTH2_LOOP_RS_LSB                 5
-#define SYNTH_SYNTH2_LOOP_RS_MASK                0x000003e0
-#define SYNTH_SYNTH2_LOOP_RS_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_RS_MASK) >> SYNTH_SYNTH2_LOOP_RS_LSB)
-#define SYNTH_SYNTH2_LOOP_RS_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_RS_LSB) & SYNTH_SYNTH2_LOOP_RS_MASK)
-#define SYNTH_SYNTH2_LOOP_CS_MSB                 4
-#define SYNTH_SYNTH2_LOOP_CS_LSB                 3
-#define SYNTH_SYNTH2_LOOP_CS_MASK                0x00000018
-#define SYNTH_SYNTH2_LOOP_CS_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_CS_MASK) >> SYNTH_SYNTH2_LOOP_CS_LSB)
-#define SYNTH_SYNTH2_LOOP_CS_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_CS_LSB) & SYNTH_SYNTH2_LOOP_CS_MASK)
-#define SYNTH_SYNTH2_SPARE_BITS_MSB              2
-#define SYNTH_SYNTH2_SPARE_BITS_LSB              0
-#define SYNTH_SYNTH2_SPARE_BITS_MASK             0x00000007
-#define SYNTH_SYNTH2_SPARE_BITS_GET(x)           (((x) & SYNTH_SYNTH2_SPARE_BITS_MASK) >> SYNTH_SYNTH2_SPARE_BITS_LSB)
-#define SYNTH_SYNTH2_SPARE_BITS_SET(x)           (((x) << SYNTH_SYNTH2_SPARE_BITS_LSB) & SYNTH_SYNTH2_SPARE_BITS_MASK)
-
-#define SYNTH_SYNTH3_ADDRESS                     0x00000008
-#define SYNTH_SYNTH3_OFFSET                      0x00000008
-#define SYNTH_SYNTH3_DIS_CLK_XTAL_MSB            31
-#define SYNTH_SYNTH3_DIS_CLK_XTAL_LSB            31
-#define SYNTH_SYNTH3_DIS_CLK_XTAL_MASK           0x80000000
-#define SYNTH_SYNTH3_DIS_CLK_XTAL_GET(x)         (((x) & SYNTH_SYNTH3_DIS_CLK_XTAL_MASK) >> SYNTH_SYNTH3_DIS_CLK_XTAL_LSB)
-#define SYNTH_SYNTH3_DIS_CLK_XTAL_SET(x)         (((x) << SYNTH_SYNTH3_DIS_CLK_XTAL_LSB) & SYNTH_SYNTH3_DIS_CLK_XTAL_MASK)
-#define SYNTH_SYNTH3_SEL_CLK_DIV2_MSB            30
-#define SYNTH_SYNTH3_SEL_CLK_DIV2_LSB            30
-#define SYNTH_SYNTH3_SEL_CLK_DIV2_MASK           0x40000000
-#define SYNTH_SYNTH3_SEL_CLK_DIV2_GET(x)         (((x) & SYNTH_SYNTH3_SEL_CLK_DIV2_MASK) >> SYNTH_SYNTH3_SEL_CLK_DIV2_LSB)
-#define SYNTH_SYNTH3_SEL_CLK_DIV2_SET(x)         (((x) << SYNTH_SYNTH3_SEL_CLK_DIV2_LSB) & SYNTH_SYNTH3_SEL_CLK_DIV2_MASK)
-#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MSB       29
-#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB       24
-#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK      0x3f000000
-#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_GET(x)    (((x) & SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK) >> SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB)
-#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_SET(x)    (((x) << SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB) & SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK)
-#define SYNTH_SYNTH3_WAIT_PWRUP_MSB              23
-#define SYNTH_SYNTH3_WAIT_PWRUP_LSB              18
-#define SYNTH_SYNTH3_WAIT_PWRUP_MASK             0x00fc0000
-#define SYNTH_SYNTH3_WAIT_PWRUP_GET(x)           (((x) & SYNTH_SYNTH3_WAIT_PWRUP_MASK) >> SYNTH_SYNTH3_WAIT_PWRUP_LSB)
-#define SYNTH_SYNTH3_WAIT_PWRUP_SET(x)           (((x) << SYNTH_SYNTH3_WAIT_PWRUP_LSB) & SYNTH_SYNTH3_WAIT_PWRUP_MASK)
-#define SYNTH_SYNTH3_WAIT_CAL_BIN_MSB            17
-#define SYNTH_SYNTH3_WAIT_CAL_BIN_LSB            12
-#define SYNTH_SYNTH3_WAIT_CAL_BIN_MASK           0x0003f000
-#define SYNTH_SYNTH3_WAIT_CAL_BIN_GET(x)         (((x) & SYNTH_SYNTH3_WAIT_CAL_BIN_MASK) >> SYNTH_SYNTH3_WAIT_CAL_BIN_LSB)
-#define SYNTH_SYNTH3_WAIT_CAL_BIN_SET(x)         (((x) << SYNTH_SYNTH3_WAIT_CAL_BIN_LSB) & SYNTH_SYNTH3_WAIT_CAL_BIN_MASK)
-#define SYNTH_SYNTH3_WAIT_CAL_LIN_MSB            11
-#define SYNTH_SYNTH3_WAIT_CAL_LIN_LSB            6
-#define SYNTH_SYNTH3_WAIT_CAL_LIN_MASK           0x00000fc0
-#define SYNTH_SYNTH3_WAIT_CAL_LIN_GET(x)         (((x) & SYNTH_SYNTH3_WAIT_CAL_LIN_MASK) >> SYNTH_SYNTH3_WAIT_CAL_LIN_LSB)
-#define SYNTH_SYNTH3_WAIT_CAL_LIN_SET(x)         (((x) << SYNTH_SYNTH3_WAIT_CAL_LIN_LSB) & SYNTH_SYNTH3_WAIT_CAL_LIN_MASK)
-#define SYNTH_SYNTH3_WAIT_VC_CHECK_MSB           5
-#define SYNTH_SYNTH3_WAIT_VC_CHECK_LSB           0
-#define SYNTH_SYNTH3_WAIT_VC_CHECK_MASK          0x0000003f
-#define SYNTH_SYNTH3_WAIT_VC_CHECK_GET(x)        (((x) & SYNTH_SYNTH3_WAIT_VC_CHECK_MASK) >> SYNTH_SYNTH3_WAIT_VC_CHECK_LSB)
-#define SYNTH_SYNTH3_WAIT_VC_CHECK_SET(x)        (((x) << SYNTH_SYNTH3_WAIT_VC_CHECK_LSB) & SYNTH_SYNTH3_WAIT_VC_CHECK_MASK)
-
-#define SYNTH_SYNTH4_ADDRESS                     0x0000000c
-#define SYNTH_SYNTH4_OFFSET                      0x0000000c
-#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MSB       31
-#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB       31
-#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK      0x80000000
-#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_GET(x)    (((x) & SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK) >> SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB)
-#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_SET(x)    (((x) << SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB) & SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK)
-#define SYNTH_SYNTH4_DIS_LOSTVC_MSB              30
-#define SYNTH_SYNTH4_DIS_LOSTVC_LSB              30
-#define SYNTH_SYNTH4_DIS_LOSTVC_MASK             0x40000000
-#define SYNTH_SYNTH4_DIS_LOSTVC_GET(x)           (((x) & SYNTH_SYNTH4_DIS_LOSTVC_MASK) >> SYNTH_SYNTH4_DIS_LOSTVC_LSB)
-#define SYNTH_SYNTH4_DIS_LOSTVC_SET(x)           (((x) << SYNTH_SYNTH4_DIS_LOSTVC_LSB) & SYNTH_SYNTH4_DIS_LOSTVC_MASK)
-#define SYNTH_SYNTH4_ALWAYS_SHORTR_MSB           29
-#define SYNTH_SYNTH4_ALWAYS_SHORTR_LSB           29
-#define SYNTH_SYNTH4_ALWAYS_SHORTR_MASK          0x20000000
-#define SYNTH_SYNTH4_ALWAYS_SHORTR_GET(x)        (((x) & SYNTH_SYNTH4_ALWAYS_SHORTR_MASK) >> SYNTH_SYNTH4_ALWAYS_SHORTR_LSB)
-#define SYNTH_SYNTH4_ALWAYS_SHORTR_SET(x)        (((x) << SYNTH_SYNTH4_ALWAYS_SHORTR_LSB) & SYNTH_SYNTH4_ALWAYS_SHORTR_MASK)
-#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MSB     28
-#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB     28
-#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK    0x10000000
-#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_GET(x)  (((x) & SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK) >> SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB)
-#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_SET(x)  (((x) << SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB) & SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK)
-#define SYNTH_SYNTH4_FORCE_PINVC_MSB             27
-#define SYNTH_SYNTH4_FORCE_PINVC_LSB             27
-#define SYNTH_SYNTH4_FORCE_PINVC_MASK            0x08000000
-#define SYNTH_SYNTH4_FORCE_PINVC_GET(x)          (((x) & SYNTH_SYNTH4_FORCE_PINVC_MASK) >> SYNTH_SYNTH4_FORCE_PINVC_LSB)
-#define SYNTH_SYNTH4_FORCE_PINVC_SET(x)          (((x) << SYNTH_SYNTH4_FORCE_PINVC_LSB) & SYNTH_SYNTH4_FORCE_PINVC_MASK)
-#define SYNTH_SYNTH4_FORCE_VCOCAP_MSB            26
-#define SYNTH_SYNTH4_FORCE_VCOCAP_LSB            26
-#define SYNTH_SYNTH4_FORCE_VCOCAP_MASK           0x04000000
-#define SYNTH_SYNTH4_FORCE_VCOCAP_GET(x)         (((x) & SYNTH_SYNTH4_FORCE_VCOCAP_MASK) >> SYNTH_SYNTH4_FORCE_VCOCAP_LSB)
-#define SYNTH_SYNTH4_FORCE_VCOCAP_SET(x)         (((x) << SYNTH_SYNTH4_FORCE_VCOCAP_LSB) & SYNTH_SYNTH4_FORCE_VCOCAP_MASK)
-#define SYNTH_SYNTH4_VCOCAP_OVR_MSB              25
-#define SYNTH_SYNTH4_VCOCAP_OVR_LSB              18
-#define SYNTH_SYNTH4_VCOCAP_OVR_MASK             0x03fc0000
-#define SYNTH_SYNTH4_VCOCAP_OVR_GET(x)           (((x) & SYNTH_SYNTH4_VCOCAP_OVR_MASK) >> SYNTH_SYNTH4_VCOCAP_OVR_LSB)
-#define SYNTH_SYNTH4_VCOCAP_OVR_SET(x)           (((x) << SYNTH_SYNTH4_VCOCAP_OVR_LSB) & SYNTH_SYNTH4_VCOCAP_OVR_MASK)
-#define SYNTH_SYNTH4_VCOCAPPULLUP_MSB            17
-#define SYNTH_SYNTH4_VCOCAPPULLUP_LSB            17
-#define SYNTH_SYNTH4_VCOCAPPULLUP_MASK           0x00020000
-#define SYNTH_SYNTH4_VCOCAPPULLUP_GET(x)         (((x) & SYNTH_SYNTH4_VCOCAPPULLUP_MASK) >> SYNTH_SYNTH4_VCOCAPPULLUP_LSB)
-#define SYNTH_SYNTH4_VCOCAPPULLUP_SET(x)         (((x) << SYNTH_SYNTH4_VCOCAPPULLUP_LSB) & SYNTH_SYNTH4_VCOCAPPULLUP_MASK)
-#define SYNTH_SYNTH4_REFDIVSEL_MSB               16
-#define SYNTH_SYNTH4_REFDIVSEL_LSB               15
-#define SYNTH_SYNTH4_REFDIVSEL_MASK              0x00018000
-#define SYNTH_SYNTH4_REFDIVSEL_GET(x)            (((x) & SYNTH_SYNTH4_REFDIVSEL_MASK) >> SYNTH_SYNTH4_REFDIVSEL_LSB)
-#define SYNTH_SYNTH4_REFDIVSEL_SET(x)            (((x) << SYNTH_SYNTH4_REFDIVSEL_LSB) & SYNTH_SYNTH4_REFDIVSEL_MASK)
-#define SYNTH_SYNTH4_PFDDELAY_MSB                14
-#define SYNTH_SYNTH4_PFDDELAY_LSB                14
-#define SYNTH_SYNTH4_PFDDELAY_MASK               0x00004000
-#define SYNTH_SYNTH4_PFDDELAY_GET(x)             (((x) & SYNTH_SYNTH4_PFDDELAY_MASK) >> SYNTH_SYNTH4_PFDDELAY_LSB)
-#define SYNTH_SYNTH4_PFDDELAY_SET(x)             (((x) << SYNTH_SYNTH4_PFDDELAY_LSB) & SYNTH_SYNTH4_PFDDELAY_MASK)
-#define SYNTH_SYNTH4_PFD_DISABLE_MSB             13
-#define SYNTH_SYNTH4_PFD_DISABLE_LSB             13
-#define SYNTH_SYNTH4_PFD_DISABLE_MASK            0x00002000
-#define SYNTH_SYNTH4_PFD_DISABLE_GET(x)          (((x) & SYNTH_SYNTH4_PFD_DISABLE_MASK) >> SYNTH_SYNTH4_PFD_DISABLE_LSB)
-#define SYNTH_SYNTH4_PFD_DISABLE_SET(x)          (((x) << SYNTH_SYNTH4_PFD_DISABLE_LSB) & SYNTH_SYNTH4_PFD_DISABLE_MASK)
-#define SYNTH_SYNTH4_PRESCSEL_MSB                12
-#define SYNTH_SYNTH4_PRESCSEL_LSB                11
-#define SYNTH_SYNTH4_PRESCSEL_MASK               0x00001800
-#define SYNTH_SYNTH4_PRESCSEL_GET(x)             (((x) & SYNTH_SYNTH4_PRESCSEL_MASK) >> SYNTH_SYNTH4_PRESCSEL_LSB)
-#define SYNTH_SYNTH4_PRESCSEL_SET(x)             (((x) << SYNTH_SYNTH4_PRESCSEL_LSB) & SYNTH_SYNTH4_PRESCSEL_MASK)
-#define SYNTH_SYNTH4_RESET_PRESC_MSB             10
-#define SYNTH_SYNTH4_RESET_PRESC_LSB             10
-#define SYNTH_SYNTH4_RESET_PRESC_MASK            0x00000400
-#define SYNTH_SYNTH4_RESET_PRESC_GET(x)          (((x) & SYNTH_SYNTH4_RESET_PRESC_MASK) >> SYNTH_SYNTH4_RESET_PRESC_LSB)
-#define SYNTH_SYNTH4_RESET_PRESC_SET(x)          (((x) << SYNTH_SYNTH4_RESET_PRESC_LSB) & SYNTH_SYNTH4_RESET_PRESC_MASK)
-#define SYNTH_SYNTH4_SDM_DISABLE_MSB             9
-#define SYNTH_SYNTH4_SDM_DISABLE_LSB             9
-#define SYNTH_SYNTH4_SDM_DISABLE_MASK            0x00000200
-#define SYNTH_SYNTH4_SDM_DISABLE_GET(x)          (((x) & SYNTH_SYNTH4_SDM_DISABLE_MASK) >> SYNTH_SYNTH4_SDM_DISABLE_LSB)
-#define SYNTH_SYNTH4_SDM_DISABLE_SET(x)          (((x) << SYNTH_SYNTH4_SDM_DISABLE_LSB) & SYNTH_SYNTH4_SDM_DISABLE_MASK)
-#define SYNTH_SYNTH4_SDM_MODE_MSB                8
-#define SYNTH_SYNTH4_SDM_MODE_LSB                8
-#define SYNTH_SYNTH4_SDM_MODE_MASK               0x00000100
-#define SYNTH_SYNTH4_SDM_MODE_GET(x)             (((x) & SYNTH_SYNTH4_SDM_MODE_MASK) >> SYNTH_SYNTH4_SDM_MODE_LSB)
-#define SYNTH_SYNTH4_SDM_MODE_SET(x)             (((x) << SYNTH_SYNTH4_SDM_MODE_LSB) & SYNTH_SYNTH4_SDM_MODE_MASK)
-#define SYNTH_SYNTH4_SDM_DITHER_MSB              7
-#define SYNTH_SYNTH4_SDM_DITHER_LSB              6
-#define SYNTH_SYNTH4_SDM_DITHER_MASK             0x000000c0
-#define SYNTH_SYNTH4_SDM_DITHER_GET(x)           (((x) & SYNTH_SYNTH4_SDM_DITHER_MASK) >> SYNTH_SYNTH4_SDM_DITHER_LSB)
-#define SYNTH_SYNTH4_SDM_DITHER_SET(x)           (((x) << SYNTH_SYNTH4_SDM_DITHER_LSB) & SYNTH_SYNTH4_SDM_DITHER_MASK)
-#define SYNTH_SYNTH4_PSCOUNT_FBSEL_MSB           5
-#define SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB           5
-#define SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK          0x00000020
-#define SYNTH_SYNTH4_PSCOUNT_FBSEL_GET(x)        (((x) & SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK) >> SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB)
-#define SYNTH_SYNTH4_PSCOUNT_FBSEL_SET(x)        (((x) << SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB) & SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK)
-#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MSB        4
-#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB        4
-#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK       0x00000010
-#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_GET(x)     (((x) & SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK) >> SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB)
-#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_SET(x)     (((x) << SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB) & SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK)
-#define SYNTH_SYNTH4_SPARE_MISC_MSB              3
-#define SYNTH_SYNTH4_SPARE_MISC_LSB              2
-#define SYNTH_SYNTH4_SPARE_MISC_MASK             0x0000000c
-#define SYNTH_SYNTH4_SPARE_MISC_GET(x)           (((x) & SYNTH_SYNTH4_SPARE_MISC_MASK) >> SYNTH_SYNTH4_SPARE_MISC_LSB)
-#define SYNTH_SYNTH4_SPARE_MISC_SET(x)           (((x) << SYNTH_SYNTH4_SPARE_MISC_LSB) & SYNTH_SYNTH4_SPARE_MISC_MASK)
-#define SYNTH_SYNTH4_LONGSHIFTSEL_MSB            1
-#define SYNTH_SYNTH4_LONGSHIFTSEL_LSB            1
-#define SYNTH_SYNTH4_LONGSHIFTSEL_MASK           0x00000002
-#define SYNTH_SYNTH4_LONGSHIFTSEL_GET(x)         (((x) & SYNTH_SYNTH4_LONGSHIFTSEL_MASK) >> SYNTH_SYNTH4_LONGSHIFTSEL_LSB)
-#define SYNTH_SYNTH4_LONGSHIFTSEL_SET(x)         (((x) << SYNTH_SYNTH4_LONGSHIFTSEL_LSB) & SYNTH_SYNTH4_LONGSHIFTSEL_MASK)
-#define SYNTH_SYNTH4_FORCE_SHIFTREG_MSB          0
-#define SYNTH_SYNTH4_FORCE_SHIFTREG_LSB          0
-#define SYNTH_SYNTH4_FORCE_SHIFTREG_MASK         0x00000001
-#define SYNTH_SYNTH4_FORCE_SHIFTREG_GET(x)       (((x) & SYNTH_SYNTH4_FORCE_SHIFTREG_MASK) >> SYNTH_SYNTH4_FORCE_SHIFTREG_LSB)
-#define SYNTH_SYNTH4_FORCE_SHIFTREG_SET(x)       (((x) << SYNTH_SYNTH4_FORCE_SHIFTREG_LSB) & SYNTH_SYNTH4_FORCE_SHIFTREG_MASK)
-
-#define SYNTH_SYNTH5_ADDRESS                     0x00000010
-#define SYNTH_SYNTH5_OFFSET                      0x00000010
-#define SYNTH_SYNTH5_LOOP_IP0_MSB                31
-#define SYNTH_SYNTH5_LOOP_IP0_LSB                28
-#define SYNTH_SYNTH5_LOOP_IP0_MASK               0xf0000000
-#define SYNTH_SYNTH5_LOOP_IP0_GET(x)             (((x) & SYNTH_SYNTH5_LOOP_IP0_MASK) >> SYNTH_SYNTH5_LOOP_IP0_LSB)
-#define SYNTH_SYNTH5_LOOP_IP0_SET(x)             (((x) << SYNTH_SYNTH5_LOOP_IP0_LSB) & SYNTH_SYNTH5_LOOP_IP0_MASK)
-#define SYNTH_SYNTH5_SLOPE_IP_MSB                27
-#define SYNTH_SYNTH5_SLOPE_IP_LSB                25
-#define SYNTH_SYNTH5_SLOPE_IP_MASK               0x0e000000
-#define SYNTH_SYNTH5_SLOPE_IP_GET(x)             (((x) & SYNTH_SYNTH5_SLOPE_IP_MASK) >> SYNTH_SYNTH5_SLOPE_IP_LSB)
-#define SYNTH_SYNTH5_SLOPE_IP_SET(x)             (((x) << SYNTH_SYNTH5_SLOPE_IP_LSB) & SYNTH_SYNTH5_SLOPE_IP_MASK)
-#define SYNTH_SYNTH5_CPBIAS_MSB                  24
-#define SYNTH_SYNTH5_CPBIAS_LSB                  23
-#define SYNTH_SYNTH5_CPBIAS_MASK                 0x01800000
-#define SYNTH_SYNTH5_CPBIAS_GET(x)               (((x) & SYNTH_SYNTH5_CPBIAS_MASK) >> SYNTH_SYNTH5_CPBIAS_LSB)
-#define SYNTH_SYNTH5_CPBIAS_SET(x)               (((x) << SYNTH_SYNTH5_CPBIAS_LSB) & SYNTH_SYNTH5_CPBIAS_MASK)
-#define SYNTH_SYNTH5_CPSTEERING_EN_MSB           22
-#define SYNTH_SYNTH5_CPSTEERING_EN_LSB           22
-#define SYNTH_SYNTH5_CPSTEERING_EN_MASK          0x00400000
-#define SYNTH_SYNTH5_CPSTEERING_EN_GET(x)        (((x) & SYNTH_SYNTH5_CPSTEERING_EN_MASK) >> SYNTH_SYNTH5_CPSTEERING_EN_LSB)
-#define SYNTH_SYNTH5_CPSTEERING_EN_SET(x)        (((x) << SYNTH_SYNTH5_CPSTEERING_EN_LSB) & SYNTH_SYNTH5_CPSTEERING_EN_MASK)
-#define SYNTH_SYNTH5_CPLOWLK_MSB                 21
-#define SYNTH_SYNTH5_CPLOWLK_LSB                 21
-#define SYNTH_SYNTH5_CPLOWLK_MASK                0x00200000
-#define SYNTH_SYNTH5_CPLOWLK_GET(x)              (((x) & SYNTH_SYNTH5_CPLOWLK_MASK) >> SYNTH_SYNTH5_CPLOWLK_LSB)
-#define SYNTH_SYNTH5_CPLOWLK_SET(x)              (((x) << SYNTH_SYNTH5_CPLOWLK_LSB) & SYNTH_SYNTH5_CPLOWLK_MASK)
-#define SYNTH_SYNTH5_LOOPLEAKCUR_MSB             20
-#define SYNTH_SYNTH5_LOOPLEAKCUR_LSB             17
-#define SYNTH_SYNTH5_LOOPLEAKCUR_MASK            0x001e0000
-#define SYNTH_SYNTH5_LOOPLEAKCUR_GET(x)          (((x) & SYNTH_SYNTH5_LOOPLEAKCUR_MASK) >> SYNTH_SYNTH5_LOOPLEAKCUR_LSB)
-#define SYNTH_SYNTH5_LOOPLEAKCUR_SET(x)          (((x) << SYNTH_SYNTH5_LOOPLEAKCUR_LSB) & SYNTH_SYNTH5_LOOPLEAKCUR_MASK)
-#define SYNTH_SYNTH5_CAPRANGE1_MSB               16
-#define SYNTH_SYNTH5_CAPRANGE1_LSB               13
-#define SYNTH_SYNTH5_CAPRANGE1_MASK              0x0001e000
-#define SYNTH_SYNTH5_CAPRANGE1_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE1_MASK) >> SYNTH_SYNTH5_CAPRANGE1_LSB)
-#define SYNTH_SYNTH5_CAPRANGE1_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE1_LSB) & SYNTH_SYNTH5_CAPRANGE1_MASK)
-#define SYNTH_SYNTH5_CAPRANGE2_MSB               12
-#define SYNTH_SYNTH5_CAPRANGE2_LSB               9
-#define SYNTH_SYNTH5_CAPRANGE2_MASK              0x00001e00
-#define SYNTH_SYNTH5_CAPRANGE2_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE2_MASK) >> SYNTH_SYNTH5_CAPRANGE2_LSB)
-#define SYNTH_SYNTH5_CAPRANGE2_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE2_LSB) & SYNTH_SYNTH5_CAPRANGE2_MASK)
-#define SYNTH_SYNTH5_CAPRANGE3_MSB               8
-#define SYNTH_SYNTH5_CAPRANGE3_LSB               5
-#define SYNTH_SYNTH5_CAPRANGE3_MASK              0x000001e0
-#define SYNTH_SYNTH5_CAPRANGE3_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE3_MASK) >> SYNTH_SYNTH5_CAPRANGE3_LSB)
-#define SYNTH_SYNTH5_CAPRANGE3_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE3_LSB) & SYNTH_SYNTH5_CAPRANGE3_MASK)
-#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MSB       4
-#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB       4
-#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK      0x00000010
-#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_GET(x)    (((x) & SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK) >> SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB)
-#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_SET(x)    (((x) << SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB) & SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK)
-#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MSB         3
-#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB         2
-#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK        0x0000000c
-#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_GET(x)      (((x) & SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK) >> SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB)
-#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_SET(x)      (((x) << SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB) & SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK)
-#define SYNTH_SYNTH5_SPARE_MSB                   1
-#define SYNTH_SYNTH5_SPARE_LSB                   0
-#define SYNTH_SYNTH5_SPARE_MASK                  0x00000003
-#define SYNTH_SYNTH5_SPARE_GET(x)                (((x) & SYNTH_SYNTH5_SPARE_MASK) >> SYNTH_SYNTH5_SPARE_LSB)
-#define SYNTH_SYNTH5_SPARE_SET(x)                (((x) << SYNTH_SYNTH5_SPARE_LSB) & SYNTH_SYNTH5_SPARE_MASK)
-
-#define SYNTH_SYNTH6_ADDRESS                     0x00000014
-#define SYNTH_SYNTH6_OFFSET                      0x00000014
-#define SYNTH_SYNTH6_IRCP_MSB                    31
-#define SYNTH_SYNTH6_IRCP_LSB                    29
-#define SYNTH_SYNTH6_IRCP_MASK                   0xe0000000
-#define SYNTH_SYNTH6_IRCP_GET(x)                 (((x) & SYNTH_SYNTH6_IRCP_MASK) >> SYNTH_SYNTH6_IRCP_LSB)
-#define SYNTH_SYNTH6_IRCP_SET(x)                 (((x) << SYNTH_SYNTH6_IRCP_LSB) & SYNTH_SYNTH6_IRCP_MASK)
-#define SYNTH_SYNTH6_IRVCMON_MSB                 28
-#define SYNTH_SYNTH6_IRVCMON_LSB                 26
-#define SYNTH_SYNTH6_IRVCMON_MASK                0x1c000000
-#define SYNTH_SYNTH6_IRVCMON_GET(x)              (((x) & SYNTH_SYNTH6_IRVCMON_MASK) >> SYNTH_SYNTH6_IRVCMON_LSB)
-#define SYNTH_SYNTH6_IRVCMON_SET(x)              (((x) << SYNTH_SYNTH6_IRVCMON_LSB) & SYNTH_SYNTH6_IRVCMON_MASK)
-#define SYNTH_SYNTH6_IRSPARE_MSB                 25
-#define SYNTH_SYNTH6_IRSPARE_LSB                 23
-#define SYNTH_SYNTH6_IRSPARE_MASK                0x03800000
-#define SYNTH_SYNTH6_IRSPARE_GET(x)              (((x) & SYNTH_SYNTH6_IRSPARE_MASK) >> SYNTH_SYNTH6_IRSPARE_LSB)
-#define SYNTH_SYNTH6_IRSPARE_SET(x)              (((x) << SYNTH_SYNTH6_IRSPARE_LSB) & SYNTH_SYNTH6_IRSPARE_MASK)
-#define SYNTH_SYNTH6_ICPRESC_MSB                 22
-#define SYNTH_SYNTH6_ICPRESC_LSB                 20
-#define SYNTH_SYNTH6_ICPRESC_MASK                0x00700000
-#define SYNTH_SYNTH6_ICPRESC_GET(x)              (((x) & SYNTH_SYNTH6_ICPRESC_MASK) >> SYNTH_SYNTH6_ICPRESC_LSB)
-#define SYNTH_SYNTH6_ICPRESC_SET(x)              (((x) << SYNTH_SYNTH6_ICPRESC_LSB) & SYNTH_SYNTH6_ICPRESC_MASK)
-#define SYNTH_SYNTH6_ICLODIV_MSB                 19
-#define SYNTH_SYNTH6_ICLODIV_LSB                 17
-#define SYNTH_SYNTH6_ICLODIV_MASK                0x000e0000
-#define SYNTH_SYNTH6_ICLODIV_GET(x)              (((x) & SYNTH_SYNTH6_ICLODIV_MASK) >> SYNTH_SYNTH6_ICLODIV_LSB)
-#define SYNTH_SYNTH6_ICLODIV_SET(x)              (((x) << SYNTH_SYNTH6_ICLODIV_LSB) & SYNTH_SYNTH6_ICLODIV_MASK)
-#define SYNTH_SYNTH6_ICLOMIX_MSB                 16
-#define SYNTH_SYNTH6_ICLOMIX_LSB                 14
-#define SYNTH_SYNTH6_ICLOMIX_MASK                0x0001c000
-#define SYNTH_SYNTH6_ICLOMIX_GET(x)              (((x) & SYNTH_SYNTH6_ICLOMIX_MASK) >> SYNTH_SYNTH6_ICLOMIX_LSB)
-#define SYNTH_SYNTH6_ICLOMIX_SET(x)              (((x) << SYNTH_SYNTH6_ICLOMIX_LSB) & SYNTH_SYNTH6_ICLOMIX_MASK)
-#define SYNTH_SYNTH6_ICSPAREA_MSB                13
-#define SYNTH_SYNTH6_ICSPAREA_LSB                11
-#define SYNTH_SYNTH6_ICSPAREA_MASK               0x00003800
-#define SYNTH_SYNTH6_ICSPAREA_GET(x)             (((x) & SYNTH_SYNTH6_ICSPAREA_MASK) >> SYNTH_SYNTH6_ICSPAREA_LSB)
-#define SYNTH_SYNTH6_ICSPAREA_SET(x)             (((x) << SYNTH_SYNTH6_ICSPAREA_LSB) & SYNTH_SYNTH6_ICSPAREA_MASK)
-#define SYNTH_SYNTH6_ICSPAREB_MSB                10
-#define SYNTH_SYNTH6_ICSPAREB_LSB                8
-#define SYNTH_SYNTH6_ICSPAREB_MASK               0x00000700
-#define SYNTH_SYNTH6_ICSPAREB_GET(x)             (((x) & SYNTH_SYNTH6_ICSPAREB_MASK) >> SYNTH_SYNTH6_ICSPAREB_LSB)
-#define SYNTH_SYNTH6_ICSPAREB_SET(x)             (((x) << SYNTH_SYNTH6_ICSPAREB_LSB) & SYNTH_SYNTH6_ICSPAREB_MASK)
-#define SYNTH_SYNTH6_ICVCO_MSB                   7
-#define SYNTH_SYNTH6_ICVCO_LSB                   5
-#define SYNTH_SYNTH6_ICVCO_MASK                  0x000000e0
-#define SYNTH_SYNTH6_ICVCO_GET(x)                (((x) & SYNTH_SYNTH6_ICVCO_MASK) >> SYNTH_SYNTH6_ICVCO_LSB)
-#define SYNTH_SYNTH6_ICVCO_SET(x)                (((x) << SYNTH_SYNTH6_ICVCO_LSB) & SYNTH_SYNTH6_ICVCO_MASK)
-#define SYNTH_SYNTH6_VCOBUFBIAS_MSB              4
-#define SYNTH_SYNTH6_VCOBUFBIAS_LSB              3
-#define SYNTH_SYNTH6_VCOBUFBIAS_MASK             0x00000018
-#define SYNTH_SYNTH6_VCOBUFBIAS_GET(x)           (((x) & SYNTH_SYNTH6_VCOBUFBIAS_MASK) >> SYNTH_SYNTH6_VCOBUFBIAS_LSB)
-#define SYNTH_SYNTH6_VCOBUFBIAS_SET(x)           (((x) << SYNTH_SYNTH6_VCOBUFBIAS_LSB) & SYNTH_SYNTH6_VCOBUFBIAS_MASK)
-#define SYNTH_SYNTH6_SPARE_BIAS_MSB              2
-#define SYNTH_SYNTH6_SPARE_BIAS_LSB              0
-#define SYNTH_SYNTH6_SPARE_BIAS_MASK             0x00000007
-#define SYNTH_SYNTH6_SPARE_BIAS_GET(x)           (((x) & SYNTH_SYNTH6_SPARE_BIAS_MASK) >> SYNTH_SYNTH6_SPARE_BIAS_LSB)
-#define SYNTH_SYNTH6_SPARE_BIAS_SET(x)           (((x) << SYNTH_SYNTH6_SPARE_BIAS_LSB) & SYNTH_SYNTH6_SPARE_BIAS_MASK)
-
-#define SYNTH_SYNTH7_ADDRESS                     0x00000018
-#define SYNTH_SYNTH7_OFFSET                      0x00000018
-#define SYNTH_SYNTH7_SYNTH_ON_MSB                31
-#define SYNTH_SYNTH7_SYNTH_ON_LSB                31
-#define SYNTH_SYNTH7_SYNTH_ON_MASK               0x80000000
-#define SYNTH_SYNTH7_SYNTH_ON_GET(x)             (((x) & SYNTH_SYNTH7_SYNTH_ON_MASK) >> SYNTH_SYNTH7_SYNTH_ON_LSB)
-#define SYNTH_SYNTH7_SYNTH_ON_SET(x)             (((x) << SYNTH_SYNTH7_SYNTH_ON_LSB) & SYNTH_SYNTH7_SYNTH_ON_MASK)
-#define SYNTH_SYNTH7_SYNTH_SM_STATE_MSB          30
-#define SYNTH_SYNTH7_SYNTH_SM_STATE_LSB          27
-#define SYNTH_SYNTH7_SYNTH_SM_STATE_MASK         0x78000000
-#define SYNTH_SYNTH7_SYNTH_SM_STATE_GET(x)       (((x) & SYNTH_SYNTH7_SYNTH_SM_STATE_MASK) >> SYNTH_SYNTH7_SYNTH_SM_STATE_LSB)
-#define SYNTH_SYNTH7_SYNTH_SM_STATE_SET(x)       (((x) << SYNTH_SYNTH7_SYNTH_SM_STATE_LSB) & SYNTH_SYNTH7_SYNTH_SM_STATE_MASK)
-#define SYNTH_SYNTH7_CAP_SEARCH_MSB              26
-#define SYNTH_SYNTH7_CAP_SEARCH_LSB              26
-#define SYNTH_SYNTH7_CAP_SEARCH_MASK             0x04000000
-#define SYNTH_SYNTH7_CAP_SEARCH_GET(x)           (((x) & SYNTH_SYNTH7_CAP_SEARCH_MASK) >> SYNTH_SYNTH7_CAP_SEARCH_LSB)
-#define SYNTH_SYNTH7_CAP_SEARCH_SET(x)           (((x) << SYNTH_SYNTH7_CAP_SEARCH_LSB) & SYNTH_SYNTH7_CAP_SEARCH_MASK)
-#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MSB        25
-#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB        25
-#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK       0x02000000
-#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_GET(x)     (((x) & SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK) >> SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB)
-#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_SET(x)     (((x) << SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB) & SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK)
-#define SYNTH_SYNTH7_PIN_VC_MSB                  24
-#define SYNTH_SYNTH7_PIN_VC_LSB                  24
-#define SYNTH_SYNTH7_PIN_VC_MASK                 0x01000000
-#define SYNTH_SYNTH7_PIN_VC_GET(x)               (((x) & SYNTH_SYNTH7_PIN_VC_MASK) >> SYNTH_SYNTH7_PIN_VC_LSB)
-#define SYNTH_SYNTH7_PIN_VC_SET(x)               (((x) << SYNTH_SYNTH7_PIN_VC_LSB) & SYNTH_SYNTH7_PIN_VC_MASK)
-#define SYNTH_SYNTH7_VCO_CAP_ST_MSB              23
-#define SYNTH_SYNTH7_VCO_CAP_ST_LSB              16
-#define SYNTH_SYNTH7_VCO_CAP_ST_MASK             0x00ff0000
-#define SYNTH_SYNTH7_VCO_CAP_ST_GET(x)           (((x) & SYNTH_SYNTH7_VCO_CAP_ST_MASK) >> SYNTH_SYNTH7_VCO_CAP_ST_LSB)
-#define SYNTH_SYNTH7_VCO_CAP_ST_SET(x)           (((x) << SYNTH_SYNTH7_VCO_CAP_ST_LSB) & SYNTH_SYNTH7_VCO_CAP_ST_MASK)
-#define SYNTH_SYNTH7_SHORT_R_MSB                 15
-#define SYNTH_SYNTH7_SHORT_R_LSB                 15
-#define SYNTH_SYNTH7_SHORT_R_MASK                0x00008000
-#define SYNTH_SYNTH7_SHORT_R_GET(x)              (((x) & SYNTH_SYNTH7_SHORT_R_MASK) >> SYNTH_SYNTH7_SHORT_R_LSB)
-#define SYNTH_SYNTH7_SHORT_R_SET(x)              (((x) << SYNTH_SYNTH7_SHORT_R_LSB) & SYNTH_SYNTH7_SHORT_R_MASK)
-#define SYNTH_SYNTH7_RESET_RFD_MSB               14
-#define SYNTH_SYNTH7_RESET_RFD_LSB               14
-#define SYNTH_SYNTH7_RESET_RFD_MASK              0x00004000
-#define SYNTH_SYNTH7_RESET_RFD_GET(x)            (((x) & SYNTH_SYNTH7_RESET_RFD_MASK) >> SYNTH_SYNTH7_RESET_RFD_LSB)
-#define SYNTH_SYNTH7_RESET_RFD_SET(x)            (((x) << SYNTH_SYNTH7_RESET_RFD_LSB) & SYNTH_SYNTH7_RESET_RFD_MASK)
-#define SYNTH_SYNTH7_RESET_PFD_MSB               13
-#define SYNTH_SYNTH7_RESET_PFD_LSB               13
-#define SYNTH_SYNTH7_RESET_PFD_MASK              0x00002000
-#define SYNTH_SYNTH7_RESET_PFD_GET(x)            (((x) & SYNTH_SYNTH7_RESET_PFD_MASK) >> SYNTH_SYNTH7_RESET_PFD_LSB)
-#define SYNTH_SYNTH7_RESET_PFD_SET(x)            (((x) << SYNTH_SYNTH7_RESET_PFD_LSB) & SYNTH_SYNTH7_RESET_PFD_MASK)
-#define SYNTH_SYNTH7_RESET_PSCOUNTERS_MSB        12
-#define SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB        12
-#define SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK       0x00001000
-#define SYNTH_SYNTH7_RESET_PSCOUNTERS_GET(x)     (((x) & SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK) >> SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB)
-#define SYNTH_SYNTH7_RESET_PSCOUNTERS_SET(x)     (((x) << SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB) & SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK)
-#define SYNTH_SYNTH7_RESET_SDM_B_MSB             11
-#define SYNTH_SYNTH7_RESET_SDM_B_LSB             11
-#define SYNTH_SYNTH7_RESET_SDM_B_MASK            0x00000800
-#define SYNTH_SYNTH7_RESET_SDM_B_GET(x)          (((x) & SYNTH_SYNTH7_RESET_SDM_B_MASK) >> SYNTH_SYNTH7_RESET_SDM_B_LSB)
-#define SYNTH_SYNTH7_RESET_SDM_B_SET(x)          (((x) << SYNTH_SYNTH7_RESET_SDM_B_LSB) & SYNTH_SYNTH7_RESET_SDM_B_MASK)
-#define SYNTH_SYNTH7_VC2HIGH_MSB                 10
-#define SYNTH_SYNTH7_VC2HIGH_LSB                 10
-#define SYNTH_SYNTH7_VC2HIGH_MASK                0x00000400
-#define SYNTH_SYNTH7_VC2HIGH_GET(x)              (((x) & SYNTH_SYNTH7_VC2HIGH_MASK) >> SYNTH_SYNTH7_VC2HIGH_LSB)
-#define SYNTH_SYNTH7_VC2HIGH_SET(x)              (((x) << SYNTH_SYNTH7_VC2HIGH_LSB) & SYNTH_SYNTH7_VC2HIGH_MASK)
-#define SYNTH_SYNTH7_VC2LOW_MSB                  9
-#define SYNTH_SYNTH7_VC2LOW_LSB                  9
-#define SYNTH_SYNTH7_VC2LOW_MASK                 0x00000200
-#define SYNTH_SYNTH7_VC2LOW_GET(x)               (((x) & SYNTH_SYNTH7_VC2LOW_MASK) >> SYNTH_SYNTH7_VC2LOW_LSB)
-#define SYNTH_SYNTH7_VC2LOW_SET(x)               (((x) << SYNTH_SYNTH7_VC2LOW_LSB) & SYNTH_SYNTH7_VC2LOW_MASK)
-#define SYNTH_SYNTH7_LOOP_IP_MSB                 8
-#define SYNTH_SYNTH7_LOOP_IP_LSB                 5
-#define SYNTH_SYNTH7_LOOP_IP_MASK                0x000001e0
-#define SYNTH_SYNTH7_LOOP_IP_GET(x)              (((x) & SYNTH_SYNTH7_LOOP_IP_MASK) >> SYNTH_SYNTH7_LOOP_IP_LSB)
-#define SYNTH_SYNTH7_LOOP_IP_SET(x)              (((x) << SYNTH_SYNTH7_LOOP_IP_LSB) & SYNTH_SYNTH7_LOOP_IP_MASK)
-#define SYNTH_SYNTH7_LOBUF5GTUNE_MSB             4
-#define SYNTH_SYNTH7_LOBUF5GTUNE_LSB             3
-#define SYNTH_SYNTH7_LOBUF5GTUNE_MASK            0x00000018
-#define SYNTH_SYNTH7_LOBUF5GTUNE_GET(x)          (((x) & SYNTH_SYNTH7_LOBUF5GTUNE_MASK) >> SYNTH_SYNTH7_LOBUF5GTUNE_LSB)
-#define SYNTH_SYNTH7_LOBUF5GTUNE_SET(x)          (((x) << SYNTH_SYNTH7_LOBUF5GTUNE_LSB) & SYNTH_SYNTH7_LOBUF5GTUNE_MASK)
-#define SYNTH_SYNTH7_SPARE_READ_MSB              2
-#define SYNTH_SYNTH7_SPARE_READ_LSB              0
-#define SYNTH_SYNTH7_SPARE_READ_MASK             0x00000007
-#define SYNTH_SYNTH7_SPARE_READ_GET(x)           (((x) & SYNTH_SYNTH7_SPARE_READ_MASK) >> SYNTH_SYNTH7_SPARE_READ_LSB)
-#define SYNTH_SYNTH7_SPARE_READ_SET(x)           (((x) << SYNTH_SYNTH7_SPARE_READ_LSB) & SYNTH_SYNTH7_SPARE_READ_MASK)
-
-#define SYNTH_SYNTH8_ADDRESS                     0x0000001c
-#define SYNTH_SYNTH8_OFFSET                      0x0000001c
-#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_MSB        31
-#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB        31
-#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK       0x80000000
-#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_GET(x)     (((x) & SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK) >> SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB)
-#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_SET(x)     (((x) << SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB) & SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK)
-#define SYNTH_SYNTH8_FRACMODE_MSB                30
-#define SYNTH_SYNTH8_FRACMODE_LSB                30
-#define SYNTH_SYNTH8_FRACMODE_MASK               0x40000000
-#define SYNTH_SYNTH8_FRACMODE_GET(x)             (((x) & SYNTH_SYNTH8_FRACMODE_MASK) >> SYNTH_SYNTH8_FRACMODE_LSB)
-#define SYNTH_SYNTH8_FRACMODE_SET(x)             (((x) << SYNTH_SYNTH8_FRACMODE_LSB) & SYNTH_SYNTH8_FRACMODE_MASK)
-#define SYNTH_SYNTH8_AMODEREFSEL_MSB             29
-#define SYNTH_SYNTH8_AMODEREFSEL_LSB             28
-#define SYNTH_SYNTH8_AMODEREFSEL_MASK            0x30000000
-#define SYNTH_SYNTH8_AMODEREFSEL_GET(x)          (((x) & SYNTH_SYNTH8_AMODEREFSEL_MASK) >> SYNTH_SYNTH8_AMODEREFSEL_LSB)
-#define SYNTH_SYNTH8_AMODEREFSEL_SET(x)          (((x) << SYNTH_SYNTH8_AMODEREFSEL_LSB) & SYNTH_SYNTH8_AMODEREFSEL_MASK)
-#define SYNTH_SYNTH8_SPARE_MSB                   27
-#define SYNTH_SYNTH8_SPARE_LSB                   27
-#define SYNTH_SYNTH8_SPARE_MASK                  0x08000000
-#define SYNTH_SYNTH8_SPARE_GET(x)                (((x) & SYNTH_SYNTH8_SPARE_MASK) >> SYNTH_SYNTH8_SPARE_LSB)
-#define SYNTH_SYNTH8_SPARE_SET(x)                (((x) << SYNTH_SYNTH8_SPARE_LSB) & SYNTH_SYNTH8_SPARE_MASK)
-#define SYNTH_SYNTH8_CHANSEL_MSB                 26
-#define SYNTH_SYNTH8_CHANSEL_LSB                 18
-#define SYNTH_SYNTH8_CHANSEL_MASK                0x07fc0000
-#define SYNTH_SYNTH8_CHANSEL_GET(x)              (((x) & SYNTH_SYNTH8_CHANSEL_MASK) >> SYNTH_SYNTH8_CHANSEL_LSB)
-#define SYNTH_SYNTH8_CHANSEL_SET(x)              (((x) << SYNTH_SYNTH8_CHANSEL_LSB) & SYNTH_SYNTH8_CHANSEL_MASK)
-#define SYNTH_SYNTH8_CHANFRAC_MSB                17
-#define SYNTH_SYNTH8_CHANFRAC_LSB                1
-#define SYNTH_SYNTH8_CHANFRAC_MASK               0x0003fffe
-#define SYNTH_SYNTH8_CHANFRAC_GET(x)             (((x) & SYNTH_SYNTH8_CHANFRAC_MASK) >> SYNTH_SYNTH8_CHANFRAC_LSB)
-#define SYNTH_SYNTH8_CHANFRAC_SET(x)             (((x) << SYNTH_SYNTH8_CHANFRAC_LSB) & SYNTH_SYNTH8_CHANFRAC_MASK)
-#define SYNTH_SYNTH8_FORCE_FRACLSB_MSB           0
-#define SYNTH_SYNTH8_FORCE_FRACLSB_LSB           0
-#define SYNTH_SYNTH8_FORCE_FRACLSB_MASK          0x00000001
-#define SYNTH_SYNTH8_FORCE_FRACLSB_GET(x)        (((x) & SYNTH_SYNTH8_FORCE_FRACLSB_MASK) >> SYNTH_SYNTH8_FORCE_FRACLSB_LSB)
-#define SYNTH_SYNTH8_FORCE_FRACLSB_SET(x)        (((x) << SYNTH_SYNTH8_FORCE_FRACLSB_LSB) & SYNTH_SYNTH8_FORCE_FRACLSB_MASK)
-
-#define RF5G_RF5G1_ADDRESS                       0x00000020
-#define RF5G_RF5G1_OFFSET                        0x00000020
-#define RF5G_RF5G1_PDTXLO5_MSB                   31
-#define RF5G_RF5G1_PDTXLO5_LSB                   31
-#define RF5G_RF5G1_PDTXLO5_MASK                  0x80000000
-#define RF5G_RF5G1_PDTXLO5_GET(x)                (((x) & RF5G_RF5G1_PDTXLO5_MASK) >> RF5G_RF5G1_PDTXLO5_LSB)
-#define RF5G_RF5G1_PDTXLO5_SET(x)                (((x) << RF5G_RF5G1_PDTXLO5_LSB) & RF5G_RF5G1_PDTXLO5_MASK)
-#define RF5G_RF5G1_PDTXMIX5_MSB                  30
-#define RF5G_RF5G1_PDTXMIX5_LSB                  30
-#define RF5G_RF5G1_PDTXMIX5_MASK                 0x40000000
-#define RF5G_RF5G1_PDTXMIX5_GET(x)               (((x) & RF5G_RF5G1_PDTXMIX5_MASK) >> RF5G_RF5G1_PDTXMIX5_LSB)
-#define RF5G_RF5G1_PDTXMIX5_SET(x)               (((x) << RF5G_RF5G1_PDTXMIX5_LSB) & RF5G_RF5G1_PDTXMIX5_MASK)
-#define RF5G_RF5G1_PDTXBUF5_MSB                  29
-#define RF5G_RF5G1_PDTXBUF5_LSB                  29
-#define RF5G_RF5G1_PDTXBUF5_MASK                 0x20000000
-#define RF5G_RF5G1_PDTXBUF5_GET(x)               (((x) & RF5G_RF5G1_PDTXBUF5_MASK) >> RF5G_RF5G1_PDTXBUF5_LSB)
-#define RF5G_RF5G1_PDTXBUF5_SET(x)               (((x) << RF5G_RF5G1_PDTXBUF5_LSB) & RF5G_RF5G1_PDTXBUF5_MASK)
-#define RF5G_RF5G1_PDPADRV5_MSB                  28
-#define RF5G_RF5G1_PDPADRV5_LSB                  28
-#define RF5G_RF5G1_PDPADRV5_MASK                 0x10000000
-#define RF5G_RF5G1_PDPADRV5_GET(x)               (((x) & RF5G_RF5G1_PDPADRV5_MASK) >> RF5G_RF5G1_PDPADRV5_LSB)
-#define RF5G_RF5G1_PDPADRV5_SET(x)               (((x) << RF5G_RF5G1_PDPADRV5_LSB) & RF5G_RF5G1_PDPADRV5_MASK)
-#define RF5G_RF5G1_PDPAOUT5_MSB                  27
-#define RF5G_RF5G1_PDPAOUT5_LSB                  27
-#define RF5G_RF5G1_PDPAOUT5_MASK                 0x08000000
-#define RF5G_RF5G1_PDPAOUT5_GET(x)               (((x) & RF5G_RF5G1_PDPAOUT5_MASK) >> RF5G_RF5G1_PDPAOUT5_LSB)
-#define RF5G_RF5G1_PDPAOUT5_SET(x)               (((x) << RF5G_RF5G1_PDPAOUT5_LSB) & RF5G_RF5G1_PDPAOUT5_MASK)
-#define RF5G_RF5G1_TUNE_PADRV5_MSB               26
-#define RF5G_RF5G1_TUNE_PADRV5_LSB               24
-#define RF5G_RF5G1_TUNE_PADRV5_MASK              0x07000000
-#define RF5G_RF5G1_TUNE_PADRV5_GET(x)            (((x) & RF5G_RF5G1_TUNE_PADRV5_MASK) >> RF5G_RF5G1_TUNE_PADRV5_LSB)
-#define RF5G_RF5G1_TUNE_PADRV5_SET(x)            (((x) << RF5G_RF5G1_TUNE_PADRV5_LSB) & RF5G_RF5G1_TUNE_PADRV5_MASK)
-#define RF5G_RF5G1_PWDTXPKD_MSB                  23
-#define RF5G_RF5G1_PWDTXPKD_LSB                  21
-#define RF5G_RF5G1_PWDTXPKD_MASK                 0x00e00000
-#define RF5G_RF5G1_PWDTXPKD_GET(x)               (((x) & RF5G_RF5G1_PWDTXPKD_MASK) >> RF5G_RF5G1_PWDTXPKD_LSB)
-#define RF5G_RF5G1_PWDTXPKD_SET(x)               (((x) << RF5G_RF5G1_PWDTXPKD_LSB) & RF5G_RF5G1_PWDTXPKD_MASK)
-#define RF5G_RF5G1_DB5_MSB                       20
-#define RF5G_RF5G1_DB5_LSB                       18
-#define RF5G_RF5G1_DB5_MASK                      0x001c0000
-#define RF5G_RF5G1_DB5_GET(x)                    (((x) & RF5G_RF5G1_DB5_MASK) >> RF5G_RF5G1_DB5_LSB)
-#define RF5G_RF5G1_DB5_SET(x)                    (((x) << RF5G_RF5G1_DB5_LSB) & RF5G_RF5G1_DB5_MASK)
-#define RF5G_RF5G1_OB5_MSB                       17
-#define RF5G_RF5G1_OB5_LSB                       15
-#define RF5G_RF5G1_OB5_MASK                      0x00038000
-#define RF5G_RF5G1_OB5_GET(x)                    (((x) & RF5G_RF5G1_OB5_MASK) >> RF5G_RF5G1_OB5_LSB)
-#define RF5G_RF5G1_OB5_SET(x)                    (((x) << RF5G_RF5G1_OB5_LSB) & RF5G_RF5G1_OB5_MASK)
-#define RF5G_RF5G1_TX5_ATB_SEL_MSB               14
-#define RF5G_RF5G1_TX5_ATB_SEL_LSB               12
-#define RF5G_RF5G1_TX5_ATB_SEL_MASK              0x00007000
-#define RF5G_RF5G1_TX5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G1_TX5_ATB_SEL_MASK) >> RF5G_RF5G1_TX5_ATB_SEL_LSB)
-#define RF5G_RF5G1_TX5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G1_TX5_ATB_SEL_LSB) & RF5G_RF5G1_TX5_ATB_SEL_MASK)
-#define RF5G_RF5G1_PDLO5DIV_MSB                  11
-#define RF5G_RF5G1_PDLO5DIV_LSB                  11
-#define RF5G_RF5G1_PDLO5DIV_MASK                 0x00000800
-#define RF5G_RF5G1_PDLO5DIV_GET(x)               (((x) & RF5G_RF5G1_PDLO5DIV_MASK) >> RF5G_RF5G1_PDLO5DIV_LSB)
-#define RF5G_RF5G1_PDLO5DIV_SET(x)               (((x) << RF5G_RF5G1_PDLO5DIV_LSB) & RF5G_RF5G1_PDLO5DIV_MASK)
-#define RF5G_RF5G1_PDLO5MIX_MSB                  10
-#define RF5G_RF5G1_PDLO5MIX_LSB                  10
-#define RF5G_RF5G1_PDLO5MIX_MASK                 0x00000400
-#define RF5G_RF5G1_PDLO5MIX_GET(x)               (((x) & RF5G_RF5G1_PDLO5MIX_MASK) >> RF5G_RF5G1_PDLO5MIX_LSB)
-#define RF5G_RF5G1_PDLO5MIX_SET(x)               (((x) << RF5G_RF5G1_PDLO5MIX_LSB) & RF5G_RF5G1_PDLO5MIX_MASK)
-#define RF5G_RF5G1_PDQBUF5_MSB                   9
-#define RF5G_RF5G1_PDQBUF5_LSB                   9
-#define RF5G_RF5G1_PDQBUF5_MASK                  0x00000200
-#define RF5G_RF5G1_PDQBUF5_GET(x)                (((x) & RF5G_RF5G1_PDQBUF5_MASK) >> RF5G_RF5G1_PDQBUF5_LSB)
-#define RF5G_RF5G1_PDQBUF5_SET(x)                (((x) << RF5G_RF5G1_PDQBUF5_LSB) & RF5G_RF5G1_PDQBUF5_MASK)
-#define RF5G_RF5G1_PDLO5AGC_MSB                  8
-#define RF5G_RF5G1_PDLO5AGC_LSB                  8
-#define RF5G_RF5G1_PDLO5AGC_MASK                 0x00000100
-#define RF5G_RF5G1_PDLO5AGC_GET(x)               (((x) & RF5G_RF5G1_PDLO5AGC_MASK) >> RF5G_RF5G1_PDLO5AGC_LSB)
-#define RF5G_RF5G1_PDLO5AGC_SET(x)               (((x) << RF5G_RF5G1_PDLO5AGC_LSB) & RF5G_RF5G1_PDLO5AGC_MASK)
-#define RF5G_RF5G1_PDREGLO5_MSB                  7
-#define RF5G_RF5G1_PDREGLO5_LSB                  7
-#define RF5G_RF5G1_PDREGLO5_MASK                 0x00000080
-#define RF5G_RF5G1_PDREGLO5_GET(x)               (((x) & RF5G_RF5G1_PDREGLO5_MASK) >> RF5G_RF5G1_PDREGLO5_LSB)
-#define RF5G_RF5G1_PDREGLO5_SET(x)               (((x) << RF5G_RF5G1_PDREGLO5_LSB) & RF5G_RF5G1_PDREGLO5_MASK)
-#define RF5G_RF5G1_LO5_ATB_SEL_MSB               6
-#define RF5G_RF5G1_LO5_ATB_SEL_LSB               4
-#define RF5G_RF5G1_LO5_ATB_SEL_MASK              0x00000070
-#define RF5G_RF5G1_LO5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G1_LO5_ATB_SEL_MASK) >> RF5G_RF5G1_LO5_ATB_SEL_LSB)
-#define RF5G_RF5G1_LO5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G1_LO5_ATB_SEL_LSB) & RF5G_RF5G1_LO5_ATB_SEL_MASK)
-#define RF5G_RF5G1_LO5CONTROL_MSB                3
-#define RF5G_RF5G1_LO5CONTROL_LSB                3
-#define RF5G_RF5G1_LO5CONTROL_MASK               0x00000008
-#define RF5G_RF5G1_LO5CONTROL_GET(x)             (((x) & RF5G_RF5G1_LO5CONTROL_MASK) >> RF5G_RF5G1_LO5CONTROL_LSB)
-#define RF5G_RF5G1_LO5CONTROL_SET(x)             (((x) << RF5G_RF5G1_LO5CONTROL_LSB) & RF5G_RF5G1_LO5CONTROL_MASK)
-#define RF5G_RF5G1_REGLO_BYPASS5_MSB             2
-#define RF5G_RF5G1_REGLO_BYPASS5_LSB             2
-#define RF5G_RF5G1_REGLO_BYPASS5_MASK            0x00000004
-#define RF5G_RF5G1_REGLO_BYPASS5_GET(x)          (((x) & RF5G_RF5G1_REGLO_BYPASS5_MASK) >> RF5G_RF5G1_REGLO_BYPASS5_LSB)
-#define RF5G_RF5G1_REGLO_BYPASS5_SET(x)          (((x) << RF5G_RF5G1_REGLO_BYPASS5_LSB) & RF5G_RF5G1_REGLO_BYPASS5_MASK)
-#define RF5G_RF5G1_SPARE_MSB                     1
-#define RF5G_RF5G1_SPARE_LSB                     0
-#define RF5G_RF5G1_SPARE_MASK                    0x00000003
-#define RF5G_RF5G1_SPARE_GET(x)                  (((x) & RF5G_RF5G1_SPARE_MASK) >> RF5G_RF5G1_SPARE_LSB)
-#define RF5G_RF5G1_SPARE_SET(x)                  (((x) << RF5G_RF5G1_SPARE_LSB) & RF5G_RF5G1_SPARE_MASK)
-
-#define RF5G_RF5G2_ADDRESS                       0x00000024
-#define RF5G_RF5G2_OFFSET                        0x00000024
-#define RF5G_RF5G2_AGCLO_B_MSB                   31
-#define RF5G_RF5G2_AGCLO_B_LSB                   29
-#define RF5G_RF5G2_AGCLO_B_MASK                  0xe0000000
-#define RF5G_RF5G2_AGCLO_B_GET(x)                (((x) & RF5G_RF5G2_AGCLO_B_MASK) >> RF5G_RF5G2_AGCLO_B_LSB)
-#define RF5G_RF5G2_AGCLO_B_SET(x)                (((x) << RF5G_RF5G2_AGCLO_B_LSB) & RF5G_RF5G2_AGCLO_B_MASK)
-#define RF5G_RF5G2_RX5_ATB_SEL_MSB               28
-#define RF5G_RF5G2_RX5_ATB_SEL_LSB               26
-#define RF5G_RF5G2_RX5_ATB_SEL_MASK              0x1c000000
-#define RF5G_RF5G2_RX5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G2_RX5_ATB_SEL_MASK) >> RF5G_RF5G2_RX5_ATB_SEL_LSB)
-#define RF5G_RF5G2_RX5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G2_RX5_ATB_SEL_LSB) & RF5G_RF5G2_RX5_ATB_SEL_MASK)
-#define RF5G_RF5G2_PDCMOSLO5_MSB                 25
-#define RF5G_RF5G2_PDCMOSLO5_LSB                 25
-#define RF5G_RF5G2_PDCMOSLO5_MASK                0x02000000
-#define RF5G_RF5G2_PDCMOSLO5_GET(x)              (((x) & RF5G_RF5G2_PDCMOSLO5_MASK) >> RF5G_RF5G2_PDCMOSLO5_LSB)
-#define RF5G_RF5G2_PDCMOSLO5_SET(x)              (((x) << RF5G_RF5G2_PDCMOSLO5_LSB) & RF5G_RF5G2_PDCMOSLO5_MASK)
-#define RF5G_RF5G2_PDVGM5_MSB                    24
-#define RF5G_RF5G2_PDVGM5_LSB                    24
-#define RF5G_RF5G2_PDVGM5_MASK                   0x01000000
-#define RF5G_RF5G2_PDVGM5_GET(x)                 (((x) & RF5G_RF5G2_PDVGM5_MASK) >> RF5G_RF5G2_PDVGM5_LSB)
-#define RF5G_RF5G2_PDVGM5_SET(x)                 (((x) << RF5G_RF5G2_PDVGM5_LSB) & RF5G_RF5G2_PDVGM5_MASK)
-#define RF5G_RF5G2_PDCSLNA5_MSB                  23
-#define RF5G_RF5G2_PDCSLNA5_LSB                  23
-#define RF5G_RF5G2_PDCSLNA5_MASK                 0x00800000
-#define RF5G_RF5G2_PDCSLNA5_GET(x)               (((x) & RF5G_RF5G2_PDCSLNA5_MASK) >> RF5G_RF5G2_PDCSLNA5_LSB)
-#define RF5G_RF5G2_PDCSLNA5_SET(x)               (((x) << RF5G_RF5G2_PDCSLNA5_LSB) & RF5G_RF5G2_PDCSLNA5_MASK)
-#define RF5G_RF5G2_PDRFVGA5_MSB                  22
-#define RF5G_RF5G2_PDRFVGA5_LSB                  22
-#define RF5G_RF5G2_PDRFVGA5_MASK                 0x00400000
-#define RF5G_RF5G2_PDRFVGA5_GET(x)               (((x) & RF5G_RF5G2_PDRFVGA5_MASK) >> RF5G_RF5G2_PDRFVGA5_LSB)
-#define RF5G_RF5G2_PDRFVGA5_SET(x)               (((x) << RF5G_RF5G2_PDRFVGA5_LSB) & RF5G_RF5G2_PDRFVGA5_MASK)
-#define RF5G_RF5G2_PDREGFE5_MSB                  21
-#define RF5G_RF5G2_PDREGFE5_LSB                  21
-#define RF5G_RF5G2_PDREGFE5_MASK                 0x00200000
-#define RF5G_RF5G2_PDREGFE5_GET(x)               (((x) & RF5G_RF5G2_PDREGFE5_MASK) >> RF5G_RF5G2_PDREGFE5_LSB)
-#define RF5G_RF5G2_PDREGFE5_SET(x)               (((x) << RF5G_RF5G2_PDREGFE5_LSB) & RF5G_RF5G2_PDREGFE5_MASK)
-#define RF5G_RF5G2_TUNE_RFVGA5_MSB               20
-#define RF5G_RF5G2_TUNE_RFVGA5_LSB               18
-#define RF5G_RF5G2_TUNE_RFVGA5_MASK              0x001c0000
-#define RF5G_RF5G2_TUNE_RFVGA5_GET(x)            (((x) & RF5G_RF5G2_TUNE_RFVGA5_MASK) >> RF5G_RF5G2_TUNE_RFVGA5_LSB)
-#define RF5G_RF5G2_TUNE_RFVGA5_SET(x)            (((x) << RF5G_RF5G2_TUNE_RFVGA5_LSB) & RF5G_RF5G2_TUNE_RFVGA5_MASK)
-#define RF5G_RF5G2_BRFVGA5_MSB                   17
-#define RF5G_RF5G2_BRFVGA5_LSB                   15
-#define RF5G_RF5G2_BRFVGA5_MASK                  0x00038000
-#define RF5G_RF5G2_BRFVGA5_GET(x)                (((x) & RF5G_RF5G2_BRFVGA5_MASK) >> RF5G_RF5G2_BRFVGA5_LSB)
-#define RF5G_RF5G2_BRFVGA5_SET(x)                (((x) << RF5G_RF5G2_BRFVGA5_LSB) & RF5G_RF5G2_BRFVGA5_MASK)
-#define RF5G_RF5G2_BCSLNA5_MSB                   14
-#define RF5G_RF5G2_BCSLNA5_LSB                   12
-#define RF5G_RF5G2_BCSLNA5_MASK                  0x00007000
-#define RF5G_RF5G2_BCSLNA5_GET(x)                (((x) & RF5G_RF5G2_BCSLNA5_MASK) >> RF5G_RF5G2_BCSLNA5_LSB)
-#define RF5G_RF5G2_BCSLNA5_SET(x)                (((x) << RF5G_RF5G2_BCSLNA5_LSB) & RF5G_RF5G2_BCSLNA5_MASK)
-#define RF5G_RF5G2_BVGM5_MSB                     11
-#define RF5G_RF5G2_BVGM5_LSB                     9
-#define RF5G_RF5G2_BVGM5_MASK                    0x00000e00
-#define RF5G_RF5G2_BVGM5_GET(x)                  (((x) & RF5G_RF5G2_BVGM5_MASK) >> RF5G_RF5G2_BVGM5_LSB)
-#define RF5G_RF5G2_BVGM5_SET(x)                  (((x) << RF5G_RF5G2_BVGM5_LSB) & RF5G_RF5G2_BVGM5_MASK)
-#define RF5G_RF5G2_REGFE_BYPASS5_MSB             8
-#define RF5G_RF5G2_REGFE_BYPASS5_LSB             8
-#define RF5G_RF5G2_REGFE_BYPASS5_MASK            0x00000100
-#define RF5G_RF5G2_REGFE_BYPASS5_GET(x)          (((x) & RF5G_RF5G2_REGFE_BYPASS5_MASK) >> RF5G_RF5G2_REGFE_BYPASS5_LSB)
-#define RF5G_RF5G2_REGFE_BYPASS5_SET(x)          (((x) << RF5G_RF5G2_REGFE_BYPASS5_LSB) & RF5G_RF5G2_REGFE_BYPASS5_MASK)
-#define RF5G_RF5G2_LNA5_ATTENMODE_MSB            7
-#define RF5G_RF5G2_LNA5_ATTENMODE_LSB            6
-#define RF5G_RF5G2_LNA5_ATTENMODE_MASK           0x000000c0
-#define RF5G_RF5G2_LNA5_ATTENMODE_GET(x)         (((x) & RF5G_RF5G2_LNA5_ATTENMODE_MASK) >> RF5G_RF5G2_LNA5_ATTENMODE_LSB)
-#define RF5G_RF5G2_LNA5_ATTENMODE_SET(x)         (((x) << RF5G_RF5G2_LNA5_ATTENMODE_LSB) & RF5G_RF5G2_LNA5_ATTENMODE_MASK)
-#define RF5G_RF5G2_ENABLE_PCA_MSB                5
-#define RF5G_RF5G2_ENABLE_PCA_LSB                5
-#define RF5G_RF5G2_ENABLE_PCA_MASK               0x00000020
-#define RF5G_RF5G2_ENABLE_PCA_GET(x)             (((x) & RF5G_RF5G2_ENABLE_PCA_MASK) >> RF5G_RF5G2_ENABLE_PCA_LSB)
-#define RF5G_RF5G2_ENABLE_PCA_SET(x)             (((x) << RF5G_RF5G2_ENABLE_PCA_LSB) & RF5G_RF5G2_ENABLE_PCA_MASK)
-#define RF5G_RF5G2_TUNE_LO_MSB                   4
-#define RF5G_RF5G2_TUNE_LO_LSB                   2
-#define RF5G_RF5G2_TUNE_LO_MASK                  0x0000001c
-#define RF5G_RF5G2_TUNE_LO_GET(x)                (((x) & RF5G_RF5G2_TUNE_LO_MASK) >> RF5G_RF5G2_TUNE_LO_LSB)
-#define RF5G_RF5G2_TUNE_LO_SET(x)                (((x) << RF5G_RF5G2_TUNE_LO_LSB) & RF5G_RF5G2_TUNE_LO_MASK)
-#define RF5G_RF5G2_SPARE_MSB                     1
-#define RF5G_RF5G2_SPARE_LSB                     0
-#define RF5G_RF5G2_SPARE_MASK                    0x00000003
-#define RF5G_RF5G2_SPARE_GET(x)                  (((x) & RF5G_RF5G2_SPARE_MASK) >> RF5G_RF5G2_SPARE_LSB)
-#define RF5G_RF5G2_SPARE_SET(x)                  (((x) << RF5G_RF5G2_SPARE_LSB) & RF5G_RF5G2_SPARE_MASK)
-
-#define RF2G_RF2G1_ADDRESS                       0x00000028
-#define RF2G_RF2G1_OFFSET                        0x00000028
-#define RF2G_RF2G1_BLNA1_MSB                     31
-#define RF2G_RF2G1_BLNA1_LSB                     29
-#define RF2G_RF2G1_BLNA1_MASK                    0xe0000000
-#define RF2G_RF2G1_BLNA1_GET(x)                  (((x) & RF2G_RF2G1_BLNA1_MASK) >> RF2G_RF2G1_BLNA1_LSB)
-#define RF2G_RF2G1_BLNA1_SET(x)                  (((x) << RF2G_RF2G1_BLNA1_LSB) & RF2G_RF2G1_BLNA1_MASK)
-#define RF2G_RF2G1_BLNA1F_MSB                    28
-#define RF2G_RF2G1_BLNA1F_LSB                    26
-#define RF2G_RF2G1_BLNA1F_MASK                   0x1c000000
-#define RF2G_RF2G1_BLNA1F_GET(x)                 (((x) & RF2G_RF2G1_BLNA1F_MASK) >> RF2G_RF2G1_BLNA1F_LSB)
-#define RF2G_RF2G1_BLNA1F_SET(x)                 (((x) << RF2G_RF2G1_BLNA1F_LSB) & RF2G_RF2G1_BLNA1F_MASK)
-#define RF2G_RF2G1_BLNA1BUF_MSB                  25
-#define RF2G_RF2G1_BLNA1BUF_LSB                  23
-#define RF2G_RF2G1_BLNA1BUF_MASK                 0x03800000
-#define RF2G_RF2G1_BLNA1BUF_GET(x)               (((x) & RF2G_RF2G1_BLNA1BUF_MASK) >> RF2G_RF2G1_BLNA1BUF_LSB)
-#define RF2G_RF2G1_BLNA1BUF_SET(x)               (((x) << RF2G_RF2G1_BLNA1BUF_LSB) & RF2G_RF2G1_BLNA1BUF_MASK)
-#define RF2G_RF2G1_BLNA2_MSB                     22
-#define RF2G_RF2G1_BLNA2_LSB                     20
-#define RF2G_RF2G1_BLNA2_MASK                    0x00700000
-#define RF2G_RF2G1_BLNA2_GET(x)                  (((x) & RF2G_RF2G1_BLNA2_MASK) >> RF2G_RF2G1_BLNA2_LSB)
-#define RF2G_RF2G1_BLNA2_SET(x)                  (((x) << RF2G_RF2G1_BLNA2_LSB) & RF2G_RF2G1_BLNA2_MASK)
-#define RF2G_RF2G1_DB_MSB                        19
-#define RF2G_RF2G1_DB_LSB                        17
-#define RF2G_RF2G1_DB_MASK                       0x000e0000
-#define RF2G_RF2G1_DB_GET(x)                     (((x) & RF2G_RF2G1_DB_MASK) >> RF2G_RF2G1_DB_LSB)
-#define RF2G_RF2G1_DB_SET(x)                     (((x) << RF2G_RF2G1_DB_LSB) & RF2G_RF2G1_DB_MASK)
-#define RF2G_RF2G1_OB_MSB                        16
-#define RF2G_RF2G1_OB_LSB                        14
-#define RF2G_RF2G1_OB_MASK                       0x0001c000
-#define RF2G_RF2G1_OB_GET(x)                     (((x) & RF2G_RF2G1_OB_MASK) >> RF2G_RF2G1_OB_LSB)
-#define RF2G_RF2G1_OB_SET(x)                     (((x) << RF2G_RF2G1_OB_LSB) & RF2G_RF2G1_OB_MASK)
-#define RF2G_RF2G1_FE_ATB_SEL_MSB                13
-#define RF2G_RF2G1_FE_ATB_SEL_LSB                11
-#define RF2G_RF2G1_FE_ATB_SEL_MASK               0x00003800
-#define RF2G_RF2G1_FE_ATB_SEL_GET(x)             (((x) & RF2G_RF2G1_FE_ATB_SEL_MASK) >> RF2G_RF2G1_FE_ATB_SEL_LSB)
-#define RF2G_RF2G1_FE_ATB_SEL_SET(x)             (((x) << RF2G_RF2G1_FE_ATB_SEL_LSB) & RF2G_RF2G1_FE_ATB_SEL_MASK)
-#define RF2G_RF2G1_RF_ATB_SEL_MSB                10
-#define RF2G_RF2G1_RF_ATB_SEL_LSB                8
-#define RF2G_RF2G1_RF_ATB_SEL_MASK               0x00000700
-#define RF2G_RF2G1_RF_ATB_SEL_GET(x)             (((x) & RF2G_RF2G1_RF_ATB_SEL_MASK) >> RF2G_RF2G1_RF_ATB_SEL_LSB)
-#define RF2G_RF2G1_RF_ATB_SEL_SET(x)             (((x) << RF2G_RF2G1_RF_ATB_SEL_LSB) & RF2G_RF2G1_RF_ATB_SEL_MASK)
-#define RF2G_RF2G1_SELLNA_MSB                    7
-#define RF2G_RF2G1_SELLNA_LSB                    7
-#define RF2G_RF2G1_SELLNA_MASK                   0x00000080
-#define RF2G_RF2G1_SELLNA_GET(x)                 (((x) & RF2G_RF2G1_SELLNA_MASK) >> RF2G_RF2G1_SELLNA_LSB)
-#define RF2G_RF2G1_SELLNA_SET(x)                 (((x) << RF2G_RF2G1_SELLNA_LSB) & RF2G_RF2G1_SELLNA_MASK)
-#define RF2G_RF2G1_LOCONTROL_MSB                 6
-#define RF2G_RF2G1_LOCONTROL_LSB                 6
-#define RF2G_RF2G1_LOCONTROL_MASK                0x00000040
-#define RF2G_RF2G1_LOCONTROL_GET(x)              (((x) & RF2G_RF2G1_LOCONTROL_MASK) >> RF2G_RF2G1_LOCONTROL_LSB)
-#define RF2G_RF2G1_LOCONTROL_SET(x)              (((x) << RF2G_RF2G1_LOCONTROL_LSB) & RF2G_RF2G1_LOCONTROL_MASK)
-#define RF2G_RF2G1_SHORTLNA2_MSB                 5
-#define RF2G_RF2G1_SHORTLNA2_LSB                 5
-#define RF2G_RF2G1_SHORTLNA2_MASK                0x00000020
-#define RF2G_RF2G1_SHORTLNA2_GET(x)              (((x) & RF2G_RF2G1_SHORTLNA2_MASK) >> RF2G_RF2G1_SHORTLNA2_LSB)
-#define RF2G_RF2G1_SHORTLNA2_SET(x)              (((x) << RF2G_RF2G1_SHORTLNA2_LSB) & RF2G_RF2G1_SHORTLNA2_MASK)
-#define RF2G_RF2G1_SPARE_MSB                     4
-#define RF2G_RF2G1_SPARE_LSB                     0
-#define RF2G_RF2G1_SPARE_MASK                    0x0000001f
-#define RF2G_RF2G1_SPARE_GET(x)                  (((x) & RF2G_RF2G1_SPARE_MASK) >> RF2G_RF2G1_SPARE_LSB)
-#define RF2G_RF2G1_SPARE_SET(x)                  (((x) << RF2G_RF2G1_SPARE_LSB) & RF2G_RF2G1_SPARE_MASK)
-
-#define RF2G_RF2G2_ADDRESS                       0x0000002c
-#define RF2G_RF2G2_OFFSET                        0x0000002c
-#define RF2G_RF2G2_PDCGLNA_MSB                   31
-#define RF2G_RF2G2_PDCGLNA_LSB                   31
-#define RF2G_RF2G2_PDCGLNA_MASK                  0x80000000
-#define RF2G_RF2G2_PDCGLNA_GET(x)                (((x) & RF2G_RF2G2_PDCGLNA_MASK) >> RF2G_RF2G2_PDCGLNA_LSB)
-#define RF2G_RF2G2_PDCGLNA_SET(x)                (((x) << RF2G_RF2G2_PDCGLNA_LSB) & RF2G_RF2G2_PDCGLNA_MASK)
-#define RF2G_RF2G2_PDCGLNABUF_MSB                30
-#define RF2G_RF2G2_PDCGLNABUF_LSB                30
-#define RF2G_RF2G2_PDCGLNABUF_MASK               0x40000000
-#define RF2G_RF2G2_PDCGLNABUF_GET(x)             (((x) & RF2G_RF2G2_PDCGLNABUF_MASK) >> RF2G_RF2G2_PDCGLNABUF_LSB)
-#define RF2G_RF2G2_PDCGLNABUF_SET(x)             (((x) << RF2G_RF2G2_PDCGLNABUF_LSB) & RF2G_RF2G2_PDCGLNABUF_MASK)
-#define RF2G_RF2G2_PDCSLNA_MSB                   29
-#define RF2G_RF2G2_PDCSLNA_LSB                   29
-#define RF2G_RF2G2_PDCSLNA_MASK                  0x20000000
-#define RF2G_RF2G2_PDCSLNA_GET(x)                (((x) & RF2G_RF2G2_PDCSLNA_MASK) >> RF2G_RF2G2_PDCSLNA_LSB)
-#define RF2G_RF2G2_PDCSLNA_SET(x)                (((x) << RF2G_RF2G2_PDCSLNA_LSB) & RF2G_RF2G2_PDCSLNA_MASK)
-#define RF2G_RF2G2_PDDIV_MSB                     28
-#define RF2G_RF2G2_PDDIV_LSB                     28
-#define RF2G_RF2G2_PDDIV_MASK                    0x10000000
-#define RF2G_RF2G2_PDDIV_GET(x)                  (((x) & RF2G_RF2G2_PDDIV_MASK) >> RF2G_RF2G2_PDDIV_LSB)
-#define RF2G_RF2G2_PDDIV_SET(x)                  (((x) << RF2G_RF2G2_PDDIV_LSB) & RF2G_RF2G2_PDDIV_MASK)
-#define RF2G_RF2G2_PDPADRV_MSB                   27
-#define RF2G_RF2G2_PDPADRV_LSB                   27
-#define RF2G_RF2G2_PDPADRV_MASK                  0x08000000
-#define RF2G_RF2G2_PDPADRV_GET(x)                (((x) & RF2G_RF2G2_PDPADRV_MASK) >> RF2G_RF2G2_PDPADRV_LSB)
-#define RF2G_RF2G2_PDPADRV_SET(x)                (((x) << RF2G_RF2G2_PDPADRV_LSB) & RF2G_RF2G2_PDPADRV_MASK)
-#define RF2G_RF2G2_PDPAOUT_MSB                   26
-#define RF2G_RF2G2_PDPAOUT_LSB                   26
-#define RF2G_RF2G2_PDPAOUT_MASK                  0x04000000
-#define RF2G_RF2G2_PDPAOUT_GET(x)                (((x) & RF2G_RF2G2_PDPAOUT_MASK) >> RF2G_RF2G2_PDPAOUT_LSB)
-#define RF2G_RF2G2_PDPAOUT_SET(x)                (((x) << RF2G_RF2G2_PDPAOUT_LSB) & RF2G_RF2G2_PDPAOUT_MASK)
-#define RF2G_RF2G2_PDREGLNA_MSB                  25
-#define RF2G_RF2G2_PDREGLNA_LSB                  25
-#define RF2G_RF2G2_PDREGLNA_MASK                 0x02000000
-#define RF2G_RF2G2_PDREGLNA_GET(x)               (((x) & RF2G_RF2G2_PDREGLNA_MASK) >> RF2G_RF2G2_PDREGLNA_LSB)
-#define RF2G_RF2G2_PDREGLNA_SET(x)               (((x) << RF2G_RF2G2_PDREGLNA_LSB) & RF2G_RF2G2_PDREGLNA_MASK)
-#define RF2G_RF2G2_PDREGLO_MSB                   24
-#define RF2G_RF2G2_PDREGLO_LSB                   24
-#define RF2G_RF2G2_PDREGLO_MASK                  0x01000000
-#define RF2G_RF2G2_PDREGLO_GET(x)                (((x) & RF2G_RF2G2_PDREGLO_MASK) >> RF2G_RF2G2_PDREGLO_LSB)
-#define RF2G_RF2G2_PDREGLO_SET(x)                (((x) << RF2G_RF2G2_PDREGLO_LSB) & RF2G_RF2G2_PDREGLO_MASK)
-#define RF2G_RF2G2_PDRFGM_MSB                    23
-#define RF2G_RF2G2_PDRFGM_LSB                    23
-#define RF2G_RF2G2_PDRFGM_MASK                   0x00800000
-#define RF2G_RF2G2_PDRFGM_GET(x)                 (((x) & RF2G_RF2G2_PDRFGM_MASK) >> RF2G_RF2G2_PDRFGM_LSB)
-#define RF2G_RF2G2_PDRFGM_SET(x)                 (((x) << RF2G_RF2G2_PDRFGM_LSB) & RF2G_RF2G2_PDRFGM_MASK)
-#define RF2G_RF2G2_PDRXLO_MSB                    22
-#define RF2G_RF2G2_PDRXLO_LSB                    22
-#define RF2G_RF2G2_PDRXLO_MASK                   0x00400000
-#define RF2G_RF2G2_PDRXLO_GET(x)                 (((x) & RF2G_RF2G2_PDRXLO_MASK) >> RF2G_RF2G2_PDRXLO_LSB)
-#define RF2G_RF2G2_PDRXLO_SET(x)                 (((x) << RF2G_RF2G2_PDRXLO_LSB) & RF2G_RF2G2_PDRXLO_MASK)
-#define RF2G_RF2G2_PDTXLO_MSB                    21
-#define RF2G_RF2G2_PDTXLO_LSB                    21
-#define RF2G_RF2G2_PDTXLO_MASK                   0x00200000
-#define RF2G_RF2G2_PDTXLO_GET(x)                 (((x) & RF2G_RF2G2_PDTXLO_MASK) >> RF2G_RF2G2_PDTXLO_LSB)
-#define RF2G_RF2G2_PDTXLO_SET(x)                 (((x) << RF2G_RF2G2_PDTXLO_LSB) & RF2G_RF2G2_PDTXLO_MASK)
-#define RF2G_RF2G2_PDTXMIX_MSB                   20
-#define RF2G_RF2G2_PDTXMIX_LSB                   20
-#define RF2G_RF2G2_PDTXMIX_MASK                  0x00100000
-#define RF2G_RF2G2_PDTXMIX_GET(x)                (((x) & RF2G_RF2G2_PDTXMIX_MASK) >> RF2G_RF2G2_PDTXMIX_LSB)
-#define RF2G_RF2G2_PDTXMIX_SET(x)                (((x) << RF2G_RF2G2_PDTXMIX_LSB) & RF2G_RF2G2_PDTXMIX_MASK)
-#define RF2G_RF2G2_REGLNA_BYPASS_MSB             19
-#define RF2G_RF2G2_REGLNA_BYPASS_LSB             19
-#define RF2G_RF2G2_REGLNA_BYPASS_MASK            0x00080000
-#define RF2G_RF2G2_REGLNA_BYPASS_GET(x)          (((x) & RF2G_RF2G2_REGLNA_BYPASS_MASK) >> RF2G_RF2G2_REGLNA_BYPASS_LSB)
-#define RF2G_RF2G2_REGLNA_BYPASS_SET(x)          (((x) << RF2G_RF2G2_REGLNA_BYPASS_LSB) & RF2G_RF2G2_REGLNA_BYPASS_MASK)
-#define RF2G_RF2G2_REGLO_BYPASS_MSB              18
-#define RF2G_RF2G2_REGLO_BYPASS_LSB              18
-#define RF2G_RF2G2_REGLO_BYPASS_MASK             0x00040000
-#define RF2G_RF2G2_REGLO_BYPASS_GET(x)           (((x) & RF2G_RF2G2_REGLO_BYPASS_MASK) >> RF2G_RF2G2_REGLO_BYPASS_LSB)
-#define RF2G_RF2G2_REGLO_BYPASS_SET(x)           (((x) << RF2G_RF2G2_REGLO_BYPASS_LSB) & RF2G_RF2G2_REGLO_BYPASS_MASK)
-#define RF2G_RF2G2_ENABLE_PCB_MSB                17
-#define RF2G_RF2G2_ENABLE_PCB_LSB                17
-#define RF2G_RF2G2_ENABLE_PCB_MASK               0x00020000
-#define RF2G_RF2G2_ENABLE_PCB_GET(x)             (((x) & RF2G_RF2G2_ENABLE_PCB_MASK) >> RF2G_RF2G2_ENABLE_PCB_LSB)
-#define RF2G_RF2G2_ENABLE_PCB_SET(x)             (((x) << RF2G_RF2G2_ENABLE_PCB_LSB) & RF2G_RF2G2_ENABLE_PCB_MASK)
-#define RF2G_RF2G2_SPARE_MSB                     16
-#define RF2G_RF2G2_SPARE_LSB                     0
-#define RF2G_RF2G2_SPARE_MASK                    0x0001ffff
-#define RF2G_RF2G2_SPARE_GET(x)                  (((x) & RF2G_RF2G2_SPARE_MASK) >> RF2G_RF2G2_SPARE_LSB)
-#define RF2G_RF2G2_SPARE_SET(x)                  (((x) << RF2G_RF2G2_SPARE_LSB) & RF2G_RF2G2_SPARE_MASK)
-
-#define TOP_GAIN_ADDRESS                         0x00000030
-#define TOP_GAIN_OFFSET                          0x00000030
-#define TOP_GAIN_TX6DBLOQGAIN_MSB                31
-#define TOP_GAIN_TX6DBLOQGAIN_LSB                30
-#define TOP_GAIN_TX6DBLOQGAIN_MASK               0xc0000000
-#define TOP_GAIN_TX6DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_TX6DBLOQGAIN_MASK) >> TOP_GAIN_TX6DBLOQGAIN_LSB)
-#define TOP_GAIN_TX6DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_TX6DBLOQGAIN_LSB) & TOP_GAIN_TX6DBLOQGAIN_MASK)
-#define TOP_GAIN_TX1DBLOQGAIN_MSB                29
-#define TOP_GAIN_TX1DBLOQGAIN_LSB                27
-#define TOP_GAIN_TX1DBLOQGAIN_MASK               0x38000000
-#define TOP_GAIN_TX1DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_TX1DBLOQGAIN_MASK) >> TOP_GAIN_TX1DBLOQGAIN_LSB)
-#define TOP_GAIN_TX1DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_TX1DBLOQGAIN_LSB) & TOP_GAIN_TX1DBLOQGAIN_MASK)
-#define TOP_GAIN_TXV2IGAIN_MSB                   26
-#define TOP_GAIN_TXV2IGAIN_LSB                   25
-#define TOP_GAIN_TXV2IGAIN_MASK                  0x06000000
-#define TOP_GAIN_TXV2IGAIN_GET(x)                (((x) & TOP_GAIN_TXV2IGAIN_MASK) >> TOP_GAIN_TXV2IGAIN_LSB)
-#define TOP_GAIN_TXV2IGAIN_SET(x)                (((x) << TOP_GAIN_TXV2IGAIN_LSB) & TOP_GAIN_TXV2IGAIN_MASK)
-#define TOP_GAIN_PABUF5GN_MSB                    24
-#define TOP_GAIN_PABUF5GN_LSB                    24
-#define TOP_GAIN_PABUF5GN_MASK                   0x01000000
-#define TOP_GAIN_PABUF5GN_GET(x)                 (((x) & TOP_GAIN_PABUF5GN_MASK) >> TOP_GAIN_PABUF5GN_LSB)
-#define TOP_GAIN_PABUF5GN_SET(x)                 (((x) << TOP_GAIN_PABUF5GN_LSB) & TOP_GAIN_PABUF5GN_MASK)
-#define TOP_GAIN_PADRVGN_MSB                     23
-#define TOP_GAIN_PADRVGN_LSB                     21
-#define TOP_GAIN_PADRVGN_MASK                    0x00e00000
-#define TOP_GAIN_PADRVGN_GET(x)                  (((x) & TOP_GAIN_PADRVGN_MASK) >> TOP_GAIN_PADRVGN_LSB)
-#define TOP_GAIN_PADRVGN_SET(x)                  (((x) << TOP_GAIN_PADRVGN_LSB) & TOP_GAIN_PADRVGN_MASK)
-#define TOP_GAIN_PAOUT2GN_MSB                    20
-#define TOP_GAIN_PAOUT2GN_LSB                    18
-#define TOP_GAIN_PAOUT2GN_MASK                   0x001c0000
-#define TOP_GAIN_PAOUT2GN_GET(x)                 (((x) & TOP_GAIN_PAOUT2GN_MASK) >> TOP_GAIN_PAOUT2GN_LSB)
-#define TOP_GAIN_PAOUT2GN_SET(x)                 (((x) << TOP_GAIN_PAOUT2GN_LSB) & TOP_GAIN_PAOUT2GN_MASK)
-#define TOP_GAIN_LNAON_MSB                       17
-#define TOP_GAIN_LNAON_LSB                       17
-#define TOP_GAIN_LNAON_MASK                      0x00020000
-#define TOP_GAIN_LNAON_GET(x)                    (((x) & TOP_GAIN_LNAON_MASK) >> TOP_GAIN_LNAON_LSB)
-#define TOP_GAIN_LNAON_SET(x)                    (((x) << TOP_GAIN_LNAON_LSB) & TOP_GAIN_LNAON_MASK)
-#define TOP_GAIN_LNAGAIN_MSB                     16
-#define TOP_GAIN_LNAGAIN_LSB                     13
-#define TOP_GAIN_LNAGAIN_MASK                    0x0001e000
-#define TOP_GAIN_LNAGAIN_GET(x)                  (((x) & TOP_GAIN_LNAGAIN_MASK) >> TOP_GAIN_LNAGAIN_LSB)
-#define TOP_GAIN_LNAGAIN_SET(x)                  (((x) << TOP_GAIN_LNAGAIN_LSB) & TOP_GAIN_LNAGAIN_MASK)
-#define TOP_GAIN_RFVGA5GAIN_MSB                  12
-#define TOP_GAIN_RFVGA5GAIN_LSB                  11
-#define TOP_GAIN_RFVGA5GAIN_MASK                 0x00001800
-#define TOP_GAIN_RFVGA5GAIN_GET(x)               (((x) & TOP_GAIN_RFVGA5GAIN_MASK) >> TOP_GAIN_RFVGA5GAIN_LSB)
-#define TOP_GAIN_RFVGA5GAIN_SET(x)               (((x) << TOP_GAIN_RFVGA5GAIN_LSB) & TOP_GAIN_RFVGA5GAIN_MASK)
-#define TOP_GAIN_RFGMGN_MSB                      10
-#define TOP_GAIN_RFGMGN_LSB                      8
-#define TOP_GAIN_RFGMGN_MASK                     0x00000700
-#define TOP_GAIN_RFGMGN_GET(x)                   (((x) & TOP_GAIN_RFGMGN_MASK) >> TOP_GAIN_RFGMGN_LSB)
-#define TOP_GAIN_RFGMGN_SET(x)                   (((x) << TOP_GAIN_RFGMGN_LSB) & TOP_GAIN_RFGMGN_MASK)
-#define TOP_GAIN_RX6DBLOQGAIN_MSB                7
-#define TOP_GAIN_RX6DBLOQGAIN_LSB                6
-#define TOP_GAIN_RX6DBLOQGAIN_MASK               0x000000c0
-#define TOP_GAIN_RX6DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_RX6DBLOQGAIN_MASK) >> TOP_GAIN_RX6DBLOQGAIN_LSB)
-#define TOP_GAIN_RX6DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_RX6DBLOQGAIN_LSB) & TOP_GAIN_RX6DBLOQGAIN_MASK)
-#define TOP_GAIN_RX1DBLOQGAIN_MSB                5
-#define TOP_GAIN_RX1DBLOQGAIN_LSB                3
-#define TOP_GAIN_RX1DBLOQGAIN_MASK               0x00000038
-#define TOP_GAIN_RX1DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_RX1DBLOQGAIN_MASK) >> TOP_GAIN_RX1DBLOQGAIN_LSB)
-#define TOP_GAIN_RX1DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_RX1DBLOQGAIN_LSB) & TOP_GAIN_RX1DBLOQGAIN_MASK)
-#define TOP_GAIN_RX6DBHIQGAIN_MSB                2
-#define TOP_GAIN_RX6DBHIQGAIN_LSB                1
-#define TOP_GAIN_RX6DBHIQGAIN_MASK               0x00000006
-#define TOP_GAIN_RX6DBHIQGAIN_GET(x)             (((x) & TOP_GAIN_RX6DBHIQGAIN_MASK) >> TOP_GAIN_RX6DBHIQGAIN_LSB)
-#define TOP_GAIN_RX6DBHIQGAIN_SET(x)             (((x) << TOP_GAIN_RX6DBHIQGAIN_LSB) & TOP_GAIN_RX6DBHIQGAIN_MASK)
-#define TOP_GAIN_SPARE_MSB                       0
-#define TOP_GAIN_SPARE_LSB                       0
-#define TOP_GAIN_SPARE_MASK                      0x00000001
-#define TOP_GAIN_SPARE_GET(x)                    (((x) & TOP_GAIN_SPARE_MASK) >> TOP_GAIN_SPARE_LSB)
-#define TOP_GAIN_SPARE_SET(x)                    (((x) << TOP_GAIN_SPARE_LSB) & TOP_GAIN_SPARE_MASK)
-
-#define TOP_TOP_ADDRESS                          0x00000034
-#define TOP_TOP_OFFSET                           0x00000034
-#define TOP_TOP_LOCALTXGAIN_MSB                  31
-#define TOP_TOP_LOCALTXGAIN_LSB                  31
-#define TOP_TOP_LOCALTXGAIN_MASK                 0x80000000
-#define TOP_TOP_LOCALTXGAIN_GET(x)               (((x) & TOP_TOP_LOCALTXGAIN_MASK) >> TOP_TOP_LOCALTXGAIN_LSB)
-#define TOP_TOP_LOCALTXGAIN_SET(x)               (((x) << TOP_TOP_LOCALTXGAIN_LSB) & TOP_TOP_LOCALTXGAIN_MASK)
-#define TOP_TOP_LOCALRXGAIN_MSB                  30
-#define TOP_TOP_LOCALRXGAIN_LSB                  30
-#define TOP_TOP_LOCALRXGAIN_MASK                 0x40000000
-#define TOP_TOP_LOCALRXGAIN_GET(x)               (((x) & TOP_TOP_LOCALRXGAIN_MASK) >> TOP_TOP_LOCALRXGAIN_LSB)
-#define TOP_TOP_LOCALRXGAIN_SET(x)               (((x) << TOP_TOP_LOCALRXGAIN_LSB) & TOP_TOP_LOCALRXGAIN_MASK)
-#define TOP_TOP_LOCALMODE_MSB                    29
-#define TOP_TOP_LOCALMODE_LSB                    29
-#define TOP_TOP_LOCALMODE_MASK                   0x20000000
-#define TOP_TOP_LOCALMODE_GET(x)                 (((x) & TOP_TOP_LOCALMODE_MASK) >> TOP_TOP_LOCALMODE_LSB)
-#define TOP_TOP_LOCALMODE_SET(x)                 (((x) << TOP_TOP_LOCALMODE_LSB) & TOP_TOP_LOCALMODE_MASK)
-#define TOP_TOP_CALFC_MSB                        28
-#define TOP_TOP_CALFC_LSB                        28
-#define TOP_TOP_CALFC_MASK                       0x10000000
-#define TOP_TOP_CALFC_GET(x)                     (((x) & TOP_TOP_CALFC_MASK) >> TOP_TOP_CALFC_LSB)
-#define TOP_TOP_CALFC_SET(x)                     (((x) << TOP_TOP_CALFC_LSB) & TOP_TOP_CALFC_MASK)
-#define TOP_TOP_CALDC_MSB                        27
-#define TOP_TOP_CALDC_LSB                        27
-#define TOP_TOP_CALDC_MASK                       0x08000000
-#define TOP_TOP_CALDC_GET(x)                     (((x) & TOP_TOP_CALDC_MASK) >> TOP_TOP_CALDC_LSB)
-#define TOP_TOP_CALDC_SET(x)                     (((x) << TOP_TOP_CALDC_LSB) & TOP_TOP_CALDC_MASK)
-#define TOP_TOP_CAL_RESIDUE_MSB                  26
-#define TOP_TOP_CAL_RESIDUE_LSB                  26
-#define TOP_TOP_CAL_RESIDUE_MASK                 0x04000000
-#define TOP_TOP_CAL_RESIDUE_GET(x)               (((x) & TOP_TOP_CAL_RESIDUE_MASK) >> TOP_TOP_CAL_RESIDUE_LSB)
-#define TOP_TOP_CAL_RESIDUE_SET(x)               (((x) << TOP_TOP_CAL_RESIDUE_LSB) & TOP_TOP_CAL_RESIDUE_MASK)
-#define TOP_TOP_BMODE_MSB                        25
-#define TOP_TOP_BMODE_LSB                        25
-#define TOP_TOP_BMODE_MASK                       0x02000000
-#define TOP_TOP_BMODE_GET(x)                     (((x) & TOP_TOP_BMODE_MASK) >> TOP_TOP_BMODE_LSB)
-#define TOP_TOP_BMODE_SET(x)                     (((x) << TOP_TOP_BMODE_LSB) & TOP_TOP_BMODE_MASK)
-#define TOP_TOP_SYNTHON_MSB                      24
-#define TOP_TOP_SYNTHON_LSB                      24
-#define TOP_TOP_SYNTHON_MASK                     0x01000000
-#define TOP_TOP_SYNTHON_GET(x)                   (((x) & TOP_TOP_SYNTHON_MASK) >> TOP_TOP_SYNTHON_LSB)
-#define TOP_TOP_SYNTHON_SET(x)                   (((x) << TOP_TOP_SYNTHON_LSB) & TOP_TOP_SYNTHON_MASK)
-#define TOP_TOP_RXON_MSB                         23
-#define TOP_TOP_RXON_LSB                         23
-#define TOP_TOP_RXON_MASK                        0x00800000
-#define TOP_TOP_RXON_GET(x)                      (((x) & TOP_TOP_RXON_MASK) >> TOP_TOP_RXON_LSB)
-#define TOP_TOP_RXON_SET(x)                      (((x) << TOP_TOP_RXON_LSB) & TOP_TOP_RXON_MASK)
-#define TOP_TOP_TXON_MSB                         22
-#define TOP_TOP_TXON_LSB                         22
-#define TOP_TOP_TXON_MASK                        0x00400000
-#define TOP_TOP_TXON_GET(x)                      (((x) & TOP_TOP_TXON_MASK) >> TOP_TOP_TXON_LSB)
-#define TOP_TOP_TXON_SET(x)                      (((x) << TOP_TOP_TXON_LSB) & TOP_TOP_TXON_MASK)
-#define TOP_TOP_PAON_MSB                         21
-#define TOP_TOP_PAON_LSB                         21
-#define TOP_TOP_PAON_MASK                        0x00200000
-#define TOP_TOP_PAON_GET(x)                      (((x) & TOP_TOP_PAON_MASK) >> TOP_TOP_PAON_LSB)
-#define TOP_TOP_PAON_SET(x)                      (((x) << TOP_TOP_PAON_LSB) & TOP_TOP_PAON_MASK)
-#define TOP_TOP_CALTX_MSB                        20
-#define TOP_TOP_CALTX_LSB                        20
-#define TOP_TOP_CALTX_MASK                       0x00100000
-#define TOP_TOP_CALTX_GET(x)                     (((x) & TOP_TOP_CALTX_MASK) >> TOP_TOP_CALTX_LSB)
-#define TOP_TOP_CALTX_SET(x)                     (((x) << TOP_TOP_CALTX_LSB) & TOP_TOP_CALTX_MASK)
-#define TOP_TOP_LOCALADDAC_MSB                   19
-#define TOP_TOP_LOCALADDAC_LSB                   19
-#define TOP_TOP_LOCALADDAC_MASK                  0x00080000
-#define TOP_TOP_LOCALADDAC_GET(x)                (((x) & TOP_TOP_LOCALADDAC_MASK) >> TOP_TOP_LOCALADDAC_LSB)
-#define TOP_TOP_LOCALADDAC_SET(x)                (((x) << TOP_TOP_LOCALADDAC_LSB) & TOP_TOP_LOCALADDAC_MASK)
-#define TOP_TOP_PWDPLL_MSB                       18
-#define TOP_TOP_PWDPLL_LSB                       18
-#define TOP_TOP_PWDPLL_MASK                      0x00040000
-#define TOP_TOP_PWDPLL_GET(x)                    (((x) & TOP_TOP_PWDPLL_MASK) >> TOP_TOP_PWDPLL_LSB)
-#define TOP_TOP_PWDPLL_SET(x)                    (((x) << TOP_TOP_PWDPLL_LSB) & TOP_TOP_PWDPLL_MASK)
-#define TOP_TOP_PWDADC_MSB                       17
-#define TOP_TOP_PWDADC_LSB                       17
-#define TOP_TOP_PWDADC_MASK                      0x00020000
-#define TOP_TOP_PWDADC_GET(x)                    (((x) & TOP_TOP_PWDADC_MASK) >> TOP_TOP_PWDADC_LSB)
-#define TOP_TOP_PWDADC_SET(x)                    (((x) << TOP_TOP_PWDADC_LSB) & TOP_TOP_PWDADC_MASK)
-#define TOP_TOP_PWDDAC_MSB                       16
-#define TOP_TOP_PWDDAC_LSB                       16
-#define TOP_TOP_PWDDAC_MASK                      0x00010000
-#define TOP_TOP_PWDDAC_GET(x)                    (((x) & TOP_TOP_PWDDAC_MASK) >> TOP_TOP_PWDDAC_LSB)
-#define TOP_TOP_PWDDAC_SET(x)                    (((x) << TOP_TOP_PWDDAC_LSB) & TOP_TOP_PWDDAC_MASK)
-#define TOP_TOP_LOCALXTAL_MSB                    15
-#define TOP_TOP_LOCALXTAL_LSB                    15
-#define TOP_TOP_LOCALXTAL_MASK                   0x00008000
-#define TOP_TOP_LOCALXTAL_GET(x)                 (((x) & TOP_TOP_LOCALXTAL_MASK) >> TOP_TOP_LOCALXTAL_LSB)
-#define TOP_TOP_LOCALXTAL_SET(x)                 (((x) << TOP_TOP_LOCALXTAL_LSB) & TOP_TOP_LOCALXTAL_MASK)
-#define TOP_TOP_PWDCLKIN_MSB                     14
-#define TOP_TOP_PWDCLKIN_LSB                     14
-#define TOP_TOP_PWDCLKIN_MASK                    0x00004000
-#define TOP_TOP_PWDCLKIN_GET(x)                  (((x) & TOP_TOP_PWDCLKIN_MASK) >> TOP_TOP_PWDCLKIN_LSB)
-#define TOP_TOP_PWDCLKIN_SET(x)                  (((x) << TOP_TOP_PWDCLKIN_LSB) & TOP_TOP_PWDCLKIN_MASK)
-#define TOP_TOP_OSCON_MSB                        13
-#define TOP_TOP_OSCON_LSB                        13
-#define TOP_TOP_OSCON_MASK                       0x00002000
-#define TOP_TOP_OSCON_GET(x)                     (((x) & TOP_TOP_OSCON_MASK) >> TOP_TOP_OSCON_LSB)
-#define TOP_TOP_OSCON_SET(x)                     (((x) << TOP_TOP_OSCON_LSB) & TOP_TOP_OSCON_MASK)
-#define TOP_TOP_SCLKEN_FORCE_MSB                 12
-#define TOP_TOP_SCLKEN_FORCE_LSB                 12
-#define TOP_TOP_SCLKEN_FORCE_MASK                0x00001000
-#define TOP_TOP_SCLKEN_FORCE_GET(x)              (((x) & TOP_TOP_SCLKEN_FORCE_MASK) >> TOP_TOP_SCLKEN_FORCE_LSB)
-#define TOP_TOP_SCLKEN_FORCE_SET(x)              (((x) << TOP_TOP_SCLKEN_FORCE_LSB) & TOP_TOP_SCLKEN_FORCE_MASK)
-#define TOP_TOP_SYNTHON_FORCE_MSB                11
-#define TOP_TOP_SYNTHON_FORCE_LSB                11
-#define TOP_TOP_SYNTHON_FORCE_MASK               0x00000800
-#define TOP_TOP_SYNTHON_FORCE_GET(x)             (((x) & TOP_TOP_SYNTHON_FORCE_MASK) >> TOP_TOP_SYNTHON_FORCE_LSB)
-#define TOP_TOP_SYNTHON_FORCE_SET(x)             (((x) << TOP_TOP_SYNTHON_FORCE_LSB) & TOP_TOP_SYNTHON_FORCE_MASK)
-#define TOP_TOP_PDBIAS_MSB                       10
-#define TOP_TOP_PDBIAS_LSB                       10
-#define TOP_TOP_PDBIAS_MASK                      0x00000400
-#define TOP_TOP_PDBIAS_GET(x)                    (((x) & TOP_TOP_PDBIAS_MASK) >> TOP_TOP_PDBIAS_LSB)
-#define TOP_TOP_PDBIAS_SET(x)                    (((x) << TOP_TOP_PDBIAS_LSB) & TOP_TOP_PDBIAS_MASK)
-#define TOP_TOP_DATAOUTSEL_MSB                   9
-#define TOP_TOP_DATAOUTSEL_LSB                   8
-#define TOP_TOP_DATAOUTSEL_MASK                  0x00000300
-#define TOP_TOP_DATAOUTSEL_GET(x)                (((x) & TOP_TOP_DATAOUTSEL_MASK) >> TOP_TOP_DATAOUTSEL_LSB)
-#define TOP_TOP_DATAOUTSEL_SET(x)                (((x) << TOP_TOP_DATAOUTSEL_LSB) & TOP_TOP_DATAOUTSEL_MASK)
-#define TOP_TOP_REVID_MSB                        7
-#define TOP_TOP_REVID_LSB                        5
-#define TOP_TOP_REVID_MASK                       0x000000e0
-#define TOP_TOP_REVID_GET(x)                     (((x) & TOP_TOP_REVID_MASK) >> TOP_TOP_REVID_LSB)
-#define TOP_TOP_REVID_SET(x)                     (((x) << TOP_TOP_REVID_LSB) & TOP_TOP_REVID_MASK)
-#define TOP_TOP_INT2PAD_MSB                      4
-#define TOP_TOP_INT2PAD_LSB                      4
-#define TOP_TOP_INT2PAD_MASK                     0x00000010
-#define TOP_TOP_INT2PAD_GET(x)                   (((x) & TOP_TOP_INT2PAD_MASK) >> TOP_TOP_INT2PAD_LSB)
-#define TOP_TOP_INT2PAD_SET(x)                   (((x) << TOP_TOP_INT2PAD_LSB) & TOP_TOP_INT2PAD_MASK)
-#define TOP_TOP_INTH2PAD_MSB                     3
-#define TOP_TOP_INTH2PAD_LSB                     3
-#define TOP_TOP_INTH2PAD_MASK                    0x00000008
-#define TOP_TOP_INTH2PAD_GET(x)                  (((x) & TOP_TOP_INTH2PAD_MASK) >> TOP_TOP_INTH2PAD_LSB)
-#define TOP_TOP_INTH2PAD_SET(x)                  (((x) << TOP_TOP_INTH2PAD_LSB) & TOP_TOP_INTH2PAD_MASK)
-#define TOP_TOP_PAD2GND_MSB                      2
-#define TOP_TOP_PAD2GND_LSB                      2
-#define TOP_TOP_PAD2GND_MASK                     0x00000004
-#define TOP_TOP_PAD2GND_GET(x)                   (((x) & TOP_TOP_PAD2GND_MASK) >> TOP_TOP_PAD2GND_LSB)
-#define TOP_TOP_PAD2GND_SET(x)                   (((x) << TOP_TOP_PAD2GND_LSB) & TOP_TOP_PAD2GND_MASK)
-#define TOP_TOP_INT2GND_MSB                      1
-#define TOP_TOP_INT2GND_LSB                      1
-#define TOP_TOP_INT2GND_MASK                     0x00000002
-#define TOP_TOP_INT2GND_GET(x)                   (((x) & TOP_TOP_INT2GND_MASK) >> TOP_TOP_INT2GND_LSB)
-#define TOP_TOP_INT2GND_SET(x)                   (((x) << TOP_TOP_INT2GND_LSB) & TOP_TOP_INT2GND_MASK)
-#define TOP_TOP_FORCE_XPAON_MSB                  0
-#define TOP_TOP_FORCE_XPAON_LSB                  0
-#define TOP_TOP_FORCE_XPAON_MASK                 0x00000001
-#define TOP_TOP_FORCE_XPAON_GET(x)               (((x) & TOP_TOP_FORCE_XPAON_MASK) >> TOP_TOP_FORCE_XPAON_LSB)
-#define TOP_TOP_FORCE_XPAON_SET(x)               (((x) << TOP_TOP_FORCE_XPAON_LSB) & TOP_TOP_FORCE_XPAON_MASK)
-
-#define BIAS_BIAS_SEL_ADDRESS                    0x00000038
-#define BIAS_BIAS_SEL_OFFSET                     0x00000038
-#define BIAS_BIAS_SEL_PADON_MSB                  31
-#define BIAS_BIAS_SEL_PADON_LSB                  31
-#define BIAS_BIAS_SEL_PADON_MASK                 0x80000000
-#define BIAS_BIAS_SEL_PADON_GET(x)               (((x) & BIAS_BIAS_SEL_PADON_MASK) >> BIAS_BIAS_SEL_PADON_LSB)
-#define BIAS_BIAS_SEL_PADON_SET(x)               (((x) << BIAS_BIAS_SEL_PADON_LSB) & BIAS_BIAS_SEL_PADON_MASK)
-#define BIAS_BIAS_SEL_SEL_BIAS_MSB               30
-#define BIAS_BIAS_SEL_SEL_BIAS_LSB               25
-#define BIAS_BIAS_SEL_SEL_BIAS_MASK              0x7e000000
-#define BIAS_BIAS_SEL_SEL_BIAS_GET(x)            (((x) & BIAS_BIAS_SEL_SEL_BIAS_MASK) >> BIAS_BIAS_SEL_SEL_BIAS_LSB)
-#define BIAS_BIAS_SEL_SEL_BIAS_SET(x)            (((x) << BIAS_BIAS_SEL_SEL_BIAS_LSB) & BIAS_BIAS_SEL_SEL_BIAS_MASK)
-#define BIAS_BIAS_SEL_SEL_SPARE_MSB              24
-#define BIAS_BIAS_SEL_SEL_SPARE_LSB              21
-#define BIAS_BIAS_SEL_SEL_SPARE_MASK             0x01e00000
-#define BIAS_BIAS_SEL_SEL_SPARE_GET(x)           (((x) & BIAS_BIAS_SEL_SEL_SPARE_MASK) >> BIAS_BIAS_SEL_SEL_SPARE_LSB)
-#define BIAS_BIAS_SEL_SEL_SPARE_SET(x)           (((x) << BIAS_BIAS_SEL_SEL_SPARE_LSB) & BIAS_BIAS_SEL_SEL_SPARE_MASK)
-#define BIAS_BIAS_SEL_SPARE_MSB                  20
-#define BIAS_BIAS_SEL_SPARE_LSB                  20
-#define BIAS_BIAS_SEL_SPARE_MASK                 0x00100000
-#define BIAS_BIAS_SEL_SPARE_GET(x)               (((x) & BIAS_BIAS_SEL_SPARE_MASK) >> BIAS_BIAS_SEL_SPARE_LSB)
-#define BIAS_BIAS_SEL_SPARE_SET(x)               (((x) << BIAS_BIAS_SEL_SPARE_LSB) & BIAS_BIAS_SEL_SPARE_MASK)
-#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MSB   19
-#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB   17
-#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK  0x000e0000
-#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK) >> BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB)
-#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB) & BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK)
-#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MSB    16
-#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB    16
-#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK   0x00010000
-#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK) >> BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB)
-#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB) & BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK)
-#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MSB 15
-#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB 15
-#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK 0x00008000
-#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK) >> BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB)
-#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB) & BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK)
-#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MSB   14
-#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB   14
-#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK  0x00004000
-#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_GET(x) (((x) & BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK) >> BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_SET(x) (((x) << BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB) & BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICCPLL25_MSB           13
-#define BIAS_BIAS_SEL_PWD_ICCPLL25_LSB           13
-#define BIAS_BIAS_SEL_PWD_ICCPLL25_MASK          0x00002000
-#define BIAS_BIAS_SEL_PWD_ICCPLL25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICCPLL25_MASK) >> BIAS_BIAS_SEL_PWD_ICCPLL25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICCPLL25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICCPLL25_LSB) & BIAS_BIAS_SEL_PWD_ICCPLL25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MSB       12
-#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB       10
-#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK      0x00001c00
-#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_GET(x)    (((x) & BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK) >> BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_SET(x)    (((x) << BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB) & BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICXTAL25_MSB           9
-#define BIAS_BIAS_SEL_PWD_ICXTAL25_LSB           7
-#define BIAS_BIAS_SEL_PWD_ICXTAL25_MASK          0x00000380
-#define BIAS_BIAS_SEL_PWD_ICXTAL25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICXTAL25_MASK) >> BIAS_BIAS_SEL_PWD_ICXTAL25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICXTAL25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICXTAL25_LSB) & BIAS_BIAS_SEL_PWD_ICXTAL25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICTSENS25_MSB          6
-#define BIAS_BIAS_SEL_PWD_ICTSENS25_LSB          4
-#define BIAS_BIAS_SEL_PWD_ICTSENS25_MASK         0x00000070
-#define BIAS_BIAS_SEL_PWD_ICTSENS25_GET(x)       (((x) & BIAS_BIAS_SEL_PWD_ICTSENS25_MASK) >> BIAS_BIAS_SEL_PWD_ICTSENS25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICTSENS25_SET(x)       (((x) << BIAS_BIAS_SEL_PWD_ICTSENS25_LSB) & BIAS_BIAS_SEL_PWD_ICTSENS25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICTXPC25_MSB           3
-#define BIAS_BIAS_SEL_PWD_ICTXPC25_LSB           1
-#define BIAS_BIAS_SEL_PWD_ICTXPC25_MASK          0x0000000e
-#define BIAS_BIAS_SEL_PWD_ICTXPC25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICTXPC25_MASK) >> BIAS_BIAS_SEL_PWD_ICTXPC25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICTXPC25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICTXPC25_LSB) & BIAS_BIAS_SEL_PWD_ICTXPC25_MASK)
-#define BIAS_BIAS_SEL_PWD_ICLDO25_MSB            0
-#define BIAS_BIAS_SEL_PWD_ICLDO25_LSB            0
-#define BIAS_BIAS_SEL_PWD_ICLDO25_MASK           0x00000001
-#define BIAS_BIAS_SEL_PWD_ICLDO25_GET(x)         (((x) & BIAS_BIAS_SEL_PWD_ICLDO25_MASK) >> BIAS_BIAS_SEL_PWD_ICLDO25_LSB)
-#define BIAS_BIAS_SEL_PWD_ICLDO25_SET(x)         (((x) << BIAS_BIAS_SEL_PWD_ICLDO25_LSB) & BIAS_BIAS_SEL_PWD_ICLDO25_MASK)
-
-#define BIAS_BIAS1_ADDRESS                       0x0000003c
-#define BIAS_BIAS1_OFFSET                        0x0000003c
-#define BIAS_BIAS1_PWD_ICDAC2BB25_MSB            31
-#define BIAS_BIAS1_PWD_ICDAC2BB25_LSB            29
-#define BIAS_BIAS1_PWD_ICDAC2BB25_MASK           0xe0000000
-#define BIAS_BIAS1_PWD_ICDAC2BB25_GET(x)         (((x) & BIAS_BIAS1_PWD_ICDAC2BB25_MASK) >> BIAS_BIAS1_PWD_ICDAC2BB25_LSB)
-#define BIAS_BIAS1_PWD_ICDAC2BB25_SET(x)         (((x) << BIAS_BIAS1_PWD_ICDAC2BB25_LSB) & BIAS_BIAS1_PWD_ICDAC2BB25_MASK)
-#define BIAS_BIAS1_PWD_IC2GVGM25_MSB             28
-#define BIAS_BIAS1_PWD_IC2GVGM25_LSB             26
-#define BIAS_BIAS1_PWD_IC2GVGM25_MASK            0x1c000000
-#define BIAS_BIAS1_PWD_IC2GVGM25_GET(x)          (((x) & BIAS_BIAS1_PWD_IC2GVGM25_MASK) >> BIAS_BIAS1_PWD_IC2GVGM25_LSB)
-#define BIAS_BIAS1_PWD_IC2GVGM25_SET(x)          (((x) << BIAS_BIAS1_PWD_IC2GVGM25_LSB) & BIAS_BIAS1_PWD_IC2GVGM25_MASK)
-#define BIAS_BIAS1_PWD_IC2GRFFE25_MSB            25
-#define BIAS_BIAS1_PWD_IC2GRFFE25_LSB            23
-#define BIAS_BIAS1_PWD_IC2GRFFE25_MASK           0x03800000
-#define BIAS_BIAS1_PWD_IC2GRFFE25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC2GRFFE25_MASK) >> BIAS_BIAS1_PWD_IC2GRFFE25_LSB)
-#define BIAS_BIAS1_PWD_IC2GRFFE25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC2GRFFE25_LSB) & BIAS_BIAS1_PWD_IC2GRFFE25_MASK)
-#define BIAS_BIAS1_PWD_IC2GLOREG25_MSB           22
-#define BIAS_BIAS1_PWD_IC2GLOREG25_LSB           20
-#define BIAS_BIAS1_PWD_IC2GLOREG25_MASK          0x00700000
-#define BIAS_BIAS1_PWD_IC2GLOREG25_GET(x)        (((x) & BIAS_BIAS1_PWD_IC2GLOREG25_MASK) >> BIAS_BIAS1_PWD_IC2GLOREG25_LSB)
-#define BIAS_BIAS1_PWD_IC2GLOREG25_SET(x)        (((x) << BIAS_BIAS1_PWD_IC2GLOREG25_LSB) & BIAS_BIAS1_PWD_IC2GLOREG25_MASK)
-#define BIAS_BIAS1_PWD_IC2GLNAREG25_MSB          19
-#define BIAS_BIAS1_PWD_IC2GLNAREG25_LSB          17
-#define BIAS_BIAS1_PWD_IC2GLNAREG25_MASK         0x000e0000
-#define BIAS_BIAS1_PWD_IC2GLNAREG25_GET(x)       (((x) & BIAS_BIAS1_PWD_IC2GLNAREG25_MASK) >> BIAS_BIAS1_PWD_IC2GLNAREG25_LSB)
-#define BIAS_BIAS1_PWD_IC2GLNAREG25_SET(x)       (((x) << BIAS_BIAS1_PWD_IC2GLNAREG25_LSB) & BIAS_BIAS1_PWD_IC2GLNAREG25_MASK)
-#define BIAS_BIAS1_PWD_ICDETECTORB25_MSB         16
-#define BIAS_BIAS1_PWD_ICDETECTORB25_LSB         16
-#define BIAS_BIAS1_PWD_ICDETECTORB25_MASK        0x00010000
-#define BIAS_BIAS1_PWD_ICDETECTORB25_GET(x)      (((x) & BIAS_BIAS1_PWD_ICDETECTORB25_MASK) >> BIAS_BIAS1_PWD_ICDETECTORB25_LSB)
-#define BIAS_BIAS1_PWD_ICDETECTORB25_SET(x)      (((x) << BIAS_BIAS1_PWD_ICDETECTORB25_LSB) & BIAS_BIAS1_PWD_ICDETECTORB25_MASK)
-#define BIAS_BIAS1_PWD_ICDETECTORA25_MSB         15
-#define BIAS_BIAS1_PWD_ICDETECTORA25_LSB         15
-#define BIAS_BIAS1_PWD_ICDETECTORA25_MASK        0x00008000
-#define BIAS_BIAS1_PWD_ICDETECTORA25_GET(x)      (((x) & BIAS_BIAS1_PWD_ICDETECTORA25_MASK) >> BIAS_BIAS1_PWD_ICDETECTORA25_LSB)
-#define BIAS_BIAS1_PWD_ICDETECTORA25_SET(x)      (((x) << BIAS_BIAS1_PWD_ICDETECTORA25_LSB) & BIAS_BIAS1_PWD_ICDETECTORA25_MASK)
-#define BIAS_BIAS1_PWD_IC5GRXRF25_MSB            14
-#define BIAS_BIAS1_PWD_IC5GRXRF25_LSB            14
-#define BIAS_BIAS1_PWD_IC5GRXRF25_MASK           0x00004000
-#define BIAS_BIAS1_PWD_IC5GRXRF25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GRXRF25_MASK) >> BIAS_BIAS1_PWD_IC5GRXRF25_LSB)
-#define BIAS_BIAS1_PWD_IC5GRXRF25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GRXRF25_LSB) & BIAS_BIAS1_PWD_IC5GRXRF25_MASK)
-#define BIAS_BIAS1_PWD_IC5GTXPA25_MSB            13
-#define BIAS_BIAS1_PWD_IC5GTXPA25_LSB            11
-#define BIAS_BIAS1_PWD_IC5GTXPA25_MASK           0x00003800
-#define BIAS_BIAS1_PWD_IC5GTXPA25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GTXPA25_MASK) >> BIAS_BIAS1_PWD_IC5GTXPA25_LSB)
-#define BIAS_BIAS1_PWD_IC5GTXPA25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GTXPA25_LSB) & BIAS_BIAS1_PWD_IC5GTXPA25_MASK)
-#define BIAS_BIAS1_PWD_IC5GTXBUF25_MSB           10
-#define BIAS_BIAS1_PWD_IC5GTXBUF25_LSB           8
-#define BIAS_BIAS1_PWD_IC5GTXBUF25_MASK          0x00000700
-#define BIAS_BIAS1_PWD_IC5GTXBUF25_GET(x)        (((x) & BIAS_BIAS1_PWD_IC5GTXBUF25_MASK) >> BIAS_BIAS1_PWD_IC5GTXBUF25_LSB)
-#define BIAS_BIAS1_PWD_IC5GTXBUF25_SET(x)        (((x) << BIAS_BIAS1_PWD_IC5GTXBUF25_LSB) & BIAS_BIAS1_PWD_IC5GTXBUF25_MASK)
-#define BIAS_BIAS1_PWD_IC5GQB25_MSB              7
-#define BIAS_BIAS1_PWD_IC5GQB25_LSB              5
-#define BIAS_BIAS1_PWD_IC5GQB25_MASK             0x000000e0
-#define BIAS_BIAS1_PWD_IC5GQB25_GET(x)           (((x) & BIAS_BIAS1_PWD_IC5GQB25_MASK) >> BIAS_BIAS1_PWD_IC5GQB25_LSB)
-#define BIAS_BIAS1_PWD_IC5GQB25_SET(x)           (((x) << BIAS_BIAS1_PWD_IC5GQB25_LSB) & BIAS_BIAS1_PWD_IC5GQB25_MASK)
-#define BIAS_BIAS1_PWD_IC5GMIXQ25_MSB            4
-#define BIAS_BIAS1_PWD_IC5GMIXQ25_LSB            2
-#define BIAS_BIAS1_PWD_IC5GMIXQ25_MASK           0x0000001c
-#define BIAS_BIAS1_PWD_IC5GMIXQ25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GMIXQ25_MASK) >> BIAS_BIAS1_PWD_IC5GMIXQ25_LSB)
-#define BIAS_BIAS1_PWD_IC5GMIXQ25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GMIXQ25_LSB) & BIAS_BIAS1_PWD_IC5GMIXQ25_MASK)
-#define BIAS_BIAS1_SPARE_MSB                     1
-#define BIAS_BIAS1_SPARE_LSB                     0
-#define BIAS_BIAS1_SPARE_MASK                    0x00000003
-#define BIAS_BIAS1_SPARE_GET(x)                  (((x) & BIAS_BIAS1_SPARE_MASK) >> BIAS_BIAS1_SPARE_LSB)
-#define BIAS_BIAS1_SPARE_SET(x)                  (((x) << BIAS_BIAS1_SPARE_LSB) & BIAS_BIAS1_SPARE_MASK)
-
-#define BIAS_BIAS2_ADDRESS                       0x00000040
-#define BIAS_BIAS2_OFFSET                        0x00000040
-#define BIAS_BIAS2_PWD_IC5GMIXI25_MSB            31
-#define BIAS_BIAS2_PWD_IC5GMIXI25_LSB            29
-#define BIAS_BIAS2_PWD_IC5GMIXI25_MASK           0xe0000000
-#define BIAS_BIAS2_PWD_IC5GMIXI25_GET(x)         (((x) & BIAS_BIAS2_PWD_IC5GMIXI25_MASK) >> BIAS_BIAS2_PWD_IC5GMIXI25_LSB)
-#define BIAS_BIAS2_PWD_IC5GMIXI25_SET(x)         (((x) << BIAS_BIAS2_PWD_IC5GMIXI25_LSB) & BIAS_BIAS2_PWD_IC5GMIXI25_MASK)
-#define BIAS_BIAS2_PWD_IC5GDIV25_MSB             28
-#define BIAS_BIAS2_PWD_IC5GDIV25_LSB             26
-#define BIAS_BIAS2_PWD_IC5GDIV25_MASK            0x1c000000
-#define BIAS_BIAS2_PWD_IC5GDIV25_GET(x)          (((x) & BIAS_BIAS2_PWD_IC5GDIV25_MASK) >> BIAS_BIAS2_PWD_IC5GDIV25_LSB)
-#define BIAS_BIAS2_PWD_IC5GDIV25_SET(x)          (((x) << BIAS_BIAS2_PWD_IC5GDIV25_LSB) & BIAS_BIAS2_PWD_IC5GDIV25_MASK)
-#define BIAS_BIAS2_PWD_IC5GLOREG25_MSB           25
-#define BIAS_BIAS2_PWD_IC5GLOREG25_LSB           23
-#define BIAS_BIAS2_PWD_IC5GLOREG25_MASK          0x03800000
-#define BIAS_BIAS2_PWD_IC5GLOREG25_GET(x)        (((x) & BIAS_BIAS2_PWD_IC5GLOREG25_MASK) >> BIAS_BIAS2_PWD_IC5GLOREG25_LSB)
-#define BIAS_BIAS2_PWD_IC5GLOREG25_SET(x)        (((x) << BIAS_BIAS2_PWD_IC5GLOREG25_LSB) & BIAS_BIAS2_PWD_IC5GLOREG25_MASK)
-#define BIAS_BIAS2_PWD_IRPLL25_MSB               22
-#define BIAS_BIAS2_PWD_IRPLL25_LSB               22
-#define BIAS_BIAS2_PWD_IRPLL25_MASK              0x00400000
-#define BIAS_BIAS2_PWD_IRPLL25_GET(x)            (((x) & BIAS_BIAS2_PWD_IRPLL25_MASK) >> BIAS_BIAS2_PWD_IRPLL25_LSB)
-#define BIAS_BIAS2_PWD_IRPLL25_SET(x)            (((x) << BIAS_BIAS2_PWD_IRPLL25_LSB) & BIAS_BIAS2_PWD_IRPLL25_MASK)
-#define BIAS_BIAS2_PWD_IRXTAL25_MSB              21
-#define BIAS_BIAS2_PWD_IRXTAL25_LSB              19
-#define BIAS_BIAS2_PWD_IRXTAL25_MASK             0x00380000
-#define BIAS_BIAS2_PWD_IRXTAL25_GET(x)           (((x) & BIAS_BIAS2_PWD_IRXTAL25_MASK) >> BIAS_BIAS2_PWD_IRXTAL25_LSB)
-#define BIAS_BIAS2_PWD_IRXTAL25_SET(x)           (((x) << BIAS_BIAS2_PWD_IRXTAL25_LSB) & BIAS_BIAS2_PWD_IRXTAL25_MASK)
-#define BIAS_BIAS2_PWD_IRTSENS25_MSB             18
-#define BIAS_BIAS2_PWD_IRTSENS25_LSB             16
-#define BIAS_BIAS2_PWD_IRTSENS25_MASK            0x00070000
-#define BIAS_BIAS2_PWD_IRTSENS25_GET(x)          (((x) & BIAS_BIAS2_PWD_IRTSENS25_MASK) >> BIAS_BIAS2_PWD_IRTSENS25_LSB)
-#define BIAS_BIAS2_PWD_IRTSENS25_SET(x)          (((x) << BIAS_BIAS2_PWD_IRTSENS25_LSB) & BIAS_BIAS2_PWD_IRTSENS25_MASK)
-#define BIAS_BIAS2_PWD_IRTXPC25_MSB              15
-#define BIAS_BIAS2_PWD_IRTXPC25_LSB              13
-#define BIAS_BIAS2_PWD_IRTXPC25_MASK             0x0000e000
-#define BIAS_BIAS2_PWD_IRTXPC25_GET(x)           (((x) & BIAS_BIAS2_PWD_IRTXPC25_MASK) >> BIAS_BIAS2_PWD_IRTXPC25_LSB)
-#define BIAS_BIAS2_PWD_IRTXPC25_SET(x)           (((x) << BIAS_BIAS2_PWD_IRTXPC25_LSB) & BIAS_BIAS2_PWD_IRTXPC25_MASK)
-#define BIAS_BIAS2_PWD_IRLDO25_MSB               12
-#define BIAS_BIAS2_PWD_IRLDO25_LSB               12
-#define BIAS_BIAS2_PWD_IRLDO25_MASK              0x00001000
-#define BIAS_BIAS2_PWD_IRLDO25_GET(x)            (((x) & BIAS_BIAS2_PWD_IRLDO25_MASK) >> BIAS_BIAS2_PWD_IRLDO25_LSB)
-#define BIAS_BIAS2_PWD_IRLDO25_SET(x)            (((x) << BIAS_BIAS2_PWD_IRLDO25_LSB) & BIAS_BIAS2_PWD_IRLDO25_MASK)
-#define BIAS_BIAS2_PWD_IR2GTXMIX25_MSB           11
-#define BIAS_BIAS2_PWD_IR2GTXMIX25_LSB           9
-#define BIAS_BIAS2_PWD_IR2GTXMIX25_MASK          0x00000e00
-#define BIAS_BIAS2_PWD_IR2GTXMIX25_GET(x)        (((x) & BIAS_BIAS2_PWD_IR2GTXMIX25_MASK) >> BIAS_BIAS2_PWD_IR2GTXMIX25_LSB)
-#define BIAS_BIAS2_PWD_IR2GTXMIX25_SET(x)        (((x) << BIAS_BIAS2_PWD_IR2GTXMIX25_LSB) & BIAS_BIAS2_PWD_IR2GTXMIX25_MASK)
-#define BIAS_BIAS2_PWD_IR2GLOREG25_MSB           8
-#define BIAS_BIAS2_PWD_IR2GLOREG25_LSB           6
-#define BIAS_BIAS2_PWD_IR2GLOREG25_MASK          0x000001c0
-#define BIAS_BIAS2_PWD_IR2GLOREG25_GET(x)        (((x) & BIAS_BIAS2_PWD_IR2GLOREG25_MASK) >> BIAS_BIAS2_PWD_IR2GLOREG25_LSB)
-#define BIAS_BIAS2_PWD_IR2GLOREG25_SET(x)        (((x) << BIAS_BIAS2_PWD_IR2GLOREG25_LSB) & BIAS_BIAS2_PWD_IR2GLOREG25_MASK)
-#define BIAS_BIAS2_PWD_IR2GLNAREG25_MSB          5
-#define BIAS_BIAS2_PWD_IR2GLNAREG25_LSB          3
-#define BIAS_BIAS2_PWD_IR2GLNAREG25_MASK         0x00000038
-#define BIAS_BIAS2_PWD_IR2GLNAREG25_GET(x)       (((x) & BIAS_BIAS2_PWD_IR2GLNAREG25_MASK) >> BIAS_BIAS2_PWD_IR2GLNAREG25_LSB)
-#define BIAS_BIAS2_PWD_IR2GLNAREG25_SET(x)       (((x) << BIAS_BIAS2_PWD_IR2GLNAREG25_LSB) & BIAS_BIAS2_PWD_IR2GLNAREG25_MASK)
-#define BIAS_BIAS2_PWD_IR5GRFVREF2525_MSB        2
-#define BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB        0
-#define BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK       0x00000007
-#define BIAS_BIAS2_PWD_IR5GRFVREF2525_GET(x)     (((x) & BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK) >> BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB)
-#define BIAS_BIAS2_PWD_IR5GRFVREF2525_SET(x)     (((x) << BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB) & BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK)
-
-#define BIAS_BIAS3_ADDRESS                       0x00000044
-#define BIAS_BIAS3_OFFSET                        0x00000044
-#define BIAS_BIAS3_PWD_IR5GTXMIX25_MSB           31
-#define BIAS_BIAS3_PWD_IR5GTXMIX25_LSB           29
-#define BIAS_BIAS3_PWD_IR5GTXMIX25_MASK          0xe0000000
-#define BIAS_BIAS3_PWD_IR5GTXMIX25_GET(x)        (((x) & BIAS_BIAS3_PWD_IR5GTXMIX25_MASK) >> BIAS_BIAS3_PWD_IR5GTXMIX25_LSB)
-#define BIAS_BIAS3_PWD_IR5GTXMIX25_SET(x)        (((x) << BIAS_BIAS3_PWD_IR5GTXMIX25_LSB) & BIAS_BIAS3_PWD_IR5GTXMIX25_MASK)
-#define BIAS_BIAS3_PWD_IR5GAGC25_MSB             28
-#define BIAS_BIAS3_PWD_IR5GAGC25_LSB             26
-#define BIAS_BIAS3_PWD_IR5GAGC25_MASK            0x1c000000
-#define BIAS_BIAS3_PWD_IR5GAGC25_GET(x)          (((x) & BIAS_BIAS3_PWD_IR5GAGC25_MASK) >> BIAS_BIAS3_PWD_IR5GAGC25_LSB)
-#define BIAS_BIAS3_PWD_IR5GAGC25_SET(x)          (((x) << BIAS_BIAS3_PWD_IR5GAGC25_LSB) & BIAS_BIAS3_PWD_IR5GAGC25_MASK)
-#define BIAS_BIAS3_PWD_ICDAC50_MSB               25
-#define BIAS_BIAS3_PWD_ICDAC50_LSB               23
-#define BIAS_BIAS3_PWD_ICDAC50_MASK              0x03800000
-#define BIAS_BIAS3_PWD_ICDAC50_GET(x)            (((x) & BIAS_BIAS3_PWD_ICDAC50_MASK) >> BIAS_BIAS3_PWD_ICDAC50_LSB)
-#define BIAS_BIAS3_PWD_ICDAC50_SET(x)            (((x) << BIAS_BIAS3_PWD_ICDAC50_LSB) & BIAS_BIAS3_PWD_ICDAC50_MASK)
-#define BIAS_BIAS3_PWD_ICSYNTH50_MSB             22
-#define BIAS_BIAS3_PWD_ICSYNTH50_LSB             22
-#define BIAS_BIAS3_PWD_ICSYNTH50_MASK            0x00400000
-#define BIAS_BIAS3_PWD_ICSYNTH50_GET(x)          (((x) & BIAS_BIAS3_PWD_ICSYNTH50_MASK) >> BIAS_BIAS3_PWD_ICSYNTH50_LSB)
-#define BIAS_BIAS3_PWD_ICSYNTH50_SET(x)          (((x) << BIAS_BIAS3_PWD_ICSYNTH50_LSB) & BIAS_BIAS3_PWD_ICSYNTH50_MASK)
-#define BIAS_BIAS3_PWD_ICBB50_MSB                21
-#define BIAS_BIAS3_PWD_ICBB50_LSB                21
-#define BIAS_BIAS3_PWD_ICBB50_MASK               0x00200000
-#define BIAS_BIAS3_PWD_ICBB50_GET(x)             (((x) & BIAS_BIAS3_PWD_ICBB50_MASK) >> BIAS_BIAS3_PWD_ICBB50_LSB)
-#define BIAS_BIAS3_PWD_ICBB50_SET(x)             (((x) << BIAS_BIAS3_PWD_ICBB50_LSB) & BIAS_BIAS3_PWD_ICBB50_MASK)
-#define BIAS_BIAS3_PWD_IC2GDIV50_MSB             20
-#define BIAS_BIAS3_PWD_IC2GDIV50_LSB             18
-#define BIAS_BIAS3_PWD_IC2GDIV50_MASK            0x001c0000
-#define BIAS_BIAS3_PWD_IC2GDIV50_GET(x)          (((x) & BIAS_BIAS3_PWD_IC2GDIV50_MASK) >> BIAS_BIAS3_PWD_IC2GDIV50_LSB)
-#define BIAS_BIAS3_PWD_IC2GDIV50_SET(x)          (((x) << BIAS_BIAS3_PWD_IC2GDIV50_LSB) & BIAS_BIAS3_PWD_IC2GDIV50_MASK)
-#define BIAS_BIAS3_PWD_IRSYNTH50_MSB             17
-#define BIAS_BIAS3_PWD_IRSYNTH50_LSB             17
-#define BIAS_BIAS3_PWD_IRSYNTH50_MASK            0x00020000
-#define BIAS_BIAS3_PWD_IRSYNTH50_GET(x)          (((x) & BIAS_BIAS3_PWD_IRSYNTH50_MASK) >> BIAS_BIAS3_PWD_IRSYNTH50_LSB)
-#define BIAS_BIAS3_PWD_IRSYNTH50_SET(x)          (((x) << BIAS_BIAS3_PWD_IRSYNTH50_LSB) & BIAS_BIAS3_PWD_IRSYNTH50_MASK)
-#define BIAS_BIAS3_PWD_IRBB50_MSB                16
-#define BIAS_BIAS3_PWD_IRBB50_LSB                16
-#define BIAS_BIAS3_PWD_IRBB50_MASK               0x00010000
-#define BIAS_BIAS3_PWD_IRBB50_GET(x)             (((x) & BIAS_BIAS3_PWD_IRBB50_MASK) >> BIAS_BIAS3_PWD_IRBB50_LSB)
-#define BIAS_BIAS3_PWD_IRBB50_SET(x)             (((x) << BIAS_BIAS3_PWD_IRBB50_LSB) & BIAS_BIAS3_PWD_IRBB50_MASK)
-#define BIAS_BIAS3_PWD_IC25SPARE1_MSB            15
-#define BIAS_BIAS3_PWD_IC25SPARE1_LSB            13
-#define BIAS_BIAS3_PWD_IC25SPARE1_MASK           0x0000e000
-#define BIAS_BIAS3_PWD_IC25SPARE1_GET(x)         (((x) & BIAS_BIAS3_PWD_IC25SPARE1_MASK) >> BIAS_BIAS3_PWD_IC25SPARE1_LSB)
-#define BIAS_BIAS3_PWD_IC25SPARE1_SET(x)         (((x) << BIAS_BIAS3_PWD_IC25SPARE1_LSB) & BIAS_BIAS3_PWD_IC25SPARE1_MASK)
-#define BIAS_BIAS3_PWD_IC25SPARE2_MSB            12
-#define BIAS_BIAS3_PWD_IC25SPARE2_LSB            10
-#define BIAS_BIAS3_PWD_IC25SPARE2_MASK           0x00001c00
-#define BIAS_BIAS3_PWD_IC25SPARE2_GET(x)         (((x) & BIAS_BIAS3_PWD_IC25SPARE2_MASK) >> BIAS_BIAS3_PWD_IC25SPARE2_LSB)
-#define BIAS_BIAS3_PWD_IC25SPARE2_SET(x)         (((x) << BIAS_BIAS3_PWD_IC25SPARE2_LSB) & BIAS_BIAS3_PWD_IC25SPARE2_MASK)
-#define BIAS_BIAS3_PWD_IR25SPARE1_MSB            9
-#define BIAS_BIAS3_PWD_IR25SPARE1_LSB            7
-#define BIAS_BIAS3_PWD_IR25SPARE1_MASK           0x00000380
-#define BIAS_BIAS3_PWD_IR25SPARE1_GET(x)         (((x) & BIAS_BIAS3_PWD_IR25SPARE1_MASK) >> BIAS_BIAS3_PWD_IR25SPARE1_LSB)
-#define BIAS_BIAS3_PWD_IR25SPARE1_SET(x)         (((x) << BIAS_BIAS3_PWD_IR25SPARE1_LSB) & BIAS_BIAS3_PWD_IR25SPARE1_MASK)
-#define BIAS_BIAS3_PWD_IR25SPARE2_MSB            6
-#define BIAS_BIAS3_PWD_IR25SPARE2_LSB            4
-#define BIAS_BIAS3_PWD_IR25SPARE2_MASK           0x00000070
-#define BIAS_BIAS3_PWD_IR25SPARE2_GET(x)         (((x) & BIAS_BIAS3_PWD_IR25SPARE2_MASK) >> BIAS_BIAS3_PWD_IR25SPARE2_LSB)
-#define BIAS_BIAS3_PWD_IR25SPARE2_SET(x)         (((x) << BIAS_BIAS3_PWD_IR25SPARE2_LSB) & BIAS_BIAS3_PWD_IR25SPARE2_MASK)
-#define BIAS_BIAS3_PWD_ICDACREG12P5_MSB          3
-#define BIAS_BIAS3_PWD_ICDACREG12P5_LSB          1
-#define BIAS_BIAS3_PWD_ICDACREG12P5_MASK         0x0000000e
-#define BIAS_BIAS3_PWD_ICDACREG12P5_GET(x)       (((x) & BIAS_BIAS3_PWD_ICDACREG12P5_MASK) >> BIAS_BIAS3_PWD_ICDACREG12P5_LSB)
-#define BIAS_BIAS3_PWD_ICDACREG12P5_SET(x)       (((x) << BIAS_BIAS3_PWD_ICDACREG12P5_LSB) & BIAS_BIAS3_PWD_ICDACREG12P5_MASK)
-#define BIAS_BIAS3_SPARE_MSB                     0
-#define BIAS_BIAS3_SPARE_LSB                     0
-#define BIAS_BIAS3_SPARE_MASK                    0x00000001
-#define BIAS_BIAS3_SPARE_GET(x)                  (((x) & BIAS_BIAS3_SPARE_MASK) >> BIAS_BIAS3_SPARE_LSB)
-#define BIAS_BIAS3_SPARE_SET(x)                  (((x) << BIAS_BIAS3_SPARE_LSB) & BIAS_BIAS3_SPARE_MASK)
-
-#define TXPC_TXPC_ADDRESS                        0x00000048
-#define TXPC_TXPC_OFFSET                         0x00000048
-#define TXPC_TXPC_SELINTPD_MSB                   31
-#define TXPC_TXPC_SELINTPD_LSB                   31
-#define TXPC_TXPC_SELINTPD_MASK                  0x80000000
-#define TXPC_TXPC_SELINTPD_GET(x)                (((x) & TXPC_TXPC_SELINTPD_MASK) >> TXPC_TXPC_SELINTPD_LSB)
-#define TXPC_TXPC_SELINTPD_SET(x)                (((x) << TXPC_TXPC_SELINTPD_LSB) & TXPC_TXPC_SELINTPD_MASK)
-#define TXPC_TXPC_TEST_MSB                       30
-#define TXPC_TXPC_TEST_LSB                       30
-#define TXPC_TXPC_TEST_MASK                      0x40000000
-#define TXPC_TXPC_TEST_GET(x)                    (((x) & TXPC_TXPC_TEST_MASK) >> TXPC_TXPC_TEST_LSB)
-#define TXPC_TXPC_TEST_SET(x)                    (((x) << TXPC_TXPC_TEST_LSB) & TXPC_TXPC_TEST_MASK)
-#define TXPC_TXPC_TESTGAIN_MSB                   29
-#define TXPC_TXPC_TESTGAIN_LSB                   28
-#define TXPC_TXPC_TESTGAIN_MASK                  0x30000000
-#define TXPC_TXPC_TESTGAIN_GET(x)                (((x) & TXPC_TXPC_TESTGAIN_MASK) >> TXPC_TXPC_TESTGAIN_LSB)
-#define TXPC_TXPC_TESTGAIN_SET(x)                (((x) << TXPC_TXPC_TESTGAIN_LSB) & TXPC_TXPC_TESTGAIN_MASK)
-#define TXPC_TXPC_TESTDAC_MSB                    27
-#define TXPC_TXPC_TESTDAC_LSB                    22
-#define TXPC_TXPC_TESTDAC_MASK                   0x0fc00000
-#define TXPC_TXPC_TESTDAC_GET(x)                 (((x) & TXPC_TXPC_TESTDAC_MASK) >> TXPC_TXPC_TESTDAC_LSB)
-#define TXPC_TXPC_TESTDAC_SET(x)                 (((x) << TXPC_TXPC_TESTDAC_LSB) & TXPC_TXPC_TESTDAC_MASK)
-#define TXPC_TXPC_TESTPWDPC_MSB                  21
-#define TXPC_TXPC_TESTPWDPC_LSB                  21
-#define TXPC_TXPC_TESTPWDPC_MASK                 0x00200000
-#define TXPC_TXPC_TESTPWDPC_GET(x)               (((x) & TXPC_TXPC_TESTPWDPC_MASK) >> TXPC_TXPC_TESTPWDPC_LSB)
-#define TXPC_TXPC_TESTPWDPC_SET(x)               (((x) << TXPC_TXPC_TESTPWDPC_LSB) & TXPC_TXPC_TESTPWDPC_MASK)
-#define TXPC_TXPC_CURHALF_MSB                    20
-#define TXPC_TXPC_CURHALF_LSB                    20
-#define TXPC_TXPC_CURHALF_MASK                   0x00100000
-#define TXPC_TXPC_CURHALF_GET(x)                 (((x) & TXPC_TXPC_CURHALF_MASK) >> TXPC_TXPC_CURHALF_LSB)
-#define TXPC_TXPC_CURHALF_SET(x)                 (((x) << TXPC_TXPC_CURHALF_LSB) & TXPC_TXPC_CURHALF_MASK)
-#define TXPC_TXPC_NEGOUT_MSB                     19
-#define TXPC_TXPC_NEGOUT_LSB                     19
-#define TXPC_TXPC_NEGOUT_MASK                    0x00080000
-#define TXPC_TXPC_NEGOUT_GET(x)                  (((x) & TXPC_TXPC_NEGOUT_MASK) >> TXPC_TXPC_NEGOUT_LSB)
-#define TXPC_TXPC_NEGOUT_SET(x)                  (((x) << TXPC_TXPC_NEGOUT_LSB) & TXPC_TXPC_NEGOUT_MASK)
-#define TXPC_TXPC_CLKDELAY_MSB                   18
-#define TXPC_TXPC_CLKDELAY_LSB                   18
-#define TXPC_TXPC_CLKDELAY_MASK                  0x00040000
-#define TXPC_TXPC_CLKDELAY_GET(x)                (((x) & TXPC_TXPC_CLKDELAY_MASK) >> TXPC_TXPC_CLKDELAY_LSB)
-#define TXPC_TXPC_CLKDELAY_SET(x)                (((x) << TXPC_TXPC_CLKDELAY_LSB) & TXPC_TXPC_CLKDELAY_MASK)
-#define TXPC_TXPC_SELMODREF_MSB                  17
-#define TXPC_TXPC_SELMODREF_LSB                  17
-#define TXPC_TXPC_SELMODREF_MASK                 0x00020000
-#define TXPC_TXPC_SELMODREF_GET(x)               (((x) & TXPC_TXPC_SELMODREF_MASK) >> TXPC_TXPC_SELMODREF_LSB)
-#define TXPC_TXPC_SELMODREF_SET(x)               (((x) << TXPC_TXPC_SELMODREF_LSB) & TXPC_TXPC_SELMODREF_MASK)
-#define TXPC_TXPC_SELCMOUT_MSB                   16
-#define TXPC_TXPC_SELCMOUT_LSB                   16
-#define TXPC_TXPC_SELCMOUT_MASK                  0x00010000
-#define TXPC_TXPC_SELCMOUT_GET(x)                (((x) & TXPC_TXPC_SELCMOUT_MASK) >> TXPC_TXPC_SELCMOUT_LSB)
-#define TXPC_TXPC_SELCMOUT_SET(x)                (((x) << TXPC_TXPC_SELCMOUT_LSB) & TXPC_TXPC_SELCMOUT_MASK)
-#define TXPC_TXPC_TSMODE_MSB                     15
-#define TXPC_TXPC_TSMODE_LSB                     14
-#define TXPC_TXPC_TSMODE_MASK                    0x0000c000
-#define TXPC_TXPC_TSMODE_GET(x)                  (((x) & TXPC_TXPC_TSMODE_MASK) >> TXPC_TXPC_TSMODE_LSB)
-#define TXPC_TXPC_TSMODE_SET(x)                  (((x) << TXPC_TXPC_TSMODE_LSB) & TXPC_TXPC_TSMODE_MASK)
-#define TXPC_TXPC_N_MSB                          13
-#define TXPC_TXPC_N_LSB                          6
-#define TXPC_TXPC_N_MASK                         0x00003fc0
-#define TXPC_TXPC_N_GET(x)                       (((x) & TXPC_TXPC_N_MASK) >> TXPC_TXPC_N_LSB)
-#define TXPC_TXPC_N_SET(x)                       (((x) << TXPC_TXPC_N_LSB) & TXPC_TXPC_N_MASK)
-#define TXPC_TXPC_ON1STSYNTHON_MSB               5
-#define TXPC_TXPC_ON1STSYNTHON_LSB               5
-#define TXPC_TXPC_ON1STSYNTHON_MASK              0x00000020
-#define TXPC_TXPC_ON1STSYNTHON_GET(x)            (((x) & TXPC_TXPC_ON1STSYNTHON_MASK) >> TXPC_TXPC_ON1STSYNTHON_LSB)
-#define TXPC_TXPC_ON1STSYNTHON_SET(x)            (((x) << TXPC_TXPC_ON1STSYNTHON_LSB) & TXPC_TXPC_ON1STSYNTHON_MASK)
-#define TXPC_TXPC_SELINIT_MSB                    4
-#define TXPC_TXPC_SELINIT_LSB                    3
-#define TXPC_TXPC_SELINIT_MASK                   0x00000018
-#define TXPC_TXPC_SELINIT_GET(x)                 (((x) & TXPC_TXPC_SELINIT_MASK) >> TXPC_TXPC_SELINIT_LSB)
-#define TXPC_TXPC_SELINIT_SET(x)                 (((x) << TXPC_TXPC_SELINIT_LSB) & TXPC_TXPC_SELINIT_MASK)
-#define TXPC_TXPC_SELCOUNT_MSB                   2
-#define TXPC_TXPC_SELCOUNT_LSB                   2
-#define TXPC_TXPC_SELCOUNT_MASK                  0x00000004
-#define TXPC_TXPC_SELCOUNT_GET(x)                (((x) & TXPC_TXPC_SELCOUNT_MASK) >> TXPC_TXPC_SELCOUNT_LSB)
-#define TXPC_TXPC_SELCOUNT_SET(x)                (((x) << TXPC_TXPC_SELCOUNT_LSB) & TXPC_TXPC_SELCOUNT_MASK)
-#define TXPC_TXPC_ATBSEL_MSB                     1
-#define TXPC_TXPC_ATBSEL_LSB                     0
-#define TXPC_TXPC_ATBSEL_MASK                    0x00000003
-#define TXPC_TXPC_ATBSEL_GET(x)                  (((x) & TXPC_TXPC_ATBSEL_MASK) >> TXPC_TXPC_ATBSEL_LSB)
-#define TXPC_TXPC_ATBSEL_SET(x)                  (((x) << TXPC_TXPC_ATBSEL_LSB) & TXPC_TXPC_ATBSEL_MASK)
-
-#define TXPC_MISC_ADDRESS                        0x0000004c
-#define TXPC_MISC_OFFSET                         0x0000004c
-#define TXPC_MISC_FLIPBMODE_MSB                  31
-#define TXPC_MISC_FLIPBMODE_LSB                  31
-#define TXPC_MISC_FLIPBMODE_MASK                 0x80000000
-#define TXPC_MISC_FLIPBMODE_GET(x)               (((x) & TXPC_MISC_FLIPBMODE_MASK) >> TXPC_MISC_FLIPBMODE_LSB)
-#define TXPC_MISC_FLIPBMODE_SET(x)               (((x) << TXPC_MISC_FLIPBMODE_LSB) & TXPC_MISC_FLIPBMODE_MASK)
-#define TXPC_MISC_LEVEL_MSB                      30
-#define TXPC_MISC_LEVEL_LSB                      29
-#define TXPC_MISC_LEVEL_MASK                     0x60000000
-#define TXPC_MISC_LEVEL_GET(x)                   (((x) & TXPC_MISC_LEVEL_MASK) >> TXPC_MISC_LEVEL_LSB)
-#define TXPC_MISC_LEVEL_SET(x)                   (((x) << TXPC_MISC_LEVEL_LSB) & TXPC_MISC_LEVEL_MASK)
-#define TXPC_MISC_LDO_TEST_MODE_MSB              28
-#define TXPC_MISC_LDO_TEST_MODE_LSB              28
-#define TXPC_MISC_LDO_TEST_MODE_MASK             0x10000000
-#define TXPC_MISC_LDO_TEST_MODE_GET(x)           (((x) & TXPC_MISC_LDO_TEST_MODE_MASK) >> TXPC_MISC_LDO_TEST_MODE_LSB)
-#define TXPC_MISC_LDO_TEST_MODE_SET(x)           (((x) << TXPC_MISC_LDO_TEST_MODE_LSB) & TXPC_MISC_LDO_TEST_MODE_MASK)
-#define TXPC_MISC_NOTCXODET_MSB                  27
-#define TXPC_MISC_NOTCXODET_LSB                  27
-#define TXPC_MISC_NOTCXODET_MASK                 0x08000000
-#define TXPC_MISC_NOTCXODET_GET(x)               (((x) & TXPC_MISC_NOTCXODET_MASK) >> TXPC_MISC_NOTCXODET_LSB)
-#define TXPC_MISC_NOTCXODET_SET(x)               (((x) << TXPC_MISC_NOTCXODET_LSB) & TXPC_MISC_NOTCXODET_MASK)
-#define TXPC_MISC_PWDCLKIND_MSB                  26
-#define TXPC_MISC_PWDCLKIND_LSB                  26
-#define TXPC_MISC_PWDCLKIND_MASK                 0x04000000
-#define TXPC_MISC_PWDCLKIND_GET(x)               (((x) & TXPC_MISC_PWDCLKIND_MASK) >> TXPC_MISC_PWDCLKIND_LSB)
-#define TXPC_MISC_PWDCLKIND_SET(x)               (((x) << TXPC_MISC_PWDCLKIND_LSB) & TXPC_MISC_PWDCLKIND_MASK)
-#define TXPC_MISC_PWDXINPAD_MSB                  25
-#define TXPC_MISC_PWDXINPAD_LSB                  25
-#define TXPC_MISC_PWDXINPAD_MASK                 0x02000000
-#define TXPC_MISC_PWDXINPAD_GET(x)               (((x) & TXPC_MISC_PWDXINPAD_MASK) >> TXPC_MISC_PWDXINPAD_LSB)
-#define TXPC_MISC_PWDXINPAD_SET(x)               (((x) << TXPC_MISC_PWDXINPAD_LSB) & TXPC_MISC_PWDXINPAD_MASK)
-#define TXPC_MISC_LOCALBIAS_MSB                  24
-#define TXPC_MISC_LOCALBIAS_LSB                  24
-#define TXPC_MISC_LOCALBIAS_MASK                 0x01000000
-#define TXPC_MISC_LOCALBIAS_GET(x)               (((x) & TXPC_MISC_LOCALBIAS_MASK) >> TXPC_MISC_LOCALBIAS_LSB)
-#define TXPC_MISC_LOCALBIAS_SET(x)               (((x) << TXPC_MISC_LOCALBIAS_LSB) & TXPC_MISC_LOCALBIAS_MASK)
-#define TXPC_MISC_LOCALBIAS2X_MSB                23
-#define TXPC_MISC_LOCALBIAS2X_LSB                23
-#define TXPC_MISC_LOCALBIAS2X_MASK               0x00800000
-#define TXPC_MISC_LOCALBIAS2X_GET(x)             (((x) & TXPC_MISC_LOCALBIAS2X_MASK) >> TXPC_MISC_LOCALBIAS2X_LSB)
-#define TXPC_MISC_LOCALBIAS2X_SET(x)             (((x) << TXPC_MISC_LOCALBIAS2X_LSB) & TXPC_MISC_LOCALBIAS2X_MASK)
-#define TXPC_MISC_SELTSP_MSB                     22
-#define TXPC_MISC_SELTSP_LSB                     22
-#define TXPC_MISC_SELTSP_MASK                    0x00400000
-#define TXPC_MISC_SELTSP_GET(x)                  (((x) & TXPC_MISC_SELTSP_MASK) >> TXPC_MISC_SELTSP_LSB)
-#define TXPC_MISC_SELTSP_SET(x)                  (((x) << TXPC_MISC_SELTSP_LSB) & TXPC_MISC_SELTSP_MASK)
-#define TXPC_MISC_SELTSN_MSB                     21
-#define TXPC_MISC_SELTSN_LSB                     21
-#define TXPC_MISC_SELTSN_MASK                    0x00200000
-#define TXPC_MISC_SELTSN_GET(x)                  (((x) & TXPC_MISC_SELTSN_MASK) >> TXPC_MISC_SELTSN_LSB)
-#define TXPC_MISC_SELTSN_SET(x)                  (((x) << TXPC_MISC_SELTSN_LSB) & TXPC_MISC_SELTSN_MASK)
-#define TXPC_MISC_SPARE_A_MSB                    20
-#define TXPC_MISC_SPARE_A_LSB                    18
-#define TXPC_MISC_SPARE_A_MASK                   0x001c0000
-#define TXPC_MISC_SPARE_A_GET(x)                 (((x) & TXPC_MISC_SPARE_A_MASK) >> TXPC_MISC_SPARE_A_LSB)
-#define TXPC_MISC_SPARE_A_SET(x)                 (((x) << TXPC_MISC_SPARE_A_LSB) & TXPC_MISC_SPARE_A_MASK)
-#define TXPC_MISC_DECOUT_MSB                     17
-#define TXPC_MISC_DECOUT_LSB                     8
-#define TXPC_MISC_DECOUT_MASK                    0x0003ff00
-#define TXPC_MISC_DECOUT_GET(x)                  (((x) & TXPC_MISC_DECOUT_MASK) >> TXPC_MISC_DECOUT_LSB)
-#define TXPC_MISC_DECOUT_SET(x)                  (((x) << TXPC_MISC_DECOUT_LSB) & TXPC_MISC_DECOUT_MASK)
-#define TXPC_MISC_XTALDIV_MSB                    7
-#define TXPC_MISC_XTALDIV_LSB                    6
-#define TXPC_MISC_XTALDIV_MASK                   0x000000c0
-#define TXPC_MISC_XTALDIV_GET(x)                 (((x) & TXPC_MISC_XTALDIV_MASK) >> TXPC_MISC_XTALDIV_LSB)
-#define TXPC_MISC_XTALDIV_SET(x)                 (((x) << TXPC_MISC_XTALDIV_LSB) & TXPC_MISC_XTALDIV_MASK)
-#define TXPC_MISC_SPARE_MSB                      5
-#define TXPC_MISC_SPARE_LSB                      0
-#define TXPC_MISC_SPARE_MASK                     0x0000003f
-#define TXPC_MISC_SPARE_GET(x)                   (((x) & TXPC_MISC_SPARE_MASK) >> TXPC_MISC_SPARE_LSB)
-#define TXPC_MISC_SPARE_SET(x)                   (((x) << TXPC_MISC_SPARE_LSB) & TXPC_MISC_SPARE_MASK)
-
-#define RXTXBB_RXTXBB1_ADDRESS                   0x00000050
-#define RXTXBB_RXTXBB1_OFFSET                    0x00000050
-#define RXTXBB_RXTXBB1_SPARE_MSB                 31
-#define RXTXBB_RXTXBB1_SPARE_LSB                 19
-#define RXTXBB_RXTXBB1_SPARE_MASK                0xfff80000
-#define RXTXBB_RXTXBB1_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB1_SPARE_MASK) >> RXTXBB_RXTXBB1_SPARE_LSB)
-#define RXTXBB_RXTXBB1_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB1_SPARE_LSB) & RXTXBB_RXTXBB1_SPARE_MASK)
-#define RXTXBB_RXTXBB1_FNOTCH_MSB                18
-#define RXTXBB_RXTXBB1_FNOTCH_LSB                17
-#define RXTXBB_RXTXBB1_FNOTCH_MASK               0x00060000
-#define RXTXBB_RXTXBB1_FNOTCH_GET(x)             (((x) & RXTXBB_RXTXBB1_FNOTCH_MASK) >> RXTXBB_RXTXBB1_FNOTCH_LSB)
-#define RXTXBB_RXTXBB1_FNOTCH_SET(x)             (((x) << RXTXBB_RXTXBB1_FNOTCH_LSB) & RXTXBB_RXTXBB1_FNOTCH_MASK)
-#define RXTXBB_RXTXBB1_SEL_ATB_MSB               16
-#define RXTXBB_RXTXBB1_SEL_ATB_LSB               9
-#define RXTXBB_RXTXBB1_SEL_ATB_MASK              0x0001fe00
-#define RXTXBB_RXTXBB1_SEL_ATB_GET(x)            (((x) & RXTXBB_RXTXBB1_SEL_ATB_MASK) >> RXTXBB_RXTXBB1_SEL_ATB_LSB)
-#define RXTXBB_RXTXBB1_SEL_ATB_SET(x)            (((x) << RXTXBB_RXTXBB1_SEL_ATB_LSB) & RXTXBB_RXTXBB1_SEL_ATB_MASK)
-#define RXTXBB_RXTXBB1_PDDACINTERFACE_MSB        8
-#define RXTXBB_RXTXBB1_PDDACINTERFACE_LSB        8
-#define RXTXBB_RXTXBB1_PDDACINTERFACE_MASK       0x00000100
-#define RXTXBB_RXTXBB1_PDDACINTERFACE_GET(x)     (((x) & RXTXBB_RXTXBB1_PDDACINTERFACE_MASK) >> RXTXBB_RXTXBB1_PDDACINTERFACE_LSB)
-#define RXTXBB_RXTXBB1_PDDACINTERFACE_SET(x)     (((x) << RXTXBB_RXTXBB1_PDDACINTERFACE_LSB) & RXTXBB_RXTXBB1_PDDACINTERFACE_MASK)
-#define RXTXBB_RXTXBB1_PDV2I_MSB                 7
-#define RXTXBB_RXTXBB1_PDV2I_LSB                 7
-#define RXTXBB_RXTXBB1_PDV2I_MASK                0x00000080
-#define RXTXBB_RXTXBB1_PDV2I_GET(x)              (((x) & RXTXBB_RXTXBB1_PDV2I_MASK) >> RXTXBB_RXTXBB1_PDV2I_LSB)
-#define RXTXBB_RXTXBB1_PDV2I_SET(x)              (((x) << RXTXBB_RXTXBB1_PDV2I_LSB) & RXTXBB_RXTXBB1_PDV2I_MASK)
-#define RXTXBB_RXTXBB1_PDI2V_MSB                 6
-#define RXTXBB_RXTXBB1_PDI2V_LSB                 6
-#define RXTXBB_RXTXBB1_PDI2V_MASK                0x00000040
-#define RXTXBB_RXTXBB1_PDI2V_GET(x)              (((x) & RXTXBB_RXTXBB1_PDI2V_MASK) >> RXTXBB_RXTXBB1_PDI2V_LSB)
-#define RXTXBB_RXTXBB1_PDI2V_SET(x)              (((x) << RXTXBB_RXTXBB1_PDI2V_LSB) & RXTXBB_RXTXBB1_PDI2V_MASK)
-#define RXTXBB_RXTXBB1_PDRXTXBB_MSB              5
-#define RXTXBB_RXTXBB1_PDRXTXBB_LSB              5
-#define RXTXBB_RXTXBB1_PDRXTXBB_MASK             0x00000020
-#define RXTXBB_RXTXBB1_PDRXTXBB_GET(x)           (((x) & RXTXBB_RXTXBB1_PDRXTXBB_MASK) >> RXTXBB_RXTXBB1_PDRXTXBB_LSB)
-#define RXTXBB_RXTXBB1_PDRXTXBB_SET(x)           (((x) << RXTXBB_RXTXBB1_PDRXTXBB_LSB) & RXTXBB_RXTXBB1_PDRXTXBB_MASK)
-#define RXTXBB_RXTXBB1_PDOFFSETLOQ_MSB           4
-#define RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB           4
-#define RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK          0x00000010
-#define RXTXBB_RXTXBB1_PDOFFSETLOQ_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK) >> RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB)
-#define RXTXBB_RXTXBB1_PDOFFSETLOQ_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB) & RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK)
-#define RXTXBB_RXTXBB1_PDOFFSETHIQ_MSB           3
-#define RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB           3
-#define RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK          0x00000008
-#define RXTXBB_RXTXBB1_PDOFFSETHIQ_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK) >> RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB)
-#define RXTXBB_RXTXBB1_PDOFFSETHIQ_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB) & RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK)
-#define RXTXBB_RXTXBB1_PDOFFSETI2V_MSB           2
-#define RXTXBB_RXTXBB1_PDOFFSETI2V_LSB           2
-#define RXTXBB_RXTXBB1_PDOFFSETI2V_MASK          0x00000004
-#define RXTXBB_RXTXBB1_PDOFFSETI2V_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETI2V_MASK) >> RXTXBB_RXTXBB1_PDOFFSETI2V_LSB)
-#define RXTXBB_RXTXBB1_PDOFFSETI2V_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETI2V_LSB) & RXTXBB_RXTXBB1_PDOFFSETI2V_MASK)
-#define RXTXBB_RXTXBB1_PDLOQ_MSB                 1
-#define RXTXBB_RXTXBB1_PDLOQ_LSB                 1
-#define RXTXBB_RXTXBB1_PDLOQ_MASK                0x00000002
-#define RXTXBB_RXTXBB1_PDLOQ_GET(x)              (((x) & RXTXBB_RXTXBB1_PDLOQ_MASK) >> RXTXBB_RXTXBB1_PDLOQ_LSB)
-#define RXTXBB_RXTXBB1_PDLOQ_SET(x)              (((x) << RXTXBB_RXTXBB1_PDLOQ_LSB) & RXTXBB_RXTXBB1_PDLOQ_MASK)
-#define RXTXBB_RXTXBB1_PDHIQ_MSB                 0
-#define RXTXBB_RXTXBB1_PDHIQ_LSB                 0
-#define RXTXBB_RXTXBB1_PDHIQ_MASK                0x00000001
-#define RXTXBB_RXTXBB1_PDHIQ_GET(x)              (((x) & RXTXBB_RXTXBB1_PDHIQ_MASK) >> RXTXBB_RXTXBB1_PDHIQ_LSB)
-#define RXTXBB_RXTXBB1_PDHIQ_SET(x)              (((x) << RXTXBB_RXTXBB1_PDHIQ_LSB) & RXTXBB_RXTXBB1_PDHIQ_MASK)
-
-#define RXTXBB_RXTXBB2_ADDRESS                   0x00000054
-#define RXTXBB_RXTXBB2_OFFSET                    0x00000054
-#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MSB    31
-#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB    29
-#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK   0xe0000000
-#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB)
-#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK)
-#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MSB    28
-#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB    26
-#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK   0x1c000000
-#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB)
-#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK)
-#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MSB   25
-#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB   23
-#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK  0x03800000
-#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB)
-#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK)
-#define RXTXBB_RXTXBB2_SPARE_MSB                 22
-#define RXTXBB_RXTXBB2_SPARE_LSB                 21
-#define RXTXBB_RXTXBB2_SPARE_MASK                0x00600000
-#define RXTXBB_RXTXBB2_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB2_SPARE_MASK) >> RXTXBB_RXTXBB2_SPARE_LSB)
-#define RXTXBB_RXTXBB2_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB2_SPARE_LSB) & RXTXBB_RXTXBB2_SPARE_MASK)
-#define RXTXBB_RXTXBB2_SHORTBUFFER_MSB           20
-#define RXTXBB_RXTXBB2_SHORTBUFFER_LSB           20
-#define RXTXBB_RXTXBB2_SHORTBUFFER_MASK          0x00100000
-#define RXTXBB_RXTXBB2_SHORTBUFFER_GET(x)        (((x) & RXTXBB_RXTXBB2_SHORTBUFFER_MASK) >> RXTXBB_RXTXBB2_SHORTBUFFER_LSB)
-#define RXTXBB_RXTXBB2_SHORTBUFFER_SET(x)        (((x) << RXTXBB_RXTXBB2_SHORTBUFFER_LSB) & RXTXBB_RXTXBB2_SHORTBUFFER_MASK)
-#define RXTXBB_RXTXBB2_SELBUFFER_MSB             19
-#define RXTXBB_RXTXBB2_SELBUFFER_LSB             19
-#define RXTXBB_RXTXBB2_SELBUFFER_MASK            0x00080000
-#define RXTXBB_RXTXBB2_SELBUFFER_GET(x)          (((x) & RXTXBB_RXTXBB2_SELBUFFER_MASK) >> RXTXBB_RXTXBB2_SELBUFFER_LSB)
-#define RXTXBB_RXTXBB2_SELBUFFER_SET(x)          (((x) << RXTXBB_RXTXBB2_SELBUFFER_LSB) & RXTXBB_RXTXBB2_SELBUFFER_MASK)
-#define RXTXBB_RXTXBB2_SEL_DAC_TEST_MSB          18
-#define RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB          18
-#define RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK         0x00040000
-#define RXTXBB_RXTXBB2_SEL_DAC_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB)
-#define RXTXBB_RXTXBB2_SEL_DAC_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB) & RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK)
-#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_MSB          17
-#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB          17
-#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK         0x00020000
-#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB)
-#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB) & RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK)
-#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_MSB          16
-#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB          16
-#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK         0x00010000
-#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB)
-#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB) & RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK)
-#define RXTXBB_RXTXBB2_SEL_I2V_TEST_MSB          15
-#define RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB          15
-#define RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK         0x00008000
-#define RXTXBB_RXTXBB2_SEL_I2V_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB)
-#define RXTXBB_RXTXBB2_SEL_I2V_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB) & RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK)
-#define RXTXBB_RXTXBB2_CMSEL_MSB                 14
-#define RXTXBB_RXTXBB2_CMSEL_LSB                 13
-#define RXTXBB_RXTXBB2_CMSEL_MASK                0x00006000
-#define RXTXBB_RXTXBB2_CMSEL_GET(x)              (((x) & RXTXBB_RXTXBB2_CMSEL_MASK) >> RXTXBB_RXTXBB2_CMSEL_LSB)
-#define RXTXBB_RXTXBB2_CMSEL_SET(x)              (((x) << RXTXBB_RXTXBB2_CMSEL_LSB) & RXTXBB_RXTXBB2_CMSEL_MASK)
-#define RXTXBB_RXTXBB2_FILTERFC_MSB              12
-#define RXTXBB_RXTXBB2_FILTERFC_LSB              8
-#define RXTXBB_RXTXBB2_FILTERFC_MASK             0x00001f00
-#define RXTXBB_RXTXBB2_FILTERFC_GET(x)           (((x) & RXTXBB_RXTXBB2_FILTERFC_MASK) >> RXTXBB_RXTXBB2_FILTERFC_LSB)
-#define RXTXBB_RXTXBB2_FILTERFC_SET(x)           (((x) << RXTXBB_RXTXBB2_FILTERFC_LSB) & RXTXBB_RXTXBB2_FILTERFC_MASK)
-#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_MSB     7
-#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB     7
-#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK    0x00000080
-#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_GET(x)  (((x) & RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK) >> RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB)
-#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_SET(x)  (((x) << RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB) & RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK)
-#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_MSB        6
-#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB        6
-#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK       0x00000040
-#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_GET(x)     (((x) & RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK) >> RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB)
-#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_SET(x)     (((x) << RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB) & RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK)
-#define RXTXBB_RXTXBB2_PATH2HIQ_EN_MSB           5
-#define RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB           5
-#define RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK          0x00000020
-#define RXTXBB_RXTXBB2_PATH2HIQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB)
-#define RXTXBB_RXTXBB2_PATH2HIQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB) & RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK)
-#define RXTXBB_RXTXBB2_PATH1HIQ_EN_MSB           4
-#define RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB           4
-#define RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK          0x00000010
-#define RXTXBB_RXTXBB2_PATH1HIQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB)
-#define RXTXBB_RXTXBB2_PATH1HIQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB) & RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK)
-#define RXTXBB_RXTXBB2_PATH3LOQ_EN_MSB           3
-#define RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB           3
-#define RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK          0x00000008
-#define RXTXBB_RXTXBB2_PATH3LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB)
-#define RXTXBB_RXTXBB2_PATH3LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK)
-#define RXTXBB_RXTXBB2_PATH2LOQ_EN_MSB           2
-#define RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB           2
-#define RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK          0x00000004
-#define RXTXBB_RXTXBB2_PATH2LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB)
-#define RXTXBB_RXTXBB2_PATH2LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK)
-#define RXTXBB_RXTXBB2_PATH1LOQ_EN_MSB           1
-#define RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB           1
-#define RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK          0x00000002
-#define RXTXBB_RXTXBB2_PATH1LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB)
-#define RXTXBB_RXTXBB2_PATH1LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK)
-#define RXTXBB_RXTXBB2_PATH_OVERRIDE_MSB         0
-#define RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB         0
-#define RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK        0x00000001
-#define RXTXBB_RXTXBB2_PATH_OVERRIDE_GET(x)      (((x) & RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK) >> RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB)
-#define RXTXBB_RXTXBB2_PATH_OVERRIDE_SET(x)      (((x) << RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB) & RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK)
-
-#define RXTXBB_RXTXBB3_ADDRESS                   0x00000058
-#define RXTXBB_RXTXBB3_OFFSET                    0x00000058
-#define RXTXBB_RXTXBB3_SPARE_MSB                 31
-#define RXTXBB_RXTXBB3_SPARE_LSB                 27
-#define RXTXBB_RXTXBB3_SPARE_MASK                0xf8000000
-#define RXTXBB_RXTXBB3_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB3_SPARE_MASK) >> RXTXBB_RXTXBB3_SPARE_LSB)
-#define RXTXBB_RXTXBB3_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB3_SPARE_LSB) & RXTXBB_RXTXBB3_SPARE_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MSB 26
-#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB 24
-#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK 0x07000000
-#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MSB    23
-#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB    21
-#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK   0x00e00000
-#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MSB      20
-#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB      18
-#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK     0x001c0000
-#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MSB      17
-#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB      15
-#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK     0x00038000
-#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MSB      14
-#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB      12
-#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK     0x00007000
-#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MSB      11
-#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB      9
-#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK     0x00000e00
-#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MSB      8
-#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB      6
-#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK     0x000001c0
-#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MSB     5
-#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB     3
-#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK    0x00000038
-#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_GET(x)  (((x) & RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK) >> RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_SET(x)  (((x) << RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB) & RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK)
-#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MSB    2
-#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB    0
-#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK   0x00000007
-#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB)
-#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK)
-
-#define RXTXBB_RXTXBB4_ADDRESS                   0x0000005c
-#define RXTXBB_RXTXBB4_OFFSET                    0x0000005c
-#define RXTXBB_RXTXBB4_SPARE_MSB                 31
-#define RXTXBB_RXTXBB4_SPARE_LSB                 31
-#define RXTXBB_RXTXBB4_SPARE_MASK                0x80000000
-#define RXTXBB_RXTXBB4_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB4_SPARE_MASK) >> RXTXBB_RXTXBB4_SPARE_LSB)
-#define RXTXBB_RXTXBB4_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB4_SPARE_LSB) & RXTXBB_RXTXBB4_SPARE_MASK)
-#define RXTXBB_RXTXBB4_LOCALOFFSET_MSB           30
-#define RXTXBB_RXTXBB4_LOCALOFFSET_LSB           30
-#define RXTXBB_RXTXBB4_LOCALOFFSET_MASK          0x40000000
-#define RXTXBB_RXTXBB4_LOCALOFFSET_GET(x)        (((x) & RXTXBB_RXTXBB4_LOCALOFFSET_MASK) >> RXTXBB_RXTXBB4_LOCALOFFSET_LSB)
-#define RXTXBB_RXTXBB4_LOCALOFFSET_SET(x)        (((x) << RXTXBB_RXTXBB4_LOCALOFFSET_LSB) & RXTXBB_RXTXBB4_LOCALOFFSET_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRHII_MSB           29
-#define RXTXBB_RXTXBB4_OFSTCORRHII_LSB           25
-#define RXTXBB_RXTXBB4_OFSTCORRHII_MASK          0x3e000000
-#define RXTXBB_RXTXBB4_OFSTCORRHII_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRHII_MASK) >> RXTXBB_RXTXBB4_OFSTCORRHII_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRHII_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRHII_LSB) & RXTXBB_RXTXBB4_OFSTCORRHII_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRHIQ_MSB           24
-#define RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB           20
-#define RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK          0x01f00000
-#define RXTXBB_RXTXBB4_OFSTCORRHIQ_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRHIQ_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRLOI_MSB           19
-#define RXTXBB_RXTXBB4_OFSTCORRLOI_LSB           15
-#define RXTXBB_RXTXBB4_OFSTCORRLOI_MASK          0x000f8000
-#define RXTXBB_RXTXBB4_OFSTCORRLOI_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRLOI_MASK) >> RXTXBB_RXTXBB4_OFSTCORRLOI_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRLOI_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRLOI_LSB) & RXTXBB_RXTXBB4_OFSTCORRLOI_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRLOQ_MSB           14
-#define RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB           10
-#define RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK          0x00007c00
-#define RXTXBB_RXTXBB4_OFSTCORRLOQ_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRLOQ_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRI2VI_MSB          9
-#define RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB          5
-#define RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK         0x000003e0
-#define RXTXBB_RXTXBB4_OFSTCORRI2VI_GET(x)       (((x) & RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK) >> RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRI2VI_SET(x)       (((x) << RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB) & RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK)
-#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_MSB          4
-#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB          0
-#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK         0x0000001f
-#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_GET(x)       (((x) & RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB)
-#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_SET(x)       (((x) << RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK)
-
-#define ADDAC_ADDAC1_ADDRESS                     0x00000060
-#define ADDAC_ADDAC1_OFFSET                      0x00000060
-#define ADDAC_ADDAC1_PLL_SVREG_MSB               31
-#define ADDAC_ADDAC1_PLL_SVREG_LSB               31
-#define ADDAC_ADDAC1_PLL_SVREG_MASK              0x80000000
-#define ADDAC_ADDAC1_PLL_SVREG_GET(x)            (((x) & ADDAC_ADDAC1_PLL_SVREG_MASK) >> ADDAC_ADDAC1_PLL_SVREG_LSB)
-#define ADDAC_ADDAC1_PLL_SVREG_SET(x)            (((x) << ADDAC_ADDAC1_PLL_SVREG_LSB) & ADDAC_ADDAC1_PLL_SVREG_MASK)
-#define ADDAC_ADDAC1_PLL_SCLAMP_MSB              30
-#define ADDAC_ADDAC1_PLL_SCLAMP_LSB              28
-#define ADDAC_ADDAC1_PLL_SCLAMP_MASK             0x70000000
-#define ADDAC_ADDAC1_PLL_SCLAMP_GET(x)           (((x) & ADDAC_ADDAC1_PLL_SCLAMP_MASK) >> ADDAC_ADDAC1_PLL_SCLAMP_LSB)
-#define ADDAC_ADDAC1_PLL_SCLAMP_SET(x)           (((x) << ADDAC_ADDAC1_PLL_SCLAMP_LSB) & ADDAC_ADDAC1_PLL_SCLAMP_MASK)
-#define ADDAC_ADDAC1_PLL_ATB_MSB                 27
-#define ADDAC_ADDAC1_PLL_ATB_LSB                 26
-#define ADDAC_ADDAC1_PLL_ATB_MASK                0x0c000000
-#define ADDAC_ADDAC1_PLL_ATB_GET(x)              (((x) & ADDAC_ADDAC1_PLL_ATB_MASK) >> ADDAC_ADDAC1_PLL_ATB_LSB)
-#define ADDAC_ADDAC1_PLL_ATB_SET(x)              (((x) << ADDAC_ADDAC1_PLL_ATB_LSB) & ADDAC_ADDAC1_PLL_ATB_MASK)
-#define ADDAC_ADDAC1_PLL_ICP_MSB                 25
-#define ADDAC_ADDAC1_PLL_ICP_LSB                 23
-#define ADDAC_ADDAC1_PLL_ICP_MASK                0x03800000
-#define ADDAC_ADDAC1_PLL_ICP_GET(x)              (((x) & ADDAC_ADDAC1_PLL_ICP_MASK) >> ADDAC_ADDAC1_PLL_ICP_LSB)
-#define ADDAC_ADDAC1_PLL_ICP_SET(x)              (((x) << ADDAC_ADDAC1_PLL_ICP_LSB) & ADDAC_ADDAC1_PLL_ICP_MASK)
-#define ADDAC_ADDAC1_PLL_FILTER_MSB              22
-#define ADDAC_ADDAC1_PLL_FILTER_LSB              15
-#define ADDAC_ADDAC1_PLL_FILTER_MASK             0x007f8000
-#define ADDAC_ADDAC1_PLL_FILTER_GET(x)           (((x) & ADDAC_ADDAC1_PLL_FILTER_MASK) >> ADDAC_ADDAC1_PLL_FILTER_LSB)
-#define ADDAC_ADDAC1_PLL_FILTER_SET(x)           (((x) << ADDAC_ADDAC1_PLL_FILTER_LSB) & ADDAC_ADDAC1_PLL_FILTER_MASK)
-#define ADDAC_ADDAC1_PWDPLL_MSB                  14
-#define ADDAC_ADDAC1_PWDPLL_LSB                  14
-#define ADDAC_ADDAC1_PWDPLL_MASK                 0x00004000
-#define ADDAC_ADDAC1_PWDPLL_GET(x)               (((x) & ADDAC_ADDAC1_PWDPLL_MASK) >> ADDAC_ADDAC1_PWDPLL_LSB)
-#define ADDAC_ADDAC1_PWDPLL_SET(x)               (((x) << ADDAC_ADDAC1_PWDPLL_LSB) & ADDAC_ADDAC1_PWDPLL_MASK)
-#define ADDAC_ADDAC1_PWDADC_MSB                  13
-#define ADDAC_ADDAC1_PWDADC_LSB                  13
-#define ADDAC_ADDAC1_PWDADC_MASK                 0x00002000
-#define ADDAC_ADDAC1_PWDADC_GET(x)               (((x) & ADDAC_ADDAC1_PWDADC_MASK) >> ADDAC_ADDAC1_PWDADC_LSB)
-#define ADDAC_ADDAC1_PWDADC_SET(x)               (((x) << ADDAC_ADDAC1_PWDADC_LSB) & ADDAC_ADDAC1_PWDADC_MASK)
-#define ADDAC_ADDAC1_PWDDAC_MSB                  12
-#define ADDAC_ADDAC1_PWDDAC_LSB                  12
-#define ADDAC_ADDAC1_PWDDAC_MASK                 0x00001000
-#define ADDAC_ADDAC1_PWDDAC_GET(x)               (((x) & ADDAC_ADDAC1_PWDDAC_MASK) >> ADDAC_ADDAC1_PWDDAC_LSB)
-#define ADDAC_ADDAC1_PWDDAC_SET(x)               (((x) << ADDAC_ADDAC1_PWDDAC_LSB) & ADDAC_ADDAC1_PWDDAC_MASK)
-#define ADDAC_ADDAC1_FORCEMSBLOW_MSB             11
-#define ADDAC_ADDAC1_FORCEMSBLOW_LSB             11
-#define ADDAC_ADDAC1_FORCEMSBLOW_MASK            0x00000800
-#define ADDAC_ADDAC1_FORCEMSBLOW_GET(x)          (((x) & ADDAC_ADDAC1_FORCEMSBLOW_MASK) >> ADDAC_ADDAC1_FORCEMSBLOW_LSB)
-#define ADDAC_ADDAC1_FORCEMSBLOW_SET(x)          (((x) << ADDAC_ADDAC1_FORCEMSBLOW_LSB) & ADDAC_ADDAC1_FORCEMSBLOW_MASK)
-#define ADDAC_ADDAC1_SELMANPWDS_MSB              10
-#define ADDAC_ADDAC1_SELMANPWDS_LSB              10
-#define ADDAC_ADDAC1_SELMANPWDS_MASK             0x00000400
-#define ADDAC_ADDAC1_SELMANPWDS_GET(x)           (((x) & ADDAC_ADDAC1_SELMANPWDS_MASK) >> ADDAC_ADDAC1_SELMANPWDS_LSB)
-#define ADDAC_ADDAC1_SELMANPWDS_SET(x)           (((x) << ADDAC_ADDAC1_SELMANPWDS_LSB) & ADDAC_ADDAC1_SELMANPWDS_MASK)
-#define ADDAC_ADDAC1_INV_CLK160_ADC_MSB          9
-#define ADDAC_ADDAC1_INV_CLK160_ADC_LSB          9
-#define ADDAC_ADDAC1_INV_CLK160_ADC_MASK         0x00000200
-#define ADDAC_ADDAC1_INV_CLK160_ADC_GET(x)       (((x) & ADDAC_ADDAC1_INV_CLK160_ADC_MASK) >> ADDAC_ADDAC1_INV_CLK160_ADC_LSB)
-#define ADDAC_ADDAC1_INV_CLK160_ADC_SET(x)       (((x) << ADDAC_ADDAC1_INV_CLK160_ADC_LSB) & ADDAC_ADDAC1_INV_CLK160_ADC_MASK)
-#define ADDAC_ADDAC1_CM_SEL_MSB                  8
-#define ADDAC_ADDAC1_CM_SEL_LSB                  7
-#define ADDAC_ADDAC1_CM_SEL_MASK                 0x00000180
-#define ADDAC_ADDAC1_CM_SEL_GET(x)               (((x) & ADDAC_ADDAC1_CM_SEL_MASK) >> ADDAC_ADDAC1_CM_SEL_LSB)
-#define ADDAC_ADDAC1_CM_SEL_SET(x)               (((x) << ADDAC_ADDAC1_CM_SEL_LSB) & ADDAC_ADDAC1_CM_SEL_MASK)
-#define ADDAC_ADDAC1_DISABLE_DAC_REG_MSB         6
-#define ADDAC_ADDAC1_DISABLE_DAC_REG_LSB         6
-#define ADDAC_ADDAC1_DISABLE_DAC_REG_MASK        0x00000040
-#define ADDAC_ADDAC1_DISABLE_DAC_REG_GET(x)      (((x) & ADDAC_ADDAC1_DISABLE_DAC_REG_MASK) >> ADDAC_ADDAC1_DISABLE_DAC_REG_LSB)
-#define ADDAC_ADDAC1_DISABLE_DAC_REG_SET(x)      (((x) << ADDAC_ADDAC1_DISABLE_DAC_REG_LSB) & ADDAC_ADDAC1_DISABLE_DAC_REG_MASK)
-#define ADDAC_ADDAC1_SPARE_MSB                   5
-#define ADDAC_ADDAC1_SPARE_LSB                   0
-#define ADDAC_ADDAC1_SPARE_MASK                  0x0000003f
-#define ADDAC_ADDAC1_SPARE_GET(x)                (((x) & ADDAC_ADDAC1_SPARE_MASK) >> ADDAC_ADDAC1_SPARE_LSB)
-#define ADDAC_ADDAC1_SPARE_SET(x)                (((x) << ADDAC_ADDAC1_SPARE_LSB) & ADDAC_ADDAC1_SPARE_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct analog_reg_reg_s {
-  volatile unsigned int synth_synth1;
-  volatile unsigned int synth_synth2;
-  volatile unsigned int synth_synth3;
-  volatile unsigned int synth_synth4;
-  volatile unsigned int synth_synth5;
-  volatile unsigned int synth_synth6;
-  volatile unsigned int synth_synth7;
-  volatile unsigned int synth_synth8;
-  volatile unsigned int rf5g_rf5g1;
-  volatile unsigned int rf5g_rf5g2;
-  volatile unsigned int rf2g_rf2g1;
-  volatile unsigned int rf2g_rf2g2;
-  volatile unsigned int top_gain;
-  volatile unsigned int top_top;
-  volatile unsigned int bias_bias_sel;
-  volatile unsigned int bias_bias1;
-  volatile unsigned int bias_bias2;
-  volatile unsigned int bias_bias3;
-  volatile unsigned int txpc_txpc;
-  volatile unsigned int txpc_misc;
-  volatile unsigned int rxtxbb_rxtxbb1;
-  volatile unsigned int rxtxbb_rxtxbb2;
-  volatile unsigned int rxtxbb_rxtxbb3;
-  volatile unsigned int rxtxbb_rxtxbb4;
-  volatile unsigned int addac_addac1;
-} analog_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _ANALOG_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h
deleted file mode 100644
index f3bf6d6..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _APB_MAP_H_
-#define _APB_MAP_H_
-
-#define RTC_BASE_ADDRESS                         0x00004000
-#define VMC_BASE_ADDRESS                         0x00008000
-#define UART_BASE_ADDRESS                        0x0000c000
-#define SI_BASE_ADDRESS                          0x00010000
-#define GPIO_BASE_ADDRESS                        0x00014000
-#define MBOX_BASE_ADDRESS                        0x00018000
-#define ANALOG_INTF_BASE_ADDRESS                 0x0001c000
-#define MAC_BASE_ADDRESS                         0x00020000
-
-#endif /* _APB_MAP_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h
deleted file mode 100644
index 4f2b964..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h
+++ /dev/null
@@ -1,977 +0,0 @@
-#ifndef _GPIO_REG_REG_H_
-#define _GPIO_REG_REG_H_
-
-#define GPIO_OUT_ADDRESS                         0x00000000
-#define GPIO_OUT_OFFSET                          0x00000000
-#define GPIO_OUT_DATA_MSB                        17
-#define GPIO_OUT_DATA_LSB                        0
-#define GPIO_OUT_DATA_MASK                       0x0003ffff
-#define GPIO_OUT_DATA_GET(x)                     (((x) & GPIO_OUT_DATA_MASK) >> GPIO_OUT_DATA_LSB)
-#define GPIO_OUT_DATA_SET(x)                     (((x) << GPIO_OUT_DATA_LSB) & GPIO_OUT_DATA_MASK)
-
-#define GPIO_OUT_W1TS_ADDRESS                    0x00000004
-#define GPIO_OUT_W1TS_OFFSET                     0x00000004
-#define GPIO_OUT_W1TS_DATA_MSB                   17
-#define GPIO_OUT_W1TS_DATA_LSB                   0
-#define GPIO_OUT_W1TS_DATA_MASK                  0x0003ffff
-#define GPIO_OUT_W1TS_DATA_GET(x)                (((x) & GPIO_OUT_W1TS_DATA_MASK) >> GPIO_OUT_W1TS_DATA_LSB)
-#define GPIO_OUT_W1TS_DATA_SET(x)                (((x) << GPIO_OUT_W1TS_DATA_LSB) & GPIO_OUT_W1TS_DATA_MASK)
-
-#define GPIO_OUT_W1TC_ADDRESS                    0x00000008
-#define GPIO_OUT_W1TC_OFFSET                     0x00000008
-#define GPIO_OUT_W1TC_DATA_MSB                   17
-#define GPIO_OUT_W1TC_DATA_LSB                   0
-#define GPIO_OUT_W1TC_DATA_MASK                  0x0003ffff
-#define GPIO_OUT_W1TC_DATA_GET(x)                (((x) & GPIO_OUT_W1TC_DATA_MASK) >> GPIO_OUT_W1TC_DATA_LSB)
-#define GPIO_OUT_W1TC_DATA_SET(x)                (((x) << GPIO_OUT_W1TC_DATA_LSB) & GPIO_OUT_W1TC_DATA_MASK)
-
-#define GPIO_ENABLE_ADDRESS                      0x0000000c
-#define GPIO_ENABLE_OFFSET                       0x0000000c
-#define GPIO_ENABLE_DATA_MSB                     17
-#define GPIO_ENABLE_DATA_LSB                     0
-#define GPIO_ENABLE_DATA_MASK                    0x0003ffff
-#define GPIO_ENABLE_DATA_GET(x)                  (((x) & GPIO_ENABLE_DATA_MASK) >> GPIO_ENABLE_DATA_LSB)
-#define GPIO_ENABLE_DATA_SET(x)                  (((x) << GPIO_ENABLE_DATA_LSB) & GPIO_ENABLE_DATA_MASK)
-
-#define GPIO_ENABLE_W1TS_ADDRESS                 0x00000010
-#define GPIO_ENABLE_W1TS_OFFSET                  0x00000010
-#define GPIO_ENABLE_W1TS_DATA_MSB                17
-#define GPIO_ENABLE_W1TS_DATA_LSB                0
-#define GPIO_ENABLE_W1TS_DATA_MASK               0x0003ffff
-#define GPIO_ENABLE_W1TS_DATA_GET(x)             (((x) & GPIO_ENABLE_W1TS_DATA_MASK) >> GPIO_ENABLE_W1TS_DATA_LSB)
-#define GPIO_ENABLE_W1TS_DATA_SET(x)             (((x) << GPIO_ENABLE_W1TS_DATA_LSB) & GPIO_ENABLE_W1TS_DATA_MASK)
-
-#define GPIO_ENABLE_W1TC_ADDRESS                 0x00000014
-#define GPIO_ENABLE_W1TC_OFFSET                  0x00000014
-#define GPIO_ENABLE_W1TC_DATA_MSB                17
-#define GPIO_ENABLE_W1TC_DATA_LSB                0
-#define GPIO_ENABLE_W1TC_DATA_MASK               0x0003ffff
-#define GPIO_ENABLE_W1TC_DATA_GET(x)             (((x) & GPIO_ENABLE_W1TC_DATA_MASK) >> GPIO_ENABLE_W1TC_DATA_LSB)
-#define GPIO_ENABLE_W1TC_DATA_SET(x)             (((x) << GPIO_ENABLE_W1TC_DATA_LSB) & GPIO_ENABLE_W1TC_DATA_MASK)
-
-#define GPIO_IN_ADDRESS                          0x00000018
-#define GPIO_IN_OFFSET                           0x00000018
-#define GPIO_IN_DATA_MSB                         17
-#define GPIO_IN_DATA_LSB                         0
-#define GPIO_IN_DATA_MASK                        0x0003ffff
-#define GPIO_IN_DATA_GET(x)                      (((x) & GPIO_IN_DATA_MASK) >> GPIO_IN_DATA_LSB)
-#define GPIO_IN_DATA_SET(x)                      (((x) << GPIO_IN_DATA_LSB) & GPIO_IN_DATA_MASK)
-
-#define GPIO_STATUS_ADDRESS                      0x0000001c
-#define GPIO_STATUS_OFFSET                       0x0000001c
-#define GPIO_STATUS_INTERRUPT_MSB                17
-#define GPIO_STATUS_INTERRUPT_LSB                0
-#define GPIO_STATUS_INTERRUPT_MASK               0x0003ffff
-#define GPIO_STATUS_INTERRUPT_GET(x)             (((x) & GPIO_STATUS_INTERRUPT_MASK) >> GPIO_STATUS_INTERRUPT_LSB)
-#define GPIO_STATUS_INTERRUPT_SET(x)             (((x) << GPIO_STATUS_INTERRUPT_LSB) & GPIO_STATUS_INTERRUPT_MASK)
-
-#define GPIO_STATUS_W1TS_ADDRESS                 0x00000020
-#define GPIO_STATUS_W1TS_OFFSET                  0x00000020
-#define GPIO_STATUS_W1TS_INTERRUPT_MSB           17
-#define GPIO_STATUS_W1TS_INTERRUPT_LSB           0
-#define GPIO_STATUS_W1TS_INTERRUPT_MASK          0x0003ffff
-#define GPIO_STATUS_W1TS_INTERRUPT_GET(x)        (((x) & GPIO_STATUS_W1TS_INTERRUPT_MASK) >> GPIO_STATUS_W1TS_INTERRUPT_LSB)
-#define GPIO_STATUS_W1TS_INTERRUPT_SET(x)        (((x) << GPIO_STATUS_W1TS_INTERRUPT_LSB) & GPIO_STATUS_W1TS_INTERRUPT_MASK)
-
-#define GPIO_STATUS_W1TC_ADDRESS                 0x00000024
-#define GPIO_STATUS_W1TC_OFFSET                  0x00000024
-#define GPIO_STATUS_W1TC_INTERRUPT_MSB           17
-#define GPIO_STATUS_W1TC_INTERRUPT_LSB           0
-#define GPIO_STATUS_W1TC_INTERRUPT_MASK          0x0003ffff
-#define GPIO_STATUS_W1TC_INTERRUPT_GET(x)        (((x) & GPIO_STATUS_W1TC_INTERRUPT_MASK) >> GPIO_STATUS_W1TC_INTERRUPT_LSB)
-#define GPIO_STATUS_W1TC_INTERRUPT_SET(x)        (((x) << GPIO_STATUS_W1TC_INTERRUPT_LSB) & GPIO_STATUS_W1TC_INTERRUPT_MASK)
-
-#define GPIO_PIN0_ADDRESS                        0x00000028
-#define GPIO_PIN0_OFFSET                         0x00000028
-#define GPIO_PIN0_CONFIG_MSB                     12
-#define GPIO_PIN0_CONFIG_LSB                     11
-#define GPIO_PIN0_CONFIG_MASK                    0x00001800
-#define GPIO_PIN0_CONFIG_GET(x)                  (((x) & GPIO_PIN0_CONFIG_MASK) >> GPIO_PIN0_CONFIG_LSB)
-#define GPIO_PIN0_CONFIG_SET(x)                  (((x) << GPIO_PIN0_CONFIG_LSB) & GPIO_PIN0_CONFIG_MASK)
-#define GPIO_PIN0_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN0_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN0_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN0_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN0_WAKEUP_ENABLE_MASK) >> GPIO_PIN0_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN0_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN0_WAKEUP_ENABLE_LSB) & GPIO_PIN0_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN0_INT_TYPE_MSB                   9
-#define GPIO_PIN0_INT_TYPE_LSB                   7
-#define GPIO_PIN0_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN0_INT_TYPE_GET(x)                (((x) & GPIO_PIN0_INT_TYPE_MASK) >> GPIO_PIN0_INT_TYPE_LSB)
-#define GPIO_PIN0_INT_TYPE_SET(x)                (((x) << GPIO_PIN0_INT_TYPE_LSB) & GPIO_PIN0_INT_TYPE_MASK)
-#define GPIO_PIN0_PAD_DRIVER_MSB                 2
-#define GPIO_PIN0_PAD_DRIVER_LSB                 2
-#define GPIO_PIN0_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN0_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN0_PAD_DRIVER_MASK) >> GPIO_PIN0_PAD_DRIVER_LSB)
-#define GPIO_PIN0_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN0_PAD_DRIVER_LSB) & GPIO_PIN0_PAD_DRIVER_MASK)
-#define GPIO_PIN0_SOURCE_MSB                     0
-#define GPIO_PIN0_SOURCE_LSB                     0
-#define GPIO_PIN0_SOURCE_MASK                    0x00000001
-#define GPIO_PIN0_SOURCE_GET(x)                  (((x) & GPIO_PIN0_SOURCE_MASK) >> GPIO_PIN0_SOURCE_LSB)
-#define GPIO_PIN0_SOURCE_SET(x)                  (((x) << GPIO_PIN0_SOURCE_LSB) & GPIO_PIN0_SOURCE_MASK)
-
-#define GPIO_PIN1_ADDRESS                        0x0000002c
-#define GPIO_PIN1_OFFSET                         0x0000002c
-#define GPIO_PIN1_CONFIG_MSB                     12
-#define GPIO_PIN1_CONFIG_LSB                     11
-#define GPIO_PIN1_CONFIG_MASK                    0x00001800
-#define GPIO_PIN1_CONFIG_GET(x)                  (((x) & GPIO_PIN1_CONFIG_MASK) >> GPIO_PIN1_CONFIG_LSB)
-#define GPIO_PIN1_CONFIG_SET(x)                  (((x) << GPIO_PIN1_CONFIG_LSB) & GPIO_PIN1_CONFIG_MASK)
-#define GPIO_PIN1_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN1_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN1_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN1_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN1_WAKEUP_ENABLE_MASK) >> GPIO_PIN1_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN1_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN1_WAKEUP_ENABLE_LSB) & GPIO_PIN1_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN1_INT_TYPE_MSB                   9
-#define GPIO_PIN1_INT_TYPE_LSB                   7
-#define GPIO_PIN1_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN1_INT_TYPE_GET(x)                (((x) & GPIO_PIN1_INT_TYPE_MASK) >> GPIO_PIN1_INT_TYPE_LSB)
-#define GPIO_PIN1_INT_TYPE_SET(x)                (((x) << GPIO_PIN1_INT_TYPE_LSB) & GPIO_PIN1_INT_TYPE_MASK)
-#define GPIO_PIN1_PAD_DRIVER_MSB                 2
-#define GPIO_PIN1_PAD_DRIVER_LSB                 2
-#define GPIO_PIN1_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN1_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN1_PAD_DRIVER_MASK) >> GPIO_PIN1_PAD_DRIVER_LSB)
-#define GPIO_PIN1_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN1_PAD_DRIVER_LSB) & GPIO_PIN1_PAD_DRIVER_MASK)
-#define GPIO_PIN1_SOURCE_MSB                     0
-#define GPIO_PIN1_SOURCE_LSB                     0
-#define GPIO_PIN1_SOURCE_MASK                    0x00000001
-#define GPIO_PIN1_SOURCE_GET(x)                  (((x) & GPIO_PIN1_SOURCE_MASK) >> GPIO_PIN1_SOURCE_LSB)
-#define GPIO_PIN1_SOURCE_SET(x)                  (((x) << GPIO_PIN1_SOURCE_LSB) & GPIO_PIN1_SOURCE_MASK)
-
-#define GPIO_PIN2_ADDRESS                        0x00000030
-#define GPIO_PIN2_OFFSET                         0x00000030
-#define GPIO_PIN2_CONFIG_MSB                     12
-#define GPIO_PIN2_CONFIG_LSB                     11
-#define GPIO_PIN2_CONFIG_MASK                    0x00001800
-#define GPIO_PIN2_CONFIG_GET(x)                  (((x) & GPIO_PIN2_CONFIG_MASK) >> GPIO_PIN2_CONFIG_LSB)
-#define GPIO_PIN2_CONFIG_SET(x)                  (((x) << GPIO_PIN2_CONFIG_LSB) & GPIO_PIN2_CONFIG_MASK)
-#define GPIO_PIN2_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN2_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN2_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN2_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN2_WAKEUP_ENABLE_MASK) >> GPIO_PIN2_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN2_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN2_WAKEUP_ENABLE_LSB) & GPIO_PIN2_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN2_INT_TYPE_MSB                   9
-#define GPIO_PIN2_INT_TYPE_LSB                   7
-#define GPIO_PIN2_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN2_INT_TYPE_GET(x)                (((x) & GPIO_PIN2_INT_TYPE_MASK) >> GPIO_PIN2_INT_TYPE_LSB)
-#define GPIO_PIN2_INT_TYPE_SET(x)                (((x) << GPIO_PIN2_INT_TYPE_LSB) & GPIO_PIN2_INT_TYPE_MASK)
-#define GPIO_PIN2_PAD_DRIVER_MSB                 2
-#define GPIO_PIN2_PAD_DRIVER_LSB                 2
-#define GPIO_PIN2_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN2_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN2_PAD_DRIVER_MASK) >> GPIO_PIN2_PAD_DRIVER_LSB)
-#define GPIO_PIN2_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN2_PAD_DRIVER_LSB) & GPIO_PIN2_PAD_DRIVER_MASK)
-#define GPIO_PIN2_SOURCE_MSB                     0
-#define GPIO_PIN2_SOURCE_LSB                     0
-#define GPIO_PIN2_SOURCE_MASK                    0x00000001
-#define GPIO_PIN2_SOURCE_GET(x)                  (((x) & GPIO_PIN2_SOURCE_MASK) >> GPIO_PIN2_SOURCE_LSB)
-#define GPIO_PIN2_SOURCE_SET(x)                  (((x) << GPIO_PIN2_SOURCE_LSB) & GPIO_PIN2_SOURCE_MASK)
-
-#define GPIO_PIN3_ADDRESS                        0x00000034
-#define GPIO_PIN3_OFFSET                         0x00000034
-#define GPIO_PIN3_CONFIG_MSB                     12
-#define GPIO_PIN3_CONFIG_LSB                     11
-#define GPIO_PIN3_CONFIG_MASK                    0x00001800
-#define GPIO_PIN3_CONFIG_GET(x)                  (((x) & GPIO_PIN3_CONFIG_MASK) >> GPIO_PIN3_CONFIG_LSB)
-#define GPIO_PIN3_CONFIG_SET(x)                  (((x) << GPIO_PIN3_CONFIG_LSB) & GPIO_PIN3_CONFIG_MASK)
-#define GPIO_PIN3_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN3_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN3_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN3_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN3_WAKEUP_ENABLE_MASK) >> GPIO_PIN3_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN3_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN3_WAKEUP_ENABLE_LSB) & GPIO_PIN3_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN3_INT_TYPE_MSB                   9
-#define GPIO_PIN3_INT_TYPE_LSB                   7
-#define GPIO_PIN3_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN3_INT_TYPE_GET(x)                (((x) & GPIO_PIN3_INT_TYPE_MASK) >> GPIO_PIN3_INT_TYPE_LSB)
-#define GPIO_PIN3_INT_TYPE_SET(x)                (((x) << GPIO_PIN3_INT_TYPE_LSB) & GPIO_PIN3_INT_TYPE_MASK)
-#define GPIO_PIN3_PAD_DRIVER_MSB                 2
-#define GPIO_PIN3_PAD_DRIVER_LSB                 2
-#define GPIO_PIN3_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN3_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN3_PAD_DRIVER_MASK) >> GPIO_PIN3_PAD_DRIVER_LSB)
-#define GPIO_PIN3_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN3_PAD_DRIVER_LSB) & GPIO_PIN3_PAD_DRIVER_MASK)
-#define GPIO_PIN3_SOURCE_MSB                     0
-#define GPIO_PIN3_SOURCE_LSB                     0
-#define GPIO_PIN3_SOURCE_MASK                    0x00000001
-#define GPIO_PIN3_SOURCE_GET(x)                  (((x) & GPIO_PIN3_SOURCE_MASK) >> GPIO_PIN3_SOURCE_LSB)
-#define GPIO_PIN3_SOURCE_SET(x)                  (((x) << GPIO_PIN3_SOURCE_LSB) & GPIO_PIN3_SOURCE_MASK)
-
-#define GPIO_PIN4_ADDRESS                        0x00000038
-#define GPIO_PIN4_OFFSET                         0x00000038
-#define GPIO_PIN4_CONFIG_MSB                     12
-#define GPIO_PIN4_CONFIG_LSB                     11
-#define GPIO_PIN4_CONFIG_MASK                    0x00001800
-#define GPIO_PIN4_CONFIG_GET(x)                  (((x) & GPIO_PIN4_CONFIG_MASK) >> GPIO_PIN4_CONFIG_LSB)
-#define GPIO_PIN4_CONFIG_SET(x)                  (((x) << GPIO_PIN4_CONFIG_LSB) & GPIO_PIN4_CONFIG_MASK)
-#define GPIO_PIN4_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN4_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN4_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN4_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN4_WAKEUP_ENABLE_MASK) >> GPIO_PIN4_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN4_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN4_WAKEUP_ENABLE_LSB) & GPIO_PIN4_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN4_INT_TYPE_MSB                   9
-#define GPIO_PIN4_INT_TYPE_LSB                   7
-#define GPIO_PIN4_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN4_INT_TYPE_GET(x)                (((x) & GPIO_PIN4_INT_TYPE_MASK) >> GPIO_PIN4_INT_TYPE_LSB)
-#define GPIO_PIN4_INT_TYPE_SET(x)                (((x) << GPIO_PIN4_INT_TYPE_LSB) & GPIO_PIN4_INT_TYPE_MASK)
-#define GPIO_PIN4_PAD_DRIVER_MSB                 2
-#define GPIO_PIN4_PAD_DRIVER_LSB                 2
-#define GPIO_PIN4_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN4_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN4_PAD_DRIVER_MASK) >> GPIO_PIN4_PAD_DRIVER_LSB)
-#define GPIO_PIN4_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN4_PAD_DRIVER_LSB) & GPIO_PIN4_PAD_DRIVER_MASK)
-#define GPIO_PIN4_SOURCE_MSB                     0
-#define GPIO_PIN4_SOURCE_LSB                     0
-#define GPIO_PIN4_SOURCE_MASK                    0x00000001
-#define GPIO_PIN4_SOURCE_GET(x)                  (((x) & GPIO_PIN4_SOURCE_MASK) >> GPIO_PIN4_SOURCE_LSB)
-#define GPIO_PIN4_SOURCE_SET(x)                  (((x) << GPIO_PIN4_SOURCE_LSB) & GPIO_PIN4_SOURCE_MASK)
-
-#define GPIO_PIN5_ADDRESS                        0x0000003c
-#define GPIO_PIN5_OFFSET                         0x0000003c
-#define GPIO_PIN5_CONFIG_MSB                     12
-#define GPIO_PIN5_CONFIG_LSB                     11
-#define GPIO_PIN5_CONFIG_MASK                    0x00001800
-#define GPIO_PIN5_CONFIG_GET(x)                  (((x) & GPIO_PIN5_CONFIG_MASK) >> GPIO_PIN5_CONFIG_LSB)
-#define GPIO_PIN5_CONFIG_SET(x)                  (((x) << GPIO_PIN5_CONFIG_LSB) & GPIO_PIN5_CONFIG_MASK)
-#define GPIO_PIN5_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN5_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN5_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN5_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN5_WAKEUP_ENABLE_MASK) >> GPIO_PIN5_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN5_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN5_WAKEUP_ENABLE_LSB) & GPIO_PIN5_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN5_INT_TYPE_MSB                   9
-#define GPIO_PIN5_INT_TYPE_LSB                   7
-#define GPIO_PIN5_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN5_INT_TYPE_GET(x)                (((x) & GPIO_PIN5_INT_TYPE_MASK) >> GPIO_PIN5_INT_TYPE_LSB)
-#define GPIO_PIN5_INT_TYPE_SET(x)                (((x) << GPIO_PIN5_INT_TYPE_LSB) & GPIO_PIN5_INT_TYPE_MASK)
-#define GPIO_PIN5_PAD_DRIVER_MSB                 2
-#define GPIO_PIN5_PAD_DRIVER_LSB                 2
-#define GPIO_PIN5_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN5_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN5_PAD_DRIVER_MASK) >> GPIO_PIN5_PAD_DRIVER_LSB)
-#define GPIO_PIN5_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN5_PAD_DRIVER_LSB) & GPIO_PIN5_PAD_DRIVER_MASK)
-#define GPIO_PIN5_SOURCE_MSB                     0
-#define GPIO_PIN5_SOURCE_LSB                     0
-#define GPIO_PIN5_SOURCE_MASK                    0x00000001
-#define GPIO_PIN5_SOURCE_GET(x)                  (((x) & GPIO_PIN5_SOURCE_MASK) >> GPIO_PIN5_SOURCE_LSB)
-#define GPIO_PIN5_SOURCE_SET(x)                  (((x) << GPIO_PIN5_SOURCE_LSB) & GPIO_PIN5_SOURCE_MASK)
-
-#define GPIO_PIN6_ADDRESS                        0x00000040
-#define GPIO_PIN6_OFFSET                         0x00000040
-#define GPIO_PIN6_CONFIG_MSB                     12
-#define GPIO_PIN6_CONFIG_LSB                     11
-#define GPIO_PIN6_CONFIG_MASK                    0x00001800
-#define GPIO_PIN6_CONFIG_GET(x)                  (((x) & GPIO_PIN6_CONFIG_MASK) >> GPIO_PIN6_CONFIG_LSB)
-#define GPIO_PIN6_CONFIG_SET(x)                  (((x) << GPIO_PIN6_CONFIG_LSB) & GPIO_PIN6_CONFIG_MASK)
-#define GPIO_PIN6_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN6_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN6_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN6_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN6_WAKEUP_ENABLE_MASK) >> GPIO_PIN6_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN6_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN6_WAKEUP_ENABLE_LSB) & GPIO_PIN6_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN6_INT_TYPE_MSB                   9
-#define GPIO_PIN6_INT_TYPE_LSB                   7
-#define GPIO_PIN6_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN6_INT_TYPE_GET(x)                (((x) & GPIO_PIN6_INT_TYPE_MASK) >> GPIO_PIN6_INT_TYPE_LSB)
-#define GPIO_PIN6_INT_TYPE_SET(x)                (((x) << GPIO_PIN6_INT_TYPE_LSB) & GPIO_PIN6_INT_TYPE_MASK)
-#define GPIO_PIN6_PAD_DRIVER_MSB                 2
-#define GPIO_PIN6_PAD_DRIVER_LSB                 2
-#define GPIO_PIN6_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN6_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN6_PAD_DRIVER_MASK) >> GPIO_PIN6_PAD_DRIVER_LSB)
-#define GPIO_PIN6_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN6_PAD_DRIVER_LSB) & GPIO_PIN6_PAD_DRIVER_MASK)
-#define GPIO_PIN6_SOURCE_MSB                     0
-#define GPIO_PIN6_SOURCE_LSB                     0
-#define GPIO_PIN6_SOURCE_MASK                    0x00000001
-#define GPIO_PIN6_SOURCE_GET(x)                  (((x) & GPIO_PIN6_SOURCE_MASK) >> GPIO_PIN6_SOURCE_LSB)
-#define GPIO_PIN6_SOURCE_SET(x)                  (((x) << GPIO_PIN6_SOURCE_LSB) & GPIO_PIN6_SOURCE_MASK)
-
-#define GPIO_PIN7_ADDRESS                        0x00000044
-#define GPIO_PIN7_OFFSET                         0x00000044
-#define GPIO_PIN7_CONFIG_MSB                     12
-#define GPIO_PIN7_CONFIG_LSB                     11
-#define GPIO_PIN7_CONFIG_MASK                    0x00001800
-#define GPIO_PIN7_CONFIG_GET(x)                  (((x) & GPIO_PIN7_CONFIG_MASK) >> GPIO_PIN7_CONFIG_LSB)
-#define GPIO_PIN7_CONFIG_SET(x)                  (((x) << GPIO_PIN7_CONFIG_LSB) & GPIO_PIN7_CONFIG_MASK)
-#define GPIO_PIN7_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN7_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN7_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN7_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN7_WAKEUP_ENABLE_MASK) >> GPIO_PIN7_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN7_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN7_WAKEUP_ENABLE_LSB) & GPIO_PIN7_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN7_INT_TYPE_MSB                   9
-#define GPIO_PIN7_INT_TYPE_LSB                   7
-#define GPIO_PIN7_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN7_INT_TYPE_GET(x)                (((x) & GPIO_PIN7_INT_TYPE_MASK) >> GPIO_PIN7_INT_TYPE_LSB)
-#define GPIO_PIN7_INT_TYPE_SET(x)                (((x) << GPIO_PIN7_INT_TYPE_LSB) & GPIO_PIN7_INT_TYPE_MASK)
-#define GPIO_PIN7_PAD_DRIVER_MSB                 2
-#define GPIO_PIN7_PAD_DRIVER_LSB                 2
-#define GPIO_PIN7_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN7_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN7_PAD_DRIVER_MASK) >> GPIO_PIN7_PAD_DRIVER_LSB)
-#define GPIO_PIN7_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN7_PAD_DRIVER_LSB) & GPIO_PIN7_PAD_DRIVER_MASK)
-#define GPIO_PIN7_SOURCE_MSB                     0
-#define GPIO_PIN7_SOURCE_LSB                     0
-#define GPIO_PIN7_SOURCE_MASK                    0x00000001
-#define GPIO_PIN7_SOURCE_GET(x)                  (((x) & GPIO_PIN7_SOURCE_MASK) >> GPIO_PIN7_SOURCE_LSB)
-#define GPIO_PIN7_SOURCE_SET(x)                  (((x) << GPIO_PIN7_SOURCE_LSB) & GPIO_PIN7_SOURCE_MASK)
-
-#define GPIO_PIN8_ADDRESS                        0x00000048
-#define GPIO_PIN8_OFFSET                         0x00000048
-#define GPIO_PIN8_CONFIG_MSB                     12
-#define GPIO_PIN8_CONFIG_LSB                     11
-#define GPIO_PIN8_CONFIG_MASK                    0x00001800
-#define GPIO_PIN8_CONFIG_GET(x)                  (((x) & GPIO_PIN8_CONFIG_MASK) >> GPIO_PIN8_CONFIG_LSB)
-#define GPIO_PIN8_CONFIG_SET(x)                  (((x) << GPIO_PIN8_CONFIG_LSB) & GPIO_PIN8_CONFIG_MASK)
-#define GPIO_PIN8_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN8_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN8_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN8_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN8_WAKEUP_ENABLE_MASK) >> GPIO_PIN8_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN8_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN8_WAKEUP_ENABLE_LSB) & GPIO_PIN8_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN8_INT_TYPE_MSB                   9
-#define GPIO_PIN8_INT_TYPE_LSB                   7
-#define GPIO_PIN8_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN8_INT_TYPE_GET(x)                (((x) & GPIO_PIN8_INT_TYPE_MASK) >> GPIO_PIN8_INT_TYPE_LSB)
-#define GPIO_PIN8_INT_TYPE_SET(x)                (((x) << GPIO_PIN8_INT_TYPE_LSB) & GPIO_PIN8_INT_TYPE_MASK)
-#define GPIO_PIN8_PAD_DRIVER_MSB                 2
-#define GPIO_PIN8_PAD_DRIVER_LSB                 2
-#define GPIO_PIN8_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN8_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN8_PAD_DRIVER_MASK) >> GPIO_PIN8_PAD_DRIVER_LSB)
-#define GPIO_PIN8_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN8_PAD_DRIVER_LSB) & GPIO_PIN8_PAD_DRIVER_MASK)
-#define GPIO_PIN8_SOURCE_MSB                     0
-#define GPIO_PIN8_SOURCE_LSB                     0
-#define GPIO_PIN8_SOURCE_MASK                    0x00000001
-#define GPIO_PIN8_SOURCE_GET(x)                  (((x) & GPIO_PIN8_SOURCE_MASK) >> GPIO_PIN8_SOURCE_LSB)
-#define GPIO_PIN8_SOURCE_SET(x)                  (((x) << GPIO_PIN8_SOURCE_LSB) & GPIO_PIN8_SOURCE_MASK)
-
-#define GPIO_PIN9_ADDRESS                        0x0000004c
-#define GPIO_PIN9_OFFSET                         0x0000004c
-#define GPIO_PIN9_CONFIG_MSB                     12
-#define GPIO_PIN9_CONFIG_LSB                     11
-#define GPIO_PIN9_CONFIG_MASK                    0x00001800
-#define GPIO_PIN9_CONFIG_GET(x)                  (((x) & GPIO_PIN9_CONFIG_MASK) >> GPIO_PIN9_CONFIG_LSB)
-#define GPIO_PIN9_CONFIG_SET(x)                  (((x) << GPIO_PIN9_CONFIG_LSB) & GPIO_PIN9_CONFIG_MASK)
-#define GPIO_PIN9_WAKEUP_ENABLE_MSB              10
-#define GPIO_PIN9_WAKEUP_ENABLE_LSB              10
-#define GPIO_PIN9_WAKEUP_ENABLE_MASK             0x00000400
-#define GPIO_PIN9_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN9_WAKEUP_ENABLE_MASK) >> GPIO_PIN9_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN9_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN9_WAKEUP_ENABLE_LSB) & GPIO_PIN9_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN9_INT_TYPE_MSB                   9
-#define GPIO_PIN9_INT_TYPE_LSB                   7
-#define GPIO_PIN9_INT_TYPE_MASK                  0x00000380
-#define GPIO_PIN9_INT_TYPE_GET(x)                (((x) & GPIO_PIN9_INT_TYPE_MASK) >> GPIO_PIN9_INT_TYPE_LSB)
-#define GPIO_PIN9_INT_TYPE_SET(x)                (((x) << GPIO_PIN9_INT_TYPE_LSB) & GPIO_PIN9_INT_TYPE_MASK)
-#define GPIO_PIN9_PAD_DRIVER_MSB                 2
-#define GPIO_PIN9_PAD_DRIVER_LSB                 2
-#define GPIO_PIN9_PAD_DRIVER_MASK                0x00000004
-#define GPIO_PIN9_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN9_PAD_DRIVER_MASK) >> GPIO_PIN9_PAD_DRIVER_LSB)
-#define GPIO_PIN9_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN9_PAD_DRIVER_LSB) & GPIO_PIN9_PAD_DRIVER_MASK)
-#define GPIO_PIN9_SOURCE_MSB                     0
-#define GPIO_PIN9_SOURCE_LSB                     0
-#define GPIO_PIN9_SOURCE_MASK                    0x00000001
-#define GPIO_PIN9_SOURCE_GET(x)                  (((x) & GPIO_PIN9_SOURCE_MASK) >> GPIO_PIN9_SOURCE_LSB)
-#define GPIO_PIN9_SOURCE_SET(x)                  (((x) << GPIO_PIN9_SOURCE_LSB) & GPIO_PIN9_SOURCE_MASK)
-
-#define GPIO_PIN10_ADDRESS                       0x00000050
-#define GPIO_PIN10_OFFSET                        0x00000050
-#define GPIO_PIN10_CONFIG_MSB                    12
-#define GPIO_PIN10_CONFIG_LSB                    11
-#define GPIO_PIN10_CONFIG_MASK                   0x00001800
-#define GPIO_PIN10_CONFIG_GET(x)                 (((x) & GPIO_PIN10_CONFIG_MASK) >> GPIO_PIN10_CONFIG_LSB)
-#define GPIO_PIN10_CONFIG_SET(x)                 (((x) << GPIO_PIN10_CONFIG_LSB) & GPIO_PIN10_CONFIG_MASK)
-#define GPIO_PIN10_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN10_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN10_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN10_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN10_WAKEUP_ENABLE_MASK) >> GPIO_PIN10_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN10_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN10_WAKEUP_ENABLE_LSB) & GPIO_PIN10_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN10_INT_TYPE_MSB                  9
-#define GPIO_PIN10_INT_TYPE_LSB                  7
-#define GPIO_PIN10_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN10_INT_TYPE_GET(x)               (((x) & GPIO_PIN10_INT_TYPE_MASK) >> GPIO_PIN10_INT_TYPE_LSB)
-#define GPIO_PIN10_INT_TYPE_SET(x)               (((x) << GPIO_PIN10_INT_TYPE_LSB) & GPIO_PIN10_INT_TYPE_MASK)
-#define GPIO_PIN10_PAD_DRIVER_MSB                2
-#define GPIO_PIN10_PAD_DRIVER_LSB                2
-#define GPIO_PIN10_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN10_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN10_PAD_DRIVER_MASK) >> GPIO_PIN10_PAD_DRIVER_LSB)
-#define GPIO_PIN10_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN10_PAD_DRIVER_LSB) & GPIO_PIN10_PAD_DRIVER_MASK)
-#define GPIO_PIN10_SOURCE_MSB                    0
-#define GPIO_PIN10_SOURCE_LSB                    0
-#define GPIO_PIN10_SOURCE_MASK                   0x00000001
-#define GPIO_PIN10_SOURCE_GET(x)                 (((x) & GPIO_PIN10_SOURCE_MASK) >> GPIO_PIN10_SOURCE_LSB)
-#define GPIO_PIN10_SOURCE_SET(x)                 (((x) << GPIO_PIN10_SOURCE_LSB) & GPIO_PIN10_SOURCE_MASK)
-
-#define GPIO_PIN11_ADDRESS                       0x00000054
-#define GPIO_PIN11_OFFSET                        0x00000054
-#define GPIO_PIN11_CONFIG_MSB                    12
-#define GPIO_PIN11_CONFIG_LSB                    11
-#define GPIO_PIN11_CONFIG_MASK                   0x00001800
-#define GPIO_PIN11_CONFIG_GET(x)                 (((x) & GPIO_PIN11_CONFIG_MASK) >> GPIO_PIN11_CONFIG_LSB)
-#define GPIO_PIN11_CONFIG_SET(x)                 (((x) << GPIO_PIN11_CONFIG_LSB) & GPIO_PIN11_CONFIG_MASK)
-#define GPIO_PIN11_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN11_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN11_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN11_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN11_WAKEUP_ENABLE_MASK) >> GPIO_PIN11_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN11_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN11_WAKEUP_ENABLE_LSB) & GPIO_PIN11_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN11_INT_TYPE_MSB                  9
-#define GPIO_PIN11_INT_TYPE_LSB                  7
-#define GPIO_PIN11_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN11_INT_TYPE_GET(x)               (((x) & GPIO_PIN11_INT_TYPE_MASK) >> GPIO_PIN11_INT_TYPE_LSB)
-#define GPIO_PIN11_INT_TYPE_SET(x)               (((x) << GPIO_PIN11_INT_TYPE_LSB) & GPIO_PIN11_INT_TYPE_MASK)
-#define GPIO_PIN11_PAD_DRIVER_MSB                2
-#define GPIO_PIN11_PAD_DRIVER_LSB                2
-#define GPIO_PIN11_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN11_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN11_PAD_DRIVER_MASK) >> GPIO_PIN11_PAD_DRIVER_LSB)
-#define GPIO_PIN11_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN11_PAD_DRIVER_LSB) & GPIO_PIN11_PAD_DRIVER_MASK)
-#define GPIO_PIN11_SOURCE_MSB                    0
-#define GPIO_PIN11_SOURCE_LSB                    0
-#define GPIO_PIN11_SOURCE_MASK                   0x00000001
-#define GPIO_PIN11_SOURCE_GET(x)                 (((x) & GPIO_PIN11_SOURCE_MASK) >> GPIO_PIN11_SOURCE_LSB)
-#define GPIO_PIN11_SOURCE_SET(x)                 (((x) << GPIO_PIN11_SOURCE_LSB) & GPIO_PIN11_SOURCE_MASK)
-
-#define GPIO_PIN12_ADDRESS                       0x00000058
-#define GPIO_PIN12_OFFSET                        0x00000058
-#define GPIO_PIN12_CONFIG_MSB                    12
-#define GPIO_PIN12_CONFIG_LSB                    11
-#define GPIO_PIN12_CONFIG_MASK                   0x00001800
-#define GPIO_PIN12_CONFIG_GET(x)                 (((x) & GPIO_PIN12_CONFIG_MASK) >> GPIO_PIN12_CONFIG_LSB)
-#define GPIO_PIN12_CONFIG_SET(x)                 (((x) << GPIO_PIN12_CONFIG_LSB) & GPIO_PIN12_CONFIG_MASK)
-#define GPIO_PIN12_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN12_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN12_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN12_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN12_WAKEUP_ENABLE_MASK) >> GPIO_PIN12_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN12_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN12_WAKEUP_ENABLE_LSB) & GPIO_PIN12_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN12_INT_TYPE_MSB                  9
-#define GPIO_PIN12_INT_TYPE_LSB                  7
-#define GPIO_PIN12_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN12_INT_TYPE_GET(x)               (((x) & GPIO_PIN12_INT_TYPE_MASK) >> GPIO_PIN12_INT_TYPE_LSB)
-#define GPIO_PIN12_INT_TYPE_SET(x)               (((x) << GPIO_PIN12_INT_TYPE_LSB) & GPIO_PIN12_INT_TYPE_MASK)
-#define GPIO_PIN12_PAD_DRIVER_MSB                2
-#define GPIO_PIN12_PAD_DRIVER_LSB                2
-#define GPIO_PIN12_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN12_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN12_PAD_DRIVER_MASK) >> GPIO_PIN12_PAD_DRIVER_LSB)
-#define GPIO_PIN12_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN12_PAD_DRIVER_LSB) & GPIO_PIN12_PAD_DRIVER_MASK)
-#define GPIO_PIN12_SOURCE_MSB                    0
-#define GPIO_PIN12_SOURCE_LSB                    0
-#define GPIO_PIN12_SOURCE_MASK                   0x00000001
-#define GPIO_PIN12_SOURCE_GET(x)                 (((x) & GPIO_PIN12_SOURCE_MASK) >> GPIO_PIN12_SOURCE_LSB)
-#define GPIO_PIN12_SOURCE_SET(x)                 (((x) << GPIO_PIN12_SOURCE_LSB) & GPIO_PIN12_SOURCE_MASK)
-
-#define GPIO_PIN13_ADDRESS                       0x0000005c
-#define GPIO_PIN13_OFFSET                        0x0000005c
-#define GPIO_PIN13_CONFIG_MSB                    12
-#define GPIO_PIN13_CONFIG_LSB                    11
-#define GPIO_PIN13_CONFIG_MASK                   0x00001800
-#define GPIO_PIN13_CONFIG_GET(x)                 (((x) & GPIO_PIN13_CONFIG_MASK) >> GPIO_PIN13_CONFIG_LSB)
-#define GPIO_PIN13_CONFIG_SET(x)                 (((x) << GPIO_PIN13_CONFIG_LSB) & GPIO_PIN13_CONFIG_MASK)
-#define GPIO_PIN13_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN13_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN13_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN13_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN13_WAKEUP_ENABLE_MASK) >> GPIO_PIN13_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN13_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN13_WAKEUP_ENABLE_LSB) & GPIO_PIN13_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN13_INT_TYPE_MSB                  9
-#define GPIO_PIN13_INT_TYPE_LSB                  7
-#define GPIO_PIN13_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN13_INT_TYPE_GET(x)               (((x) & GPIO_PIN13_INT_TYPE_MASK) >> GPIO_PIN13_INT_TYPE_LSB)
-#define GPIO_PIN13_INT_TYPE_SET(x)               (((x) << GPIO_PIN13_INT_TYPE_LSB) & GPIO_PIN13_INT_TYPE_MASK)
-#define GPIO_PIN13_PAD_DRIVER_MSB                2
-#define GPIO_PIN13_PAD_DRIVER_LSB                2
-#define GPIO_PIN13_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN13_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN13_PAD_DRIVER_MASK) >> GPIO_PIN13_PAD_DRIVER_LSB)
-#define GPIO_PIN13_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN13_PAD_DRIVER_LSB) & GPIO_PIN13_PAD_DRIVER_MASK)
-#define GPIO_PIN13_SOURCE_MSB                    0
-#define GPIO_PIN13_SOURCE_LSB                    0
-#define GPIO_PIN13_SOURCE_MASK                   0x00000001
-#define GPIO_PIN13_SOURCE_GET(x)                 (((x) & GPIO_PIN13_SOURCE_MASK) >> GPIO_PIN13_SOURCE_LSB)
-#define GPIO_PIN13_SOURCE_SET(x)                 (((x) << GPIO_PIN13_SOURCE_LSB) & GPIO_PIN13_SOURCE_MASK)
-
-#define GPIO_PIN14_ADDRESS                       0x00000060
-#define GPIO_PIN14_OFFSET                        0x00000060
-#define GPIO_PIN14_CONFIG_MSB                    12
-#define GPIO_PIN14_CONFIG_LSB                    11
-#define GPIO_PIN14_CONFIG_MASK                   0x00001800
-#define GPIO_PIN14_CONFIG_GET(x)                 (((x) & GPIO_PIN14_CONFIG_MASK) >> GPIO_PIN14_CONFIG_LSB)
-#define GPIO_PIN14_CONFIG_SET(x)                 (((x) << GPIO_PIN14_CONFIG_LSB) & GPIO_PIN14_CONFIG_MASK)
-#define GPIO_PIN14_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN14_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN14_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN14_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN14_WAKEUP_ENABLE_MASK) >> GPIO_PIN14_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN14_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN14_WAKEUP_ENABLE_LSB) & GPIO_PIN14_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN14_INT_TYPE_MSB                  9
-#define GPIO_PIN14_INT_TYPE_LSB                  7
-#define GPIO_PIN14_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN14_INT_TYPE_GET(x)               (((x) & GPIO_PIN14_INT_TYPE_MASK) >> GPIO_PIN14_INT_TYPE_LSB)
-#define GPIO_PIN14_INT_TYPE_SET(x)               (((x) << GPIO_PIN14_INT_TYPE_LSB) & GPIO_PIN14_INT_TYPE_MASK)
-#define GPIO_PIN14_PAD_DRIVER_MSB                2
-#define GPIO_PIN14_PAD_DRIVER_LSB                2
-#define GPIO_PIN14_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN14_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN14_PAD_DRIVER_MASK) >> GPIO_PIN14_PAD_DRIVER_LSB)
-#define GPIO_PIN14_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN14_PAD_DRIVER_LSB) & GPIO_PIN14_PAD_DRIVER_MASK)
-#define GPIO_PIN14_SOURCE_MSB                    0
-#define GPIO_PIN14_SOURCE_LSB                    0
-#define GPIO_PIN14_SOURCE_MASK                   0x00000001
-#define GPIO_PIN14_SOURCE_GET(x)                 (((x) & GPIO_PIN14_SOURCE_MASK) >> GPIO_PIN14_SOURCE_LSB)
-#define GPIO_PIN14_SOURCE_SET(x)                 (((x) << GPIO_PIN14_SOURCE_LSB) & GPIO_PIN14_SOURCE_MASK)
-
-#define GPIO_PIN15_ADDRESS                       0x00000064
-#define GPIO_PIN15_OFFSET                        0x00000064
-#define GPIO_PIN15_CONFIG_MSB                    12
-#define GPIO_PIN15_CONFIG_LSB                    11
-#define GPIO_PIN15_CONFIG_MASK                   0x00001800
-#define GPIO_PIN15_CONFIG_GET(x)                 (((x) & GPIO_PIN15_CONFIG_MASK) >> GPIO_PIN15_CONFIG_LSB)
-#define GPIO_PIN15_CONFIG_SET(x)                 (((x) << GPIO_PIN15_CONFIG_LSB) & GPIO_PIN15_CONFIG_MASK)
-#define GPIO_PIN15_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN15_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN15_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN15_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN15_WAKEUP_ENABLE_MASK) >> GPIO_PIN15_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN15_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN15_WAKEUP_ENABLE_LSB) & GPIO_PIN15_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN15_INT_TYPE_MSB                  9
-#define GPIO_PIN15_INT_TYPE_LSB                  7
-#define GPIO_PIN15_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN15_INT_TYPE_GET(x)               (((x) & GPIO_PIN15_INT_TYPE_MASK) >> GPIO_PIN15_INT_TYPE_LSB)
-#define GPIO_PIN15_INT_TYPE_SET(x)               (((x) << GPIO_PIN15_INT_TYPE_LSB) & GPIO_PIN15_INT_TYPE_MASK)
-#define GPIO_PIN15_PAD_DRIVER_MSB                2
-#define GPIO_PIN15_PAD_DRIVER_LSB                2
-#define GPIO_PIN15_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN15_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN15_PAD_DRIVER_MASK) >> GPIO_PIN15_PAD_DRIVER_LSB)
-#define GPIO_PIN15_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN15_PAD_DRIVER_LSB) & GPIO_PIN15_PAD_DRIVER_MASK)
-#define GPIO_PIN15_SOURCE_MSB                    0
-#define GPIO_PIN15_SOURCE_LSB                    0
-#define GPIO_PIN15_SOURCE_MASK                   0x00000001
-#define GPIO_PIN15_SOURCE_GET(x)                 (((x) & GPIO_PIN15_SOURCE_MASK) >> GPIO_PIN15_SOURCE_LSB)
-#define GPIO_PIN15_SOURCE_SET(x)                 (((x) << GPIO_PIN15_SOURCE_LSB) & GPIO_PIN15_SOURCE_MASK)
-
-#define GPIO_PIN16_ADDRESS                       0x00000068
-#define GPIO_PIN16_OFFSET                        0x00000068
-#define GPIO_PIN16_CONFIG_MSB                    12
-#define GPIO_PIN16_CONFIG_LSB                    11
-#define GPIO_PIN16_CONFIG_MASK                   0x00001800
-#define GPIO_PIN16_CONFIG_GET(x)                 (((x) & GPIO_PIN16_CONFIG_MASK) >> GPIO_PIN16_CONFIG_LSB)
-#define GPIO_PIN16_CONFIG_SET(x)                 (((x) << GPIO_PIN16_CONFIG_LSB) & GPIO_PIN16_CONFIG_MASK)
-#define GPIO_PIN16_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN16_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN16_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN16_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN16_WAKEUP_ENABLE_MASK) >> GPIO_PIN16_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN16_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN16_WAKEUP_ENABLE_LSB) & GPIO_PIN16_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN16_INT_TYPE_MSB                  9
-#define GPIO_PIN16_INT_TYPE_LSB                  7
-#define GPIO_PIN16_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN16_INT_TYPE_GET(x)               (((x) & GPIO_PIN16_INT_TYPE_MASK) >> GPIO_PIN16_INT_TYPE_LSB)
-#define GPIO_PIN16_INT_TYPE_SET(x)               (((x) << GPIO_PIN16_INT_TYPE_LSB) & GPIO_PIN16_INT_TYPE_MASK)
-#define GPIO_PIN16_PAD_DRIVER_MSB                2
-#define GPIO_PIN16_PAD_DRIVER_LSB                2
-#define GPIO_PIN16_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN16_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN16_PAD_DRIVER_MASK) >> GPIO_PIN16_PAD_DRIVER_LSB)
-#define GPIO_PIN16_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN16_PAD_DRIVER_LSB) & GPIO_PIN16_PAD_DRIVER_MASK)
-#define GPIO_PIN16_SOURCE_MSB                    0
-#define GPIO_PIN16_SOURCE_LSB                    0
-#define GPIO_PIN16_SOURCE_MASK                   0x00000001
-#define GPIO_PIN16_SOURCE_GET(x)                 (((x) & GPIO_PIN16_SOURCE_MASK) >> GPIO_PIN16_SOURCE_LSB)
-#define GPIO_PIN16_SOURCE_SET(x)                 (((x) << GPIO_PIN16_SOURCE_LSB) & GPIO_PIN16_SOURCE_MASK)
-
-#define GPIO_PIN17_ADDRESS                       0x0000006c
-#define GPIO_PIN17_OFFSET                        0x0000006c
-#define GPIO_PIN17_CONFIG_MSB                    12
-#define GPIO_PIN17_CONFIG_LSB                    11
-#define GPIO_PIN17_CONFIG_MASK                   0x00001800
-#define GPIO_PIN17_CONFIG_GET(x)                 (((x) & GPIO_PIN17_CONFIG_MASK) >> GPIO_PIN17_CONFIG_LSB)
-#define GPIO_PIN17_CONFIG_SET(x)                 (((x) << GPIO_PIN17_CONFIG_LSB) & GPIO_PIN17_CONFIG_MASK)
-#define GPIO_PIN17_WAKEUP_ENABLE_MSB             10
-#define GPIO_PIN17_WAKEUP_ENABLE_LSB             10
-#define GPIO_PIN17_WAKEUP_ENABLE_MASK            0x00000400
-#define GPIO_PIN17_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN17_WAKEUP_ENABLE_MASK) >> GPIO_PIN17_WAKEUP_ENABLE_LSB)
-#define GPIO_PIN17_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN17_WAKEUP_ENABLE_LSB) & GPIO_PIN17_WAKEUP_ENABLE_MASK)
-#define GPIO_PIN17_INT_TYPE_MSB                  9
-#define GPIO_PIN17_INT_TYPE_LSB                  7
-#define GPIO_PIN17_INT_TYPE_MASK                 0x00000380
-#define GPIO_PIN17_INT_TYPE_GET(x)               (((x) & GPIO_PIN17_INT_TYPE_MASK) >> GPIO_PIN17_INT_TYPE_LSB)
-#define GPIO_PIN17_INT_TYPE_SET(x)               (((x) << GPIO_PIN17_INT_TYPE_LSB) & GPIO_PIN17_INT_TYPE_MASK)
-#define GPIO_PIN17_PAD_DRIVER_MSB                2
-#define GPIO_PIN17_PAD_DRIVER_LSB                2
-#define GPIO_PIN17_PAD_DRIVER_MASK               0x00000004
-#define GPIO_PIN17_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN17_PAD_DRIVER_MASK) >> GPIO_PIN17_PAD_DRIVER_LSB)
-#define GPIO_PIN17_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN17_PAD_DRIVER_LSB) & GPIO_PIN17_PAD_DRIVER_MASK)
-#define GPIO_PIN17_SOURCE_MSB                    0
-#define GPIO_PIN17_SOURCE_LSB                    0
-#define GPIO_PIN17_SOURCE_MASK                   0x00000001
-#define GPIO_PIN17_SOURCE_GET(x)                 (((x) & GPIO_PIN17_SOURCE_MASK) >> GPIO_PIN17_SOURCE_LSB)
-#define GPIO_PIN17_SOURCE_SET(x)                 (((x) << GPIO_PIN17_SOURCE_LSB) & GPIO_PIN17_SOURCE_MASK)
-
-#define SDIO_PIN_ADDRESS                         0x00000070
-#define SDIO_PIN_OFFSET                          0x00000070
-#define SDIO_PIN_PAD_PULL_MSB                    3
-#define SDIO_PIN_PAD_PULL_LSB                    2
-#define SDIO_PIN_PAD_PULL_MASK                   0x0000000c
-#define SDIO_PIN_PAD_PULL_GET(x)                 (((x) & SDIO_PIN_PAD_PULL_MASK) >> SDIO_PIN_PAD_PULL_LSB)
-#define SDIO_PIN_PAD_PULL_SET(x)                 (((x) << SDIO_PIN_PAD_PULL_LSB) & SDIO_PIN_PAD_PULL_MASK)
-#define SDIO_PIN_PAD_STRENGTH_MSB                1
-#define SDIO_PIN_PAD_STRENGTH_LSB                0
-#define SDIO_PIN_PAD_STRENGTH_MASK               0x00000003
-#define SDIO_PIN_PAD_STRENGTH_GET(x)             (((x) & SDIO_PIN_PAD_STRENGTH_MASK) >> SDIO_PIN_PAD_STRENGTH_LSB)
-#define SDIO_PIN_PAD_STRENGTH_SET(x)             (((x) << SDIO_PIN_PAD_STRENGTH_LSB) & SDIO_PIN_PAD_STRENGTH_MASK)
-
-#define CLK_REQ_PIN_ADDRESS                      0x00000074
-#define CLK_REQ_PIN_OFFSET                       0x00000074
-#define CLK_REQ_PIN_ATE_OE_L_MSB                 4
-#define CLK_REQ_PIN_ATE_OE_L_LSB                 4
-#define CLK_REQ_PIN_ATE_OE_L_MASK                0x00000010
-#define CLK_REQ_PIN_ATE_OE_L_GET(x)              (((x) & CLK_REQ_PIN_ATE_OE_L_MASK) >> CLK_REQ_PIN_ATE_OE_L_LSB)
-#define CLK_REQ_PIN_ATE_OE_L_SET(x)              (((x) << CLK_REQ_PIN_ATE_OE_L_LSB) & CLK_REQ_PIN_ATE_OE_L_MASK)
-#define CLK_REQ_PIN_PAD_PULL_MSB                 3
-#define CLK_REQ_PIN_PAD_PULL_LSB                 2
-#define CLK_REQ_PIN_PAD_PULL_MASK                0x0000000c
-#define CLK_REQ_PIN_PAD_PULL_GET(x)              (((x) & CLK_REQ_PIN_PAD_PULL_MASK) >> CLK_REQ_PIN_PAD_PULL_LSB)
-#define CLK_REQ_PIN_PAD_PULL_SET(x)              (((x) << CLK_REQ_PIN_PAD_PULL_LSB) & CLK_REQ_PIN_PAD_PULL_MASK)
-#define CLK_REQ_PIN_PAD_STRENGTH_MSB             1
-#define CLK_REQ_PIN_PAD_STRENGTH_LSB             0
-#define CLK_REQ_PIN_PAD_STRENGTH_MASK            0x00000003
-#define CLK_REQ_PIN_PAD_STRENGTH_GET(x)          (((x) & CLK_REQ_PIN_PAD_STRENGTH_MASK) >> CLK_REQ_PIN_PAD_STRENGTH_LSB)
-#define CLK_REQ_PIN_PAD_STRENGTH_SET(x)          (((x) << CLK_REQ_PIN_PAD_STRENGTH_LSB) & CLK_REQ_PIN_PAD_STRENGTH_MASK)
-
-#define SIGMA_DELTA_ADDRESS                      0x00000078
-#define SIGMA_DELTA_OFFSET                       0x00000078
-#define SIGMA_DELTA_ENABLE_MSB                   16
-#define SIGMA_DELTA_ENABLE_LSB                   16
-#define SIGMA_DELTA_ENABLE_MASK                  0x00010000
-#define SIGMA_DELTA_ENABLE_GET(x)                (((x) & SIGMA_DELTA_ENABLE_MASK) >> SIGMA_DELTA_ENABLE_LSB)
-#define SIGMA_DELTA_ENABLE_SET(x)                (((x) << SIGMA_DELTA_ENABLE_LSB) & SIGMA_DELTA_ENABLE_MASK)
-#define SIGMA_DELTA_PRESCALAR_MSB                15
-#define SIGMA_DELTA_PRESCALAR_LSB                8
-#define SIGMA_DELTA_PRESCALAR_MASK               0x0000ff00
-#define SIGMA_DELTA_PRESCALAR_GET(x)             (((x) & SIGMA_DELTA_PRESCALAR_MASK) >> SIGMA_DELTA_PRESCALAR_LSB)
-#define SIGMA_DELTA_PRESCALAR_SET(x)             (((x) << SIGMA_DELTA_PRESCALAR_LSB) & SIGMA_DELTA_PRESCALAR_MASK)
-#define SIGMA_DELTA_TARGET_MSB                   7
-#define SIGMA_DELTA_TARGET_LSB                   0
-#define SIGMA_DELTA_TARGET_MASK                  0x000000ff
-#define SIGMA_DELTA_TARGET_GET(x)                (((x) & SIGMA_DELTA_TARGET_MASK) >> SIGMA_DELTA_TARGET_LSB)
-#define SIGMA_DELTA_TARGET_SET(x)                (((x) << SIGMA_DELTA_TARGET_LSB) & SIGMA_DELTA_TARGET_MASK)
-
-#define DEBUG_CONTROL_ADDRESS                    0x0000007c
-#define DEBUG_CONTROL_OFFSET                     0x0000007c
-#define DEBUG_CONTROL_OBS_OE_L_MSB               1
-#define DEBUG_CONTROL_OBS_OE_L_LSB               1
-#define DEBUG_CONTROL_OBS_OE_L_MASK              0x00000002
-#define DEBUG_CONTROL_OBS_OE_L_GET(x)            (((x) & DEBUG_CONTROL_OBS_OE_L_MASK) >> DEBUG_CONTROL_OBS_OE_L_LSB)
-#define DEBUG_CONTROL_OBS_OE_L_SET(x)            (((x) << DEBUG_CONTROL_OBS_OE_L_LSB) & DEBUG_CONTROL_OBS_OE_L_MASK)
-#define DEBUG_CONTROL_ENABLE_MSB                 0
-#define DEBUG_CONTROL_ENABLE_LSB                 0
-#define DEBUG_CONTROL_ENABLE_MASK                0x00000001
-#define DEBUG_CONTROL_ENABLE_GET(x)              (((x) & DEBUG_CONTROL_ENABLE_MASK) >> DEBUG_CONTROL_ENABLE_LSB)
-#define DEBUG_CONTROL_ENABLE_SET(x)              (((x) << DEBUG_CONTROL_ENABLE_LSB) & DEBUG_CONTROL_ENABLE_MASK)
-
-#define DEBUG_INPUT_SEL_ADDRESS                  0x00000080
-#define DEBUG_INPUT_SEL_OFFSET                   0x00000080
-#define DEBUG_INPUT_SEL_SRC_MSB                  3
-#define DEBUG_INPUT_SEL_SRC_LSB                  0
-#define DEBUG_INPUT_SEL_SRC_MASK                 0x0000000f
-#define DEBUG_INPUT_SEL_SRC_GET(x)               (((x) & DEBUG_INPUT_SEL_SRC_MASK) >> DEBUG_INPUT_SEL_SRC_LSB)
-#define DEBUG_INPUT_SEL_SRC_SET(x)               (((x) << DEBUG_INPUT_SEL_SRC_LSB) & DEBUG_INPUT_SEL_SRC_MASK)
-
-#define DEBUG_OUT_ADDRESS                        0x00000084
-#define DEBUG_OUT_OFFSET                         0x00000084
-#define DEBUG_OUT_DATA_MSB                       17
-#define DEBUG_OUT_DATA_LSB                       0
-#define DEBUG_OUT_DATA_MASK                      0x0003ffff
-#define DEBUG_OUT_DATA_GET(x)                    (((x) & DEBUG_OUT_DATA_MASK) >> DEBUG_OUT_DATA_LSB)
-#define DEBUG_OUT_DATA_SET(x)                    (((x) << DEBUG_OUT_DATA_LSB) & DEBUG_OUT_DATA_MASK)
-
-#define LA_CONTROL_ADDRESS                       0x00000088
-#define LA_CONTROL_OFFSET                        0x00000088
-#define LA_CONTROL_RUN_MSB                       1
-#define LA_CONTROL_RUN_LSB                       1
-#define LA_CONTROL_RUN_MASK                      0x00000002
-#define LA_CONTROL_RUN_GET(x)                    (((x) & LA_CONTROL_RUN_MASK) >> LA_CONTROL_RUN_LSB)
-#define LA_CONTROL_RUN_SET(x)                    (((x) << LA_CONTROL_RUN_LSB) & LA_CONTROL_RUN_MASK)
-#define LA_CONTROL_TRIGGERED_MSB                 0
-#define LA_CONTROL_TRIGGERED_LSB                 0
-#define LA_CONTROL_TRIGGERED_MASK                0x00000001
-#define LA_CONTROL_TRIGGERED_GET(x)              (((x) & LA_CONTROL_TRIGGERED_MASK) >> LA_CONTROL_TRIGGERED_LSB)
-#define LA_CONTROL_TRIGGERED_SET(x)              (((x) << LA_CONTROL_TRIGGERED_LSB) & LA_CONTROL_TRIGGERED_MASK)
-
-#define LA_CLOCK_ADDRESS                         0x0000008c
-#define LA_CLOCK_OFFSET                          0x0000008c
-#define LA_CLOCK_DIV_MSB                         7
-#define LA_CLOCK_DIV_LSB                         0
-#define LA_CLOCK_DIV_MASK                        0x000000ff
-#define LA_CLOCK_DIV_GET(x)                      (((x) & LA_CLOCK_DIV_MASK) >> LA_CLOCK_DIV_LSB)
-#define LA_CLOCK_DIV_SET(x)                      (((x) << LA_CLOCK_DIV_LSB) & LA_CLOCK_DIV_MASK)
-
-#define LA_STATUS_ADDRESS                        0x00000090
-#define LA_STATUS_OFFSET                         0x00000090
-#define LA_STATUS_INTERRUPT_MSB                  0
-#define LA_STATUS_INTERRUPT_LSB                  0
-#define LA_STATUS_INTERRUPT_MASK                 0x00000001
-#define LA_STATUS_INTERRUPT_GET(x)               (((x) & LA_STATUS_INTERRUPT_MASK) >> LA_STATUS_INTERRUPT_LSB)
-#define LA_STATUS_INTERRUPT_SET(x)               (((x) << LA_STATUS_INTERRUPT_LSB) & LA_STATUS_INTERRUPT_MASK)
-
-#define LA_TRIGGER_SAMPLE_ADDRESS                0x00000094
-#define LA_TRIGGER_SAMPLE_OFFSET                 0x00000094
-#define LA_TRIGGER_SAMPLE_COUNT_MSB              15
-#define LA_TRIGGER_SAMPLE_COUNT_LSB              0
-#define LA_TRIGGER_SAMPLE_COUNT_MASK             0x0000ffff
-#define LA_TRIGGER_SAMPLE_COUNT_GET(x)           (((x) & LA_TRIGGER_SAMPLE_COUNT_MASK) >> LA_TRIGGER_SAMPLE_COUNT_LSB)
-#define LA_TRIGGER_SAMPLE_COUNT_SET(x)           (((x) << LA_TRIGGER_SAMPLE_COUNT_LSB) & LA_TRIGGER_SAMPLE_COUNT_MASK)
-
-#define LA_TRIGGER_POSITION_ADDRESS              0x00000098
-#define LA_TRIGGER_POSITION_OFFSET               0x00000098
-#define LA_TRIGGER_POSITION_VALUE_MSB            15
-#define LA_TRIGGER_POSITION_VALUE_LSB            0
-#define LA_TRIGGER_POSITION_VALUE_MASK           0x0000ffff
-#define LA_TRIGGER_POSITION_VALUE_GET(x)         (((x) & LA_TRIGGER_POSITION_VALUE_MASK) >> LA_TRIGGER_POSITION_VALUE_LSB)
-#define LA_TRIGGER_POSITION_VALUE_SET(x)         (((x) << LA_TRIGGER_POSITION_VALUE_LSB) & LA_TRIGGER_POSITION_VALUE_MASK)
-
-#define LA_PRE_TRIGGER_ADDRESS                   0x0000009c
-#define LA_PRE_TRIGGER_OFFSET                    0x0000009c
-#define LA_PRE_TRIGGER_COUNT_MSB                 15
-#define LA_PRE_TRIGGER_COUNT_LSB                 0
-#define LA_PRE_TRIGGER_COUNT_MASK                0x0000ffff
-#define LA_PRE_TRIGGER_COUNT_GET(x)              (((x) & LA_PRE_TRIGGER_COUNT_MASK) >> LA_PRE_TRIGGER_COUNT_LSB)
-#define LA_PRE_TRIGGER_COUNT_SET(x)              (((x) << LA_PRE_TRIGGER_COUNT_LSB) & LA_PRE_TRIGGER_COUNT_MASK)
-
-#define LA_POST_TRIGGER_ADDRESS                  0x000000a0
-#define LA_POST_TRIGGER_OFFSET                   0x000000a0
-#define LA_POST_TRIGGER_COUNT_MSB                15
-#define LA_POST_TRIGGER_COUNT_LSB                0
-#define LA_POST_TRIGGER_COUNT_MASK               0x0000ffff
-#define LA_POST_TRIGGER_COUNT_GET(x)             (((x) & LA_POST_TRIGGER_COUNT_MASK) >> LA_POST_TRIGGER_COUNT_LSB)
-#define LA_POST_TRIGGER_COUNT_SET(x)             (((x) << LA_POST_TRIGGER_COUNT_LSB) & LA_POST_TRIGGER_COUNT_MASK)
-
-#define LA_FILTER_CONTROL_ADDRESS                0x000000a4
-#define LA_FILTER_CONTROL_OFFSET                 0x000000a4
-#define LA_FILTER_CONTROL_DELTA_MSB              0
-#define LA_FILTER_CONTROL_DELTA_LSB              0
-#define LA_FILTER_CONTROL_DELTA_MASK             0x00000001
-#define LA_FILTER_CONTROL_DELTA_GET(x)           (((x) & LA_FILTER_CONTROL_DELTA_MASK) >> LA_FILTER_CONTROL_DELTA_LSB)
-#define LA_FILTER_CONTROL_DELTA_SET(x)           (((x) << LA_FILTER_CONTROL_DELTA_LSB) & LA_FILTER_CONTROL_DELTA_MASK)
-
-#define LA_FILTER_DATA_ADDRESS                   0x000000a8
-#define LA_FILTER_DATA_OFFSET                    0x000000a8
-#define LA_FILTER_DATA_MATCH_MSB                 17
-#define LA_FILTER_DATA_MATCH_LSB                 0
-#define LA_FILTER_DATA_MATCH_MASK                0x0003ffff
-#define LA_FILTER_DATA_MATCH_GET(x)              (((x) & LA_FILTER_DATA_MATCH_MASK) >> LA_FILTER_DATA_MATCH_LSB)
-#define LA_FILTER_DATA_MATCH_SET(x)              (((x) << LA_FILTER_DATA_MATCH_LSB) & LA_FILTER_DATA_MATCH_MASK)
-
-#define LA_FILTER_WILDCARD_ADDRESS               0x000000ac
-#define LA_FILTER_WILDCARD_OFFSET                0x000000ac
-#define LA_FILTER_WILDCARD_MATCH_MSB             17
-#define LA_FILTER_WILDCARD_MATCH_LSB             0
-#define LA_FILTER_WILDCARD_MATCH_MASK            0x0003ffff
-#define LA_FILTER_WILDCARD_MATCH_GET(x)          (((x) & LA_FILTER_WILDCARD_MATCH_MASK) >> LA_FILTER_WILDCARD_MATCH_LSB)
-#define LA_FILTER_WILDCARD_MATCH_SET(x)          (((x) << LA_FILTER_WILDCARD_MATCH_LSB) & LA_FILTER_WILDCARD_MATCH_MASK)
-
-#define LA_TRIGGERA_DATA_ADDRESS                 0x000000b0
-#define LA_TRIGGERA_DATA_OFFSET                  0x000000b0
-#define LA_TRIGGERA_DATA_MATCH_MSB               17
-#define LA_TRIGGERA_DATA_MATCH_LSB               0
-#define LA_TRIGGERA_DATA_MATCH_MASK              0x0003ffff
-#define LA_TRIGGERA_DATA_MATCH_GET(x)            (((x) & LA_TRIGGERA_DATA_MATCH_MASK) >> LA_TRIGGERA_DATA_MATCH_LSB)
-#define LA_TRIGGERA_DATA_MATCH_SET(x)            (((x) << LA_TRIGGERA_DATA_MATCH_LSB) & LA_TRIGGERA_DATA_MATCH_MASK)
-
-#define LA_TRIGGERA_WILDCARD_ADDRESS             0x000000b4
-#define LA_TRIGGERA_WILDCARD_OFFSET              0x000000b4
-#define LA_TRIGGERA_WILDCARD_MATCH_MSB           17
-#define LA_TRIGGERA_WILDCARD_MATCH_LSB           0
-#define LA_TRIGGERA_WILDCARD_MATCH_MASK          0x0003ffff
-#define LA_TRIGGERA_WILDCARD_MATCH_GET(x)        (((x) & LA_TRIGGERA_WILDCARD_MATCH_MASK) >> LA_TRIGGERA_WILDCARD_MATCH_LSB)
-#define LA_TRIGGERA_WILDCARD_MATCH_SET(x)        (((x) << LA_TRIGGERA_WILDCARD_MATCH_LSB) & LA_TRIGGERA_WILDCARD_MATCH_MASK)
-
-#define LA_TRIGGERB_DATA_ADDRESS                 0x000000b8
-#define LA_TRIGGERB_DATA_OFFSET                  0x000000b8
-#define LA_TRIGGERB_DATA_MATCH_MSB               17
-#define LA_TRIGGERB_DATA_MATCH_LSB               0
-#define LA_TRIGGERB_DATA_MATCH_MASK              0x0003ffff
-#define LA_TRIGGERB_DATA_MATCH_GET(x)            (((x) & LA_TRIGGERB_DATA_MATCH_MASK) >> LA_TRIGGERB_DATA_MATCH_LSB)
-#define LA_TRIGGERB_DATA_MATCH_SET(x)            (((x) << LA_TRIGGERB_DATA_MATCH_LSB) & LA_TRIGGERB_DATA_MATCH_MASK)
-
-#define LA_TRIGGERB_WILDCARD_ADDRESS             0x000000bc
-#define LA_TRIGGERB_WILDCARD_OFFSET              0x000000bc
-#define LA_TRIGGERB_WILDCARD_MATCH_MSB           17
-#define LA_TRIGGERB_WILDCARD_MATCH_LSB           0
-#define LA_TRIGGERB_WILDCARD_MATCH_MASK          0x0003ffff
-#define LA_TRIGGERB_WILDCARD_MATCH_GET(x)        (((x) & LA_TRIGGERB_WILDCARD_MATCH_MASK) >> LA_TRIGGERB_WILDCARD_MATCH_LSB)
-#define LA_TRIGGERB_WILDCARD_MATCH_SET(x)        (((x) << LA_TRIGGERB_WILDCARD_MATCH_LSB) & LA_TRIGGERB_WILDCARD_MATCH_MASK)
-
-#define LA_TRIGGER_ADDRESS                       0x000000c0
-#define LA_TRIGGER_OFFSET                        0x000000c0
-#define LA_TRIGGER_EVENT_MSB                     2
-#define LA_TRIGGER_EVENT_LSB                     0
-#define LA_TRIGGER_EVENT_MASK                    0x00000007
-#define LA_TRIGGER_EVENT_GET(x)                  (((x) & LA_TRIGGER_EVENT_MASK) >> LA_TRIGGER_EVENT_LSB)
-#define LA_TRIGGER_EVENT_SET(x)                  (((x) << LA_TRIGGER_EVENT_LSB) & LA_TRIGGER_EVENT_MASK)
-
-#define LA_FIFO_ADDRESS                          0x000000c4
-#define LA_FIFO_OFFSET                           0x000000c4
-#define LA_FIFO_FULL_MSB                         1
-#define LA_FIFO_FULL_LSB                         1
-#define LA_FIFO_FULL_MASK                        0x00000002
-#define LA_FIFO_FULL_GET(x)                      (((x) & LA_FIFO_FULL_MASK) >> LA_FIFO_FULL_LSB)
-#define LA_FIFO_FULL_SET(x)                      (((x) << LA_FIFO_FULL_LSB) & LA_FIFO_FULL_MASK)
-#define LA_FIFO_EMPTY_MSB                        0
-#define LA_FIFO_EMPTY_LSB                        0
-#define LA_FIFO_EMPTY_MASK                       0x00000001
-#define LA_FIFO_EMPTY_GET(x)                     (((x) & LA_FIFO_EMPTY_MASK) >> LA_FIFO_EMPTY_LSB)
-#define LA_FIFO_EMPTY_SET(x)                     (((x) << LA_FIFO_EMPTY_LSB) & LA_FIFO_EMPTY_MASK)
-
-#define LA_ADDRESS                               0x000000c8
-#define LA_OFFSET                                0x000000c8
-#define LA_DATA_MSB                              17
-#define LA_DATA_LSB                              0
-#define LA_DATA_MASK                             0x0003ffff
-#define LA_DATA_GET(x)                           (((x) & LA_DATA_MASK) >> LA_DATA_LSB)
-#define LA_DATA_SET(x)                           (((x) << LA_DATA_LSB) & LA_DATA_MASK)
-
-#define ANT_PIN_ADDRESS                          0x000000d0
-#define ANT_PIN_OFFSET                           0x000000d0
-#define ANT_PIN_PAD_PULL_MSB                     3
-#define ANT_PIN_PAD_PULL_LSB                     2
-#define ANT_PIN_PAD_PULL_MASK                    0x0000000c
-#define ANT_PIN_PAD_PULL_GET(x)                  (((x) & ANT_PIN_PAD_PULL_MASK) >> ANT_PIN_PAD_PULL_LSB)
-#define ANT_PIN_PAD_PULL_SET(x)                  (((x) << ANT_PIN_PAD_PULL_LSB) & ANT_PIN_PAD_PULL_MASK)
-#define ANT_PIN_PAD_STRENGTH_MSB                 1
-#define ANT_PIN_PAD_STRENGTH_LSB                 0
-#define ANT_PIN_PAD_STRENGTH_MASK                0x00000003
-#define ANT_PIN_PAD_STRENGTH_GET(x)              (((x) & ANT_PIN_PAD_STRENGTH_MASK) >> ANT_PIN_PAD_STRENGTH_LSB)
-#define ANT_PIN_PAD_STRENGTH_SET(x)              (((x) << ANT_PIN_PAD_STRENGTH_LSB) & ANT_PIN_PAD_STRENGTH_MASK)
-
-#define ANTD_PIN_ADDRESS                         0x000000d4
-#define ANTD_PIN_OFFSET                          0x000000d4
-#define ANTD_PIN_PAD_PULL_MSB                    1
-#define ANTD_PIN_PAD_PULL_LSB                    0
-#define ANTD_PIN_PAD_PULL_MASK                   0x00000003
-#define ANTD_PIN_PAD_PULL_GET(x)                 (((x) & ANTD_PIN_PAD_PULL_MASK) >> ANTD_PIN_PAD_PULL_LSB)
-#define ANTD_PIN_PAD_PULL_SET(x)                 (((x) << ANTD_PIN_PAD_PULL_LSB) & ANTD_PIN_PAD_PULL_MASK)
-
-#define GPIO_PIN_ADDRESS                         0x000000d8
-#define GPIO_PIN_OFFSET                          0x000000d8
-#define GPIO_PIN_PAD_PULL_MSB                    3
-#define GPIO_PIN_PAD_PULL_LSB                    2
-#define GPIO_PIN_PAD_PULL_MASK                   0x0000000c
-#define GPIO_PIN_PAD_PULL_GET(x)                 (((x) & GPIO_PIN_PAD_PULL_MASK) >> GPIO_PIN_PAD_PULL_LSB)
-#define GPIO_PIN_PAD_PULL_SET(x)                 (((x) << GPIO_PIN_PAD_PULL_LSB) & GPIO_PIN_PAD_PULL_MASK)
-#define GPIO_PIN_PAD_STRENGTH_MSB                1
-#define GPIO_PIN_PAD_STRENGTH_LSB                0
-#define GPIO_PIN_PAD_STRENGTH_MASK               0x00000003
-#define GPIO_PIN_PAD_STRENGTH_GET(x)             (((x) & GPIO_PIN_PAD_STRENGTH_MASK) >> GPIO_PIN_PAD_STRENGTH_LSB)
-#define GPIO_PIN_PAD_STRENGTH_SET(x)             (((x) << GPIO_PIN_PAD_STRENGTH_LSB) & GPIO_PIN_PAD_STRENGTH_MASK)
-
-#define GPIO_H_PIN_ADDRESS                       0x000000dc
-#define GPIO_H_PIN_OFFSET                        0x000000dc
-#define GPIO_H_PIN_PAD_PULL_MSB                  1
-#define GPIO_H_PIN_PAD_PULL_LSB                  0
-#define GPIO_H_PIN_PAD_PULL_MASK                 0x00000003
-#define GPIO_H_PIN_PAD_PULL_GET(x)               (((x) & GPIO_H_PIN_PAD_PULL_MASK) >> GPIO_H_PIN_PAD_PULL_LSB)
-#define GPIO_H_PIN_PAD_PULL_SET(x)               (((x) << GPIO_H_PIN_PAD_PULL_LSB) & GPIO_H_PIN_PAD_PULL_MASK)
-
-#define BT_PIN_ADDRESS                           0x000000e0
-#define BT_PIN_OFFSET                            0x000000e0
-#define BT_PIN_PAD_PULL_MSB                      3
-#define BT_PIN_PAD_PULL_LSB                      2
-#define BT_PIN_PAD_PULL_MASK                     0x0000000c
-#define BT_PIN_PAD_PULL_GET(x)                   (((x) & BT_PIN_PAD_PULL_MASK) >> BT_PIN_PAD_PULL_LSB)
-#define BT_PIN_PAD_PULL_SET(x)                   (((x) << BT_PIN_PAD_PULL_LSB) & BT_PIN_PAD_PULL_MASK)
-#define BT_PIN_PAD_STRENGTH_MSB                  1
-#define BT_PIN_PAD_STRENGTH_LSB                  0
-#define BT_PIN_PAD_STRENGTH_MASK                 0x00000003
-#define BT_PIN_PAD_STRENGTH_GET(x)               (((x) & BT_PIN_PAD_STRENGTH_MASK) >> BT_PIN_PAD_STRENGTH_LSB)
-#define BT_PIN_PAD_STRENGTH_SET(x)               (((x) << BT_PIN_PAD_STRENGTH_LSB) & BT_PIN_PAD_STRENGTH_MASK)
-
-#define BT_WLAN_PIN_ADDRESS                      0x000000e4
-#define BT_WLAN_PIN_OFFSET                       0x000000e4
-#define BT_WLAN_PIN_PAD_PULL_MSB                 1
-#define BT_WLAN_PIN_PAD_PULL_LSB                 0
-#define BT_WLAN_PIN_PAD_PULL_MASK                0x00000003
-#define BT_WLAN_PIN_PAD_PULL_GET(x)              (((x) & BT_WLAN_PIN_PAD_PULL_MASK) >> BT_WLAN_PIN_PAD_PULL_LSB)
-#define BT_WLAN_PIN_PAD_PULL_SET(x)              (((x) << BT_WLAN_PIN_PAD_PULL_LSB) & BT_WLAN_PIN_PAD_PULL_MASK)
-
-#define SI_UART_PIN_ADDRESS                      0x000000e8
-#define SI_UART_PIN_OFFSET                       0x000000e8
-#define SI_UART_PIN_PAD_PULL_MSB                 3
-#define SI_UART_PIN_PAD_PULL_LSB                 2
-#define SI_UART_PIN_PAD_PULL_MASK                0x0000000c
-#define SI_UART_PIN_PAD_PULL_GET(x)              (((x) & SI_UART_PIN_PAD_PULL_MASK) >> SI_UART_PIN_PAD_PULL_LSB)
-#define SI_UART_PIN_PAD_PULL_SET(x)              (((x) << SI_UART_PIN_PAD_PULL_LSB) & SI_UART_PIN_PAD_PULL_MASK)
-#define SI_UART_PIN_PAD_STRENGTH_MSB             1
-#define SI_UART_PIN_PAD_STRENGTH_LSB             0
-#define SI_UART_PIN_PAD_STRENGTH_MASK            0x00000003
-#define SI_UART_PIN_PAD_STRENGTH_GET(x)          (((x) & SI_UART_PIN_PAD_STRENGTH_MASK) >> SI_UART_PIN_PAD_STRENGTH_LSB)
-#define SI_UART_PIN_PAD_STRENGTH_SET(x)          (((x) << SI_UART_PIN_PAD_STRENGTH_LSB) & SI_UART_PIN_PAD_STRENGTH_MASK)
-
-#define CLK32K_PIN_ADDRESS                       0x000000ec
-#define CLK32K_PIN_OFFSET                        0x000000ec
-#define CLK32K_PIN_PAD_PULL_MSB                  1
-#define CLK32K_PIN_PAD_PULL_LSB                  0
-#define CLK32K_PIN_PAD_PULL_MASK                 0x00000003
-#define CLK32K_PIN_PAD_PULL_GET(x)               (((x) & CLK32K_PIN_PAD_PULL_MASK) >> CLK32K_PIN_PAD_PULL_LSB)
-#define CLK32K_PIN_PAD_PULL_SET(x)               (((x) << CLK32K_PIN_PAD_PULL_LSB) & CLK32K_PIN_PAD_PULL_MASK)
-
-#define RESET_TUPLE_STATUS_ADDRESS               0x000000f0
-#define RESET_TUPLE_STATUS_OFFSET                0x000000f0
-#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MSB  11
-#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB  8
-#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK 0x00000f00
-#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_GET(x) (((x) & RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK) >> RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB)
-#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_SET(x) (((x) << RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB) & RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK)
-#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MSB   7
-#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB   0
-#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK  0x000000ff
-#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_GET(x) (((x) & RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK) >> RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB)
-#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_SET(x) (((x) << RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB) & RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct gpio_reg_reg_s {
-  volatile unsigned int gpio_out;
-  volatile unsigned int gpio_out_w1ts;
-  volatile unsigned int gpio_out_w1tc;
-  volatile unsigned int gpio_enable;
-  volatile unsigned int gpio_enable_w1ts;
-  volatile unsigned int gpio_enable_w1tc;
-  volatile unsigned int gpio_in;
-  volatile unsigned int gpio_status;
-  volatile unsigned int gpio_status_w1ts;
-  volatile unsigned int gpio_status_w1tc;
-  volatile unsigned int gpio_pin0;
-  volatile unsigned int gpio_pin1;
-  volatile unsigned int gpio_pin2;
-  volatile unsigned int gpio_pin3;
-  volatile unsigned int gpio_pin4;
-  volatile unsigned int gpio_pin5;
-  volatile unsigned int gpio_pin6;
-  volatile unsigned int gpio_pin7;
-  volatile unsigned int gpio_pin8;
-  volatile unsigned int gpio_pin9;
-  volatile unsigned int gpio_pin10;
-  volatile unsigned int gpio_pin11;
-  volatile unsigned int gpio_pin12;
-  volatile unsigned int gpio_pin13;
-  volatile unsigned int gpio_pin14;
-  volatile unsigned int gpio_pin15;
-  volatile unsigned int gpio_pin16;
-  volatile unsigned int gpio_pin17;
-  volatile unsigned int sdio_pin;
-  volatile unsigned int clk_req_pin;
-  volatile unsigned int sigma_delta;
-  volatile unsigned int debug_control;
-  volatile unsigned int debug_input_sel;
-  volatile unsigned int debug_out;
-  volatile unsigned int la_control;
-  volatile unsigned int la_clock;
-  volatile unsigned int la_status;
-  volatile unsigned int la_trigger_sample;
-  volatile unsigned int la_trigger_position;
-  volatile unsigned int la_pre_trigger;
-  volatile unsigned int la_post_trigger;
-  volatile unsigned int la_filter_control;
-  volatile unsigned int la_filter_data;
-  volatile unsigned int la_filter_wildcard;
-  volatile unsigned int la_triggera_data;
-  volatile unsigned int la_triggera_wildcard;
-  volatile unsigned int la_triggerb_data;
-  volatile unsigned int la_triggerb_wildcard;
-  volatile unsigned int la_trigger;
-  volatile unsigned int la_fifo;
-  volatile unsigned int la[2];
-  volatile unsigned int ant_pin;
-  volatile unsigned int antd_pin;
-  volatile unsigned int gpio_pin;
-  volatile unsigned int gpio_h_pin;
-  volatile unsigned int bt_pin;
-  volatile unsigned int bt_wlan_pin;
-  volatile unsigned int si_uart_pin;
-  volatile unsigned int clk32k_pin;
-  volatile unsigned int reset_tuple_status;
-} gpio_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _GPIO_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h
deleted file mode 100644
index f836ae4..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h
+++ /dev/null
@@ -1,386 +0,0 @@
-#ifndef _MBOX_HOST_REG_REG_H_
-#define _MBOX_HOST_REG_REG_H_
-
-#define HOST_INT_STATUS_ADDRESS                  0x00000400
-#define HOST_INT_STATUS_OFFSET                   0x00000400
-#define HOST_INT_STATUS_ERROR_MSB                7
-#define HOST_INT_STATUS_ERROR_LSB                7
-#define HOST_INT_STATUS_ERROR_MASK               0x00000080
-#define HOST_INT_STATUS_ERROR_GET(x)             (((x) & HOST_INT_STATUS_ERROR_MASK) >> HOST_INT_STATUS_ERROR_LSB)
-#define HOST_INT_STATUS_ERROR_SET(x)             (((x) << HOST_INT_STATUS_ERROR_LSB) & HOST_INT_STATUS_ERROR_MASK)
-#define HOST_INT_STATUS_CPU_MSB                  6
-#define HOST_INT_STATUS_CPU_LSB                  6
-#define HOST_INT_STATUS_CPU_MASK                 0x00000040
-#define HOST_INT_STATUS_CPU_GET(x)               (((x) & HOST_INT_STATUS_CPU_MASK) >> HOST_INT_STATUS_CPU_LSB)
-#define HOST_INT_STATUS_CPU_SET(x)               (((x) << HOST_INT_STATUS_CPU_LSB) & HOST_INT_STATUS_CPU_MASK)
-#define HOST_INT_STATUS_DRAGON_INT_MSB           5
-#define HOST_INT_STATUS_DRAGON_INT_LSB           5
-#define HOST_INT_STATUS_DRAGON_INT_MASK          0x00000020
-#define HOST_INT_STATUS_DRAGON_INT_GET(x)        (((x) & HOST_INT_STATUS_DRAGON_INT_MASK) >> HOST_INT_STATUS_DRAGON_INT_LSB)
-#define HOST_INT_STATUS_DRAGON_INT_SET(x)        (((x) << HOST_INT_STATUS_DRAGON_INT_LSB) & HOST_INT_STATUS_DRAGON_INT_MASK)
-#define HOST_INT_STATUS_COUNTER_MSB              4
-#define HOST_INT_STATUS_COUNTER_LSB              4
-#define HOST_INT_STATUS_COUNTER_MASK             0x00000010
-#define HOST_INT_STATUS_COUNTER_GET(x)           (((x) & HOST_INT_STATUS_COUNTER_MASK) >> HOST_INT_STATUS_COUNTER_LSB)
-#define HOST_INT_STATUS_COUNTER_SET(x)           (((x) << HOST_INT_STATUS_COUNTER_LSB) & HOST_INT_STATUS_COUNTER_MASK)
-#define HOST_INT_STATUS_MBOX_DATA_MSB            3
-#define HOST_INT_STATUS_MBOX_DATA_LSB            0
-#define HOST_INT_STATUS_MBOX_DATA_MASK           0x0000000f
-#define HOST_INT_STATUS_MBOX_DATA_GET(x)         (((x) & HOST_INT_STATUS_MBOX_DATA_MASK) >> HOST_INT_STATUS_MBOX_DATA_LSB)
-#define HOST_INT_STATUS_MBOX_DATA_SET(x)         (((x) << HOST_INT_STATUS_MBOX_DATA_LSB) & HOST_INT_STATUS_MBOX_DATA_MASK)
-
-#define CPU_INT_STATUS_ADDRESS                   0x00000401
-#define CPU_INT_STATUS_OFFSET                    0x00000401
-#define CPU_INT_STATUS_BIT_MSB                   7
-#define CPU_INT_STATUS_BIT_LSB                   0
-#define CPU_INT_STATUS_BIT_MASK                  0x000000ff
-#define CPU_INT_STATUS_BIT_GET(x)                (((x) & CPU_INT_STATUS_BIT_MASK) >> CPU_INT_STATUS_BIT_LSB)
-#define CPU_INT_STATUS_BIT_SET(x)                (((x) << CPU_INT_STATUS_BIT_LSB) & CPU_INT_STATUS_BIT_MASK)
-
-#define ERROR_INT_STATUS_ADDRESS                 0x00000402
-#define ERROR_INT_STATUS_OFFSET                  0x00000402
-#define ERROR_INT_STATUS_SPI_MSB                 3
-#define ERROR_INT_STATUS_SPI_LSB                 3
-#define ERROR_INT_STATUS_SPI_MASK                0x00000008
-#define ERROR_INT_STATUS_SPI_GET(x)              (((x) & ERROR_INT_STATUS_SPI_MASK) >> ERROR_INT_STATUS_SPI_LSB)
-#define ERROR_INT_STATUS_SPI_SET(x)              (((x) << ERROR_INT_STATUS_SPI_LSB) & ERROR_INT_STATUS_SPI_MASK)
-#define ERROR_INT_STATUS_WAKEUP_MSB              2
-#define ERROR_INT_STATUS_WAKEUP_LSB              2
-#define ERROR_INT_STATUS_WAKEUP_MASK             0x00000004
-#define ERROR_INT_STATUS_WAKEUP_GET(x)           (((x) & ERROR_INT_STATUS_WAKEUP_MASK) >> ERROR_INT_STATUS_WAKEUP_LSB)
-#define ERROR_INT_STATUS_WAKEUP_SET(x)           (((x) << ERROR_INT_STATUS_WAKEUP_LSB) & ERROR_INT_STATUS_WAKEUP_MASK)
-#define ERROR_INT_STATUS_RX_UNDERFLOW_MSB        1
-#define ERROR_INT_STATUS_RX_UNDERFLOW_LSB        1
-#define ERROR_INT_STATUS_RX_UNDERFLOW_MASK       0x00000002
-#define ERROR_INT_STATUS_RX_UNDERFLOW_GET(x)     (((x) & ERROR_INT_STATUS_RX_UNDERFLOW_MASK) >> ERROR_INT_STATUS_RX_UNDERFLOW_LSB)
-#define ERROR_INT_STATUS_RX_UNDERFLOW_SET(x)     (((x) << ERROR_INT_STATUS_RX_UNDERFLOW_LSB) & ERROR_INT_STATUS_RX_UNDERFLOW_MASK)
-#define ERROR_INT_STATUS_TX_OVERFLOW_MSB         0
-#define ERROR_INT_STATUS_TX_OVERFLOW_LSB         0
-#define ERROR_INT_STATUS_TX_OVERFLOW_MASK        0x00000001
-#define ERROR_INT_STATUS_TX_OVERFLOW_GET(x)      (((x) & ERROR_INT_STATUS_TX_OVERFLOW_MASK) >> ERROR_INT_STATUS_TX_OVERFLOW_LSB)
-#define ERROR_INT_STATUS_TX_OVERFLOW_SET(x)      (((x) << ERROR_INT_STATUS_TX_OVERFLOW_LSB) & ERROR_INT_STATUS_TX_OVERFLOW_MASK)
-
-#define COUNTER_INT_STATUS_ADDRESS               0x00000403
-#define COUNTER_INT_STATUS_OFFSET                0x00000403
-#define COUNTER_INT_STATUS_COUNTER_MSB           7
-#define COUNTER_INT_STATUS_COUNTER_LSB           0
-#define COUNTER_INT_STATUS_COUNTER_MASK          0x000000ff
-#define COUNTER_INT_STATUS_COUNTER_GET(x)        (((x) & COUNTER_INT_STATUS_COUNTER_MASK) >> COUNTER_INT_STATUS_COUNTER_LSB)
-#define COUNTER_INT_STATUS_COUNTER_SET(x)        (((x) << COUNTER_INT_STATUS_COUNTER_LSB) & COUNTER_INT_STATUS_COUNTER_MASK)
-
-#define MBOX_FRAME_ADDRESS                       0x00000404
-#define MBOX_FRAME_OFFSET                        0x00000404
-#define MBOX_FRAME_RX_EOM_MSB                    7
-#define MBOX_FRAME_RX_EOM_LSB                    4
-#define MBOX_FRAME_RX_EOM_MASK                   0x000000f0
-#define MBOX_FRAME_RX_EOM_GET(x)                 (((x) & MBOX_FRAME_RX_EOM_MASK) >> MBOX_FRAME_RX_EOM_LSB)
-#define MBOX_FRAME_RX_EOM_SET(x)                 (((x) << MBOX_FRAME_RX_EOM_LSB) & MBOX_FRAME_RX_EOM_MASK)
-#define MBOX_FRAME_RX_SOM_MSB                    3
-#define MBOX_FRAME_RX_SOM_LSB                    0
-#define MBOX_FRAME_RX_SOM_MASK                   0x0000000f
-#define MBOX_FRAME_RX_SOM_GET(x)                 (((x) & MBOX_FRAME_RX_SOM_MASK) >> MBOX_FRAME_RX_SOM_LSB)
-#define MBOX_FRAME_RX_SOM_SET(x)                 (((x) << MBOX_FRAME_RX_SOM_LSB) & MBOX_FRAME_RX_SOM_MASK)
-
-#define RX_LOOKAHEAD_VALID_ADDRESS               0x00000405
-#define RX_LOOKAHEAD_VALID_OFFSET                0x00000405
-#define RX_LOOKAHEAD_VALID_MBOX_MSB              3
-#define RX_LOOKAHEAD_VALID_MBOX_LSB              0
-#define RX_LOOKAHEAD_VALID_MBOX_MASK             0x0000000f
-#define RX_LOOKAHEAD_VALID_MBOX_GET(x)           (((x) & RX_LOOKAHEAD_VALID_MBOX_MASK) >> RX_LOOKAHEAD_VALID_MBOX_LSB)
-#define RX_LOOKAHEAD_VALID_MBOX_SET(x)           (((x) << RX_LOOKAHEAD_VALID_MBOX_LSB) & RX_LOOKAHEAD_VALID_MBOX_MASK)
-
-#define RX_LOOKAHEAD0_ADDRESS                    0x00000408
-#define RX_LOOKAHEAD0_OFFSET                     0x00000408
-#define RX_LOOKAHEAD0_DATA_MSB                   7
-#define RX_LOOKAHEAD0_DATA_LSB                   0
-#define RX_LOOKAHEAD0_DATA_MASK                  0x000000ff
-#define RX_LOOKAHEAD0_DATA_GET(x)                (((x) & RX_LOOKAHEAD0_DATA_MASK) >> RX_LOOKAHEAD0_DATA_LSB)
-#define RX_LOOKAHEAD0_DATA_SET(x)                (((x) << RX_LOOKAHEAD0_DATA_LSB) & RX_LOOKAHEAD0_DATA_MASK)
-
-#define RX_LOOKAHEAD1_ADDRESS                    0x0000040c
-#define RX_LOOKAHEAD1_OFFSET                     0x0000040c
-#define RX_LOOKAHEAD1_DATA_MSB                   7
-#define RX_LOOKAHEAD1_DATA_LSB                   0
-#define RX_LOOKAHEAD1_DATA_MASK                  0x000000ff
-#define RX_LOOKAHEAD1_DATA_GET(x)                (((x) & RX_LOOKAHEAD1_DATA_MASK) >> RX_LOOKAHEAD1_DATA_LSB)
-#define RX_LOOKAHEAD1_DATA_SET(x)                (((x) << RX_LOOKAHEAD1_DATA_LSB) & RX_LOOKAHEAD1_DATA_MASK)
-
-#define RX_LOOKAHEAD2_ADDRESS                    0x00000410
-#define RX_LOOKAHEAD2_OFFSET                     0x00000410
-#define RX_LOOKAHEAD2_DATA_MSB                   7
-#define RX_LOOKAHEAD2_DATA_LSB                   0
-#define RX_LOOKAHEAD2_DATA_MASK                  0x000000ff
-#define RX_LOOKAHEAD2_DATA_GET(x)                (((x) & RX_LOOKAHEAD2_DATA_MASK) >> RX_LOOKAHEAD2_DATA_LSB)
-#define RX_LOOKAHEAD2_DATA_SET(x)                (((x) << RX_LOOKAHEAD2_DATA_LSB) & RX_LOOKAHEAD2_DATA_MASK)
-
-#define RX_LOOKAHEAD3_ADDRESS                    0x00000414
-#define RX_LOOKAHEAD3_OFFSET                     0x00000414
-#define RX_LOOKAHEAD3_DATA_MSB                   7
-#define RX_LOOKAHEAD3_DATA_LSB                   0
-#define RX_LOOKAHEAD3_DATA_MASK                  0x000000ff
-#define RX_LOOKAHEAD3_DATA_GET(x)                (((x) & RX_LOOKAHEAD3_DATA_MASK) >> RX_LOOKAHEAD3_DATA_LSB)
-#define RX_LOOKAHEAD3_DATA_SET(x)                (((x) << RX_LOOKAHEAD3_DATA_LSB) & RX_LOOKAHEAD3_DATA_MASK)
-
-#define INT_STATUS_ENABLE_ADDRESS                0x00000418
-#define INT_STATUS_ENABLE_OFFSET                 0x00000418
-#define INT_STATUS_ENABLE_ERROR_MSB              7
-#define INT_STATUS_ENABLE_ERROR_LSB              7
-#define INT_STATUS_ENABLE_ERROR_MASK             0x00000080
-#define INT_STATUS_ENABLE_ERROR_GET(x)           (((x) & INT_STATUS_ENABLE_ERROR_MASK) >> INT_STATUS_ENABLE_ERROR_LSB)
-#define INT_STATUS_ENABLE_ERROR_SET(x)           (((x) << INT_STATUS_ENABLE_ERROR_LSB) & INT_STATUS_ENABLE_ERROR_MASK)
-#define INT_STATUS_ENABLE_CPU_MSB                6
-#define INT_STATUS_ENABLE_CPU_LSB                6
-#define INT_STATUS_ENABLE_CPU_MASK               0x00000040
-#define INT_STATUS_ENABLE_CPU_GET(x)             (((x) & INT_STATUS_ENABLE_CPU_MASK) >> INT_STATUS_ENABLE_CPU_LSB)
-#define INT_STATUS_ENABLE_CPU_SET(x)             (((x) << INT_STATUS_ENABLE_CPU_LSB) & INT_STATUS_ENABLE_CPU_MASK)
-#define INT_STATUS_ENABLE_DRAGON_INT_MSB         5
-#define INT_STATUS_ENABLE_DRAGON_INT_LSB         5
-#define INT_STATUS_ENABLE_DRAGON_INT_MASK        0x00000020
-#define INT_STATUS_ENABLE_DRAGON_INT_GET(x)      (((x) & INT_STATUS_ENABLE_DRAGON_INT_MASK) >> INT_STATUS_ENABLE_DRAGON_INT_LSB)
-#define INT_STATUS_ENABLE_DRAGON_INT_SET(x)      (((x) << INT_STATUS_ENABLE_DRAGON_INT_LSB) & INT_STATUS_ENABLE_DRAGON_INT_MASK)
-#define INT_STATUS_ENABLE_COUNTER_MSB            4
-#define INT_STATUS_ENABLE_COUNTER_LSB            4
-#define INT_STATUS_ENABLE_COUNTER_MASK           0x00000010
-#define INT_STATUS_ENABLE_COUNTER_GET(x)         (((x) & INT_STATUS_ENABLE_COUNTER_MASK) >> INT_STATUS_ENABLE_COUNTER_LSB)
-#define INT_STATUS_ENABLE_COUNTER_SET(x)         (((x) << INT_STATUS_ENABLE_COUNTER_LSB) & INT_STATUS_ENABLE_COUNTER_MASK)
-#define INT_STATUS_ENABLE_MBOX_DATA_MSB          3
-#define INT_STATUS_ENABLE_MBOX_DATA_LSB          0
-#define INT_STATUS_ENABLE_MBOX_DATA_MASK         0x0000000f
-#define INT_STATUS_ENABLE_MBOX_DATA_GET(x)       (((x) & INT_STATUS_ENABLE_MBOX_DATA_MASK) >> INT_STATUS_ENABLE_MBOX_DATA_LSB)
-#define INT_STATUS_ENABLE_MBOX_DATA_SET(x)       (((x) << INT_STATUS_ENABLE_MBOX_DATA_LSB) & INT_STATUS_ENABLE_MBOX_DATA_MASK)
-
-#define CPU_INT_STATUS_ENABLE_ADDRESS            0x00000419
-#define CPU_INT_STATUS_ENABLE_OFFSET             0x00000419
-#define CPU_INT_STATUS_ENABLE_BIT_MSB            7
-#define CPU_INT_STATUS_ENABLE_BIT_LSB            0
-#define CPU_INT_STATUS_ENABLE_BIT_MASK           0x000000ff
-#define CPU_INT_STATUS_ENABLE_BIT_GET(x)         (((x) & CPU_INT_STATUS_ENABLE_BIT_MASK) >> CPU_INT_STATUS_ENABLE_BIT_LSB)
-#define CPU_INT_STATUS_ENABLE_BIT_SET(x)         (((x) << CPU_INT_STATUS_ENABLE_BIT_LSB) & CPU_INT_STATUS_ENABLE_BIT_MASK)
-
-#define ERROR_STATUS_ENABLE_ADDRESS              0x0000041a
-#define ERROR_STATUS_ENABLE_OFFSET               0x0000041a
-#define ERROR_STATUS_ENABLE_WAKEUP_MSB           2
-#define ERROR_STATUS_ENABLE_WAKEUP_LSB           2
-#define ERROR_STATUS_ENABLE_WAKEUP_MASK          0x00000004
-#define ERROR_STATUS_ENABLE_WAKEUP_GET(x)        (((x) & ERROR_STATUS_ENABLE_WAKEUP_MASK) >> ERROR_STATUS_ENABLE_WAKEUP_LSB)
-#define ERROR_STATUS_ENABLE_WAKEUP_SET(x)        (((x) << ERROR_STATUS_ENABLE_WAKEUP_LSB) & ERROR_STATUS_ENABLE_WAKEUP_MASK)
-#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_MSB     1
-#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB     1
-#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK    0x00000002
-#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_GET(x)  (((x) & ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK) >> ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB)
-#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_SET(x)  (((x) << ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB) & ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK)
-#define ERROR_STATUS_ENABLE_TX_OVERFLOW_MSB      0
-#define ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB      0
-#define ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK     0x00000001
-#define ERROR_STATUS_ENABLE_TX_OVERFLOW_GET(x)   (((x) & ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK) >> ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB)
-#define ERROR_STATUS_ENABLE_TX_OVERFLOW_SET(x)   (((x) << ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB) & ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK)
-
-#define COUNTER_INT_STATUS_ENABLE_ADDRESS        0x0000041b
-#define COUNTER_INT_STATUS_ENABLE_OFFSET         0x0000041b
-#define COUNTER_INT_STATUS_ENABLE_BIT_MSB        7
-#define COUNTER_INT_STATUS_ENABLE_BIT_LSB        0
-#define COUNTER_INT_STATUS_ENABLE_BIT_MASK       0x000000ff
-#define COUNTER_INT_STATUS_ENABLE_BIT_GET(x)     (((x) & COUNTER_INT_STATUS_ENABLE_BIT_MASK) >> COUNTER_INT_STATUS_ENABLE_BIT_LSB)
-#define COUNTER_INT_STATUS_ENABLE_BIT_SET(x)     (((x) << COUNTER_INT_STATUS_ENABLE_BIT_LSB) & COUNTER_INT_STATUS_ENABLE_BIT_MASK)
-
-#define COUNT_ADDRESS                            0x00000420
-#define COUNT_OFFSET                             0x00000420
-#define COUNT_VALUE_MSB                          7
-#define COUNT_VALUE_LSB                          0
-#define COUNT_VALUE_MASK                         0x000000ff
-#define COUNT_VALUE_GET(x)                       (((x) & COUNT_VALUE_MASK) >> COUNT_VALUE_LSB)
-#define COUNT_VALUE_SET(x)                       (((x) << COUNT_VALUE_LSB) & COUNT_VALUE_MASK)
-
-#define COUNT_DEC_ADDRESS                        0x00000440
-#define COUNT_DEC_OFFSET                         0x00000440
-#define COUNT_DEC_VALUE_MSB                      7
-#define COUNT_DEC_VALUE_LSB                      0
-#define COUNT_DEC_VALUE_MASK                     0x000000ff
-#define COUNT_DEC_VALUE_GET(x)                   (((x) & COUNT_DEC_VALUE_MASK) >> COUNT_DEC_VALUE_LSB)
-#define COUNT_DEC_VALUE_SET(x)                   (((x) << COUNT_DEC_VALUE_LSB) & COUNT_DEC_VALUE_MASK)
-
-#define SCRATCH_ADDRESS                          0x00000460
-#define SCRATCH_OFFSET                           0x00000460
-#define SCRATCH_VALUE_MSB                        7
-#define SCRATCH_VALUE_LSB                        0
-#define SCRATCH_VALUE_MASK                       0x000000ff
-#define SCRATCH_VALUE_GET(x)                     (((x) & SCRATCH_VALUE_MASK) >> SCRATCH_VALUE_LSB)
-#define SCRATCH_VALUE_SET(x)                     (((x) << SCRATCH_VALUE_LSB) & SCRATCH_VALUE_MASK)
-
-#define FIFO_TIMEOUT_ADDRESS                     0x00000468
-#define FIFO_TIMEOUT_OFFSET                      0x00000468
-#define FIFO_TIMEOUT_VALUE_MSB                   7
-#define FIFO_TIMEOUT_VALUE_LSB                   0
-#define FIFO_TIMEOUT_VALUE_MASK                  0x000000ff
-#define FIFO_TIMEOUT_VALUE_GET(x)                (((x) & FIFO_TIMEOUT_VALUE_MASK) >> FIFO_TIMEOUT_VALUE_LSB)
-#define FIFO_TIMEOUT_VALUE_SET(x)                (((x) << FIFO_TIMEOUT_VALUE_LSB) & FIFO_TIMEOUT_VALUE_MASK)
-
-#define FIFO_TIMEOUT_ENABLE_ADDRESS              0x00000469
-#define FIFO_TIMEOUT_ENABLE_OFFSET               0x00000469
-#define FIFO_TIMEOUT_ENABLE_SET_MSB              0
-#define FIFO_TIMEOUT_ENABLE_SET_LSB              0
-#define FIFO_TIMEOUT_ENABLE_SET_MASK             0x00000001
-#define FIFO_TIMEOUT_ENABLE_SET_GET(x)           (((x) & FIFO_TIMEOUT_ENABLE_SET_MASK) >> FIFO_TIMEOUT_ENABLE_SET_LSB)
-#define FIFO_TIMEOUT_ENABLE_SET_SET(x)           (((x) << FIFO_TIMEOUT_ENABLE_SET_LSB) & FIFO_TIMEOUT_ENABLE_SET_MASK)
-
-#define DISABLE_SLEEP_ADDRESS                    0x0000046a
-#define DISABLE_SLEEP_OFFSET                     0x0000046a
-#define DISABLE_SLEEP_FOR_INT_MSB                1
-#define DISABLE_SLEEP_FOR_INT_LSB                1
-#define DISABLE_SLEEP_FOR_INT_MASK               0x00000002
-#define DISABLE_SLEEP_FOR_INT_GET(x)             (((x) & DISABLE_SLEEP_FOR_INT_MASK) >> DISABLE_SLEEP_FOR_INT_LSB)
-#define DISABLE_SLEEP_FOR_INT_SET(x)             (((x) << DISABLE_SLEEP_FOR_INT_LSB) & DISABLE_SLEEP_FOR_INT_MASK)
-#define DISABLE_SLEEP_ON_MSB                     0
-#define DISABLE_SLEEP_ON_LSB                     0
-#define DISABLE_SLEEP_ON_MASK                    0x00000001
-#define DISABLE_SLEEP_ON_GET(x)                  (((x) & DISABLE_SLEEP_ON_MASK) >> DISABLE_SLEEP_ON_LSB)
-#define DISABLE_SLEEP_ON_SET(x)                  (((x) << DISABLE_SLEEP_ON_LSB) & DISABLE_SLEEP_ON_MASK)
-
-#define LOCAL_BUS_ADDRESS                        0x00000470
-#define LOCAL_BUS_OFFSET                         0x00000470
-#define LOCAL_BUS_STATE_MSB                      1
-#define LOCAL_BUS_STATE_LSB                      0
-#define LOCAL_BUS_STATE_MASK                     0x00000003
-#define LOCAL_BUS_STATE_GET(x)                   (((x) & LOCAL_BUS_STATE_MASK) >> LOCAL_BUS_STATE_LSB)
-#define LOCAL_BUS_STATE_SET(x)                   (((x) << LOCAL_BUS_STATE_LSB) & LOCAL_BUS_STATE_MASK)
-
-#define INT_WLAN_ADDRESS                         0x00000472
-#define INT_WLAN_OFFSET                          0x00000472
-#define INT_WLAN_VECTOR_MSB                      7
-#define INT_WLAN_VECTOR_LSB                      0
-#define INT_WLAN_VECTOR_MASK                     0x000000ff
-#define INT_WLAN_VECTOR_GET(x)                   (((x) & INT_WLAN_VECTOR_MASK) >> INT_WLAN_VECTOR_LSB)
-#define INT_WLAN_VECTOR_SET(x)                   (((x) << INT_WLAN_VECTOR_LSB) & INT_WLAN_VECTOR_MASK)
-
-#define WINDOW_DATA_ADDRESS                      0x00000474
-#define WINDOW_DATA_OFFSET                       0x00000474
-#define WINDOW_DATA_DATA_MSB                     7
-#define WINDOW_DATA_DATA_LSB                     0
-#define WINDOW_DATA_DATA_MASK                    0x000000ff
-#define WINDOW_DATA_DATA_GET(x)                  (((x) & WINDOW_DATA_DATA_MASK) >> WINDOW_DATA_DATA_LSB)
-#define WINDOW_DATA_DATA_SET(x)                  (((x) << WINDOW_DATA_DATA_LSB) & WINDOW_DATA_DATA_MASK)
-
-#define WINDOW_WRITE_ADDR_ADDRESS                0x00000478
-#define WINDOW_WRITE_ADDR_OFFSET                 0x00000478
-#define WINDOW_WRITE_ADDR_ADDR_MSB               7
-#define WINDOW_WRITE_ADDR_ADDR_LSB               0
-#define WINDOW_WRITE_ADDR_ADDR_MASK              0x000000ff
-#define WINDOW_WRITE_ADDR_ADDR_GET(x)            (((x) & WINDOW_WRITE_ADDR_ADDR_MASK) >> WINDOW_WRITE_ADDR_ADDR_LSB)
-#define WINDOW_WRITE_ADDR_ADDR_SET(x)            (((x) << WINDOW_WRITE_ADDR_ADDR_LSB) & WINDOW_WRITE_ADDR_ADDR_MASK)
-
-#define WINDOW_READ_ADDR_ADDRESS                 0x0000047c
-#define WINDOW_READ_ADDR_OFFSET                  0x0000047c
-#define WINDOW_READ_ADDR_ADDR_MSB                7
-#define WINDOW_READ_ADDR_ADDR_LSB                0
-#define WINDOW_READ_ADDR_ADDR_MASK               0x000000ff
-#define WINDOW_READ_ADDR_ADDR_GET(x)             (((x) & WINDOW_READ_ADDR_ADDR_MASK) >> WINDOW_READ_ADDR_ADDR_LSB)
-#define WINDOW_READ_ADDR_ADDR_SET(x)             (((x) << WINDOW_READ_ADDR_ADDR_LSB) & WINDOW_READ_ADDR_ADDR_MASK)
-
-#define SPI_CONFIG_ADDRESS                       0x00000480
-#define SPI_CONFIG_OFFSET                        0x00000480
-#define SPI_CONFIG_SPI_RESET_MSB                 4
-#define SPI_CONFIG_SPI_RESET_LSB                 4
-#define SPI_CONFIG_SPI_RESET_MASK                0x00000010
-#define SPI_CONFIG_SPI_RESET_GET(x)              (((x) & SPI_CONFIG_SPI_RESET_MASK) >> SPI_CONFIG_SPI_RESET_LSB)
-#define SPI_CONFIG_SPI_RESET_SET(x)              (((x) << SPI_CONFIG_SPI_RESET_LSB) & SPI_CONFIG_SPI_RESET_MASK)
-#define SPI_CONFIG_INTERRUPT_ENABLE_MSB          3
-#define SPI_CONFIG_INTERRUPT_ENABLE_LSB          3
-#define SPI_CONFIG_INTERRUPT_ENABLE_MASK         0x00000008
-#define SPI_CONFIG_INTERRUPT_ENABLE_GET(x)       (((x) & SPI_CONFIG_INTERRUPT_ENABLE_MASK) >> SPI_CONFIG_INTERRUPT_ENABLE_LSB)
-#define SPI_CONFIG_INTERRUPT_ENABLE_SET(x)       (((x) << SPI_CONFIG_INTERRUPT_ENABLE_LSB) & SPI_CONFIG_INTERRUPT_ENABLE_MASK)
-#define SPI_CONFIG_TEST_MODE_MSB                 2
-#define SPI_CONFIG_TEST_MODE_LSB                 2
-#define SPI_CONFIG_TEST_MODE_MASK                0x00000004
-#define SPI_CONFIG_TEST_MODE_GET(x)              (((x) & SPI_CONFIG_TEST_MODE_MASK) >> SPI_CONFIG_TEST_MODE_LSB)
-#define SPI_CONFIG_TEST_MODE_SET(x)              (((x) << SPI_CONFIG_TEST_MODE_LSB) & SPI_CONFIG_TEST_MODE_MASK)
-#define SPI_CONFIG_DATA_SIZE_MSB                 1
-#define SPI_CONFIG_DATA_SIZE_LSB                 0
-#define SPI_CONFIG_DATA_SIZE_MASK                0x00000003
-#define SPI_CONFIG_DATA_SIZE_GET(x)              (((x) & SPI_CONFIG_DATA_SIZE_MASK) >> SPI_CONFIG_DATA_SIZE_LSB)
-#define SPI_CONFIG_DATA_SIZE_SET(x)              (((x) << SPI_CONFIG_DATA_SIZE_LSB) & SPI_CONFIG_DATA_SIZE_MASK)
-
-#define SPI_STATUS_ADDRESS                       0x00000481
-#define SPI_STATUS_OFFSET                        0x00000481
-#define SPI_STATUS_ADDR_ERR_MSB                  3
-#define SPI_STATUS_ADDR_ERR_LSB                  3
-#define SPI_STATUS_ADDR_ERR_MASK                 0x00000008
-#define SPI_STATUS_ADDR_ERR_GET(x)               (((x) & SPI_STATUS_ADDR_ERR_MASK) >> SPI_STATUS_ADDR_ERR_LSB)
-#define SPI_STATUS_ADDR_ERR_SET(x)               (((x) << SPI_STATUS_ADDR_ERR_LSB) & SPI_STATUS_ADDR_ERR_MASK)
-#define SPI_STATUS_RD_ERR_MSB                    2
-#define SPI_STATUS_RD_ERR_LSB                    2
-#define SPI_STATUS_RD_ERR_MASK                   0x00000004
-#define SPI_STATUS_RD_ERR_GET(x)                 (((x) & SPI_STATUS_RD_ERR_MASK) >> SPI_STATUS_RD_ERR_LSB)
-#define SPI_STATUS_RD_ERR_SET(x)                 (((x) << SPI_STATUS_RD_ERR_LSB) & SPI_STATUS_RD_ERR_MASK)
-#define SPI_STATUS_WR_ERR_MSB                    1
-#define SPI_STATUS_WR_ERR_LSB                    1
-#define SPI_STATUS_WR_ERR_MASK                   0x00000002
-#define SPI_STATUS_WR_ERR_GET(x)                 (((x) & SPI_STATUS_WR_ERR_MASK) >> SPI_STATUS_WR_ERR_LSB)
-#define SPI_STATUS_WR_ERR_SET(x)                 (((x) << SPI_STATUS_WR_ERR_LSB) & SPI_STATUS_WR_ERR_MASK)
-#define SPI_STATUS_READY_MSB                     0
-#define SPI_STATUS_READY_LSB                     0
-#define SPI_STATUS_READY_MASK                    0x00000001
-#define SPI_STATUS_READY_GET(x)                  (((x) & SPI_STATUS_READY_MASK) >> SPI_STATUS_READY_LSB)
-#define SPI_STATUS_READY_SET(x)                  (((x) << SPI_STATUS_READY_LSB) & SPI_STATUS_READY_MASK)
-
-#define NON_ASSOC_SLEEP_EN_ADDRESS               0x00000482
-#define NON_ASSOC_SLEEP_EN_OFFSET                0x00000482
-#define NON_ASSOC_SLEEP_EN_BIT_MSB               0
-#define NON_ASSOC_SLEEP_EN_BIT_LSB               0
-#define NON_ASSOC_SLEEP_EN_BIT_MASK              0x00000001
-#define NON_ASSOC_SLEEP_EN_BIT_GET(x)            (((x) & NON_ASSOC_SLEEP_EN_BIT_MASK) >> NON_ASSOC_SLEEP_EN_BIT_LSB)
-#define NON_ASSOC_SLEEP_EN_BIT_SET(x)            (((x) << NON_ASSOC_SLEEP_EN_BIT_LSB) & NON_ASSOC_SLEEP_EN_BIT_MASK)
-
-#define CIS_WINDOW_ADDRESS                       0x00000600
-#define CIS_WINDOW_OFFSET                        0x00000600
-#define CIS_WINDOW_DATA_MSB                      7
-#define CIS_WINDOW_DATA_LSB                      0
-#define CIS_WINDOW_DATA_MASK                     0x000000ff
-#define CIS_WINDOW_DATA_GET(x)                   (((x) & CIS_WINDOW_DATA_MASK) >> CIS_WINDOW_DATA_LSB)
-#define CIS_WINDOW_DATA_SET(x)                   (((x) << CIS_WINDOW_DATA_LSB) & CIS_WINDOW_DATA_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct mbox_host_reg_reg_s {
-  unsigned char pad0[1024]; /* pad to 0x400 */
-  volatile unsigned char host_int_status;
-  volatile unsigned char cpu_int_status;
-  volatile unsigned char error_int_status;
-  volatile unsigned char counter_int_status;
-  volatile unsigned char mbox_frame;
-  volatile unsigned char rx_lookahead_valid;
-  unsigned char pad1[2]; /* pad to 0x408 */
-  volatile unsigned char rx_lookahead0[4];
-  volatile unsigned char rx_lookahead1[4];
-  volatile unsigned char rx_lookahead2[4];
-  volatile unsigned char rx_lookahead3[4];
-  volatile unsigned char int_status_enable;
-  volatile unsigned char cpu_int_status_enable;
-  volatile unsigned char error_status_enable;
-  volatile unsigned char counter_int_status_enable;
-  unsigned char pad2[4]; /* pad to 0x420 */
-  volatile unsigned char count[8];
-  unsigned char pad3[24]; /* pad to 0x440 */
-  volatile unsigned char count_dec[32];
-  volatile unsigned char scratch[8];
-  volatile unsigned char fifo_timeout;
-  volatile unsigned char fifo_timeout_enable;
-  volatile unsigned char disable_sleep;
-  unsigned char pad4[5]; /* pad to 0x470 */
-  volatile unsigned char local_bus;
-  unsigned char pad5[1]; /* pad to 0x472 */
-  volatile unsigned char int_wlan;
-  unsigned char pad6[1]; /* pad to 0x474 */
-  volatile unsigned char window_data[4];
-  volatile unsigned char window_write_addr[4];
-  volatile unsigned char window_read_addr[4];
-  volatile unsigned char spi_config;
-  volatile unsigned char spi_status;
-  volatile unsigned char non_assoc_sleep_en;
-  unsigned char pad7[381]; /* pad to 0x600 */
-  volatile unsigned char cis_window[512];
-} mbox_host_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _MBOX_HOST_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h
deleted file mode 100644
index 4e07d22..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h
+++ /dev/null
@@ -1,481 +0,0 @@
-#ifndef _MBOX_REG_REG_H_
-#define _MBOX_REG_REG_H_
-
-#define MBOX_FIFO_ADDRESS                        0x00000000
-#define MBOX_FIFO_OFFSET                         0x00000000
-#define MBOX_FIFO_DATA_MSB                       19
-#define MBOX_FIFO_DATA_LSB                       0
-#define MBOX_FIFO_DATA_MASK                      0x000fffff
-#define MBOX_FIFO_DATA_GET(x)                    (((x) & MBOX_FIFO_DATA_MASK) >> MBOX_FIFO_DATA_LSB)
-#define MBOX_FIFO_DATA_SET(x)                    (((x) << MBOX_FIFO_DATA_LSB) & MBOX_FIFO_DATA_MASK)
-
-#define MBOX_FIFO_STATUS_ADDRESS                 0x00000010
-#define MBOX_FIFO_STATUS_OFFSET                  0x00000010
-#define MBOX_FIFO_STATUS_EMPTY_MSB               19
-#define MBOX_FIFO_STATUS_EMPTY_LSB               16
-#define MBOX_FIFO_STATUS_EMPTY_MASK              0x000f0000
-#define MBOX_FIFO_STATUS_EMPTY_GET(x)            (((x) & MBOX_FIFO_STATUS_EMPTY_MASK) >> MBOX_FIFO_STATUS_EMPTY_LSB)
-#define MBOX_FIFO_STATUS_EMPTY_SET(x)            (((x) << MBOX_FIFO_STATUS_EMPTY_LSB) & MBOX_FIFO_STATUS_EMPTY_MASK)
-#define MBOX_FIFO_STATUS_FULL_MSB                15
-#define MBOX_FIFO_STATUS_FULL_LSB                12
-#define MBOX_FIFO_STATUS_FULL_MASK               0x0000f000
-#define MBOX_FIFO_STATUS_FULL_GET(x)             (((x) & MBOX_FIFO_STATUS_FULL_MASK) >> MBOX_FIFO_STATUS_FULL_LSB)
-#define MBOX_FIFO_STATUS_FULL_SET(x)             (((x) << MBOX_FIFO_STATUS_FULL_LSB) & MBOX_FIFO_STATUS_FULL_MASK)
-
-#define MBOX_DMA_POLICY_ADDRESS                  0x00000014
-#define MBOX_DMA_POLICY_OFFSET                   0x00000014
-#define MBOX_DMA_POLICY_TX_QUANTUM_MSB           3
-#define MBOX_DMA_POLICY_TX_QUANTUM_LSB           3
-#define MBOX_DMA_POLICY_TX_QUANTUM_MASK          0x00000008
-#define MBOX_DMA_POLICY_TX_QUANTUM_GET(x)        (((x) & MBOX_DMA_POLICY_TX_QUANTUM_MASK) >> MBOX_DMA_POLICY_TX_QUANTUM_LSB)
-#define MBOX_DMA_POLICY_TX_QUANTUM_SET(x)        (((x) << MBOX_DMA_POLICY_TX_QUANTUM_LSB) & MBOX_DMA_POLICY_TX_QUANTUM_MASK)
-#define MBOX_DMA_POLICY_TX_ORDER_MSB             2
-#define MBOX_DMA_POLICY_TX_ORDER_LSB             2
-#define MBOX_DMA_POLICY_TX_ORDER_MASK            0x00000004
-#define MBOX_DMA_POLICY_TX_ORDER_GET(x)          (((x) & MBOX_DMA_POLICY_TX_ORDER_MASK) >> MBOX_DMA_POLICY_TX_ORDER_LSB)
-#define MBOX_DMA_POLICY_TX_ORDER_SET(x)          (((x) << MBOX_DMA_POLICY_TX_ORDER_LSB) & MBOX_DMA_POLICY_TX_ORDER_MASK)
-#define MBOX_DMA_POLICY_RX_QUANTUM_MSB           1
-#define MBOX_DMA_POLICY_RX_QUANTUM_LSB           1
-#define MBOX_DMA_POLICY_RX_QUANTUM_MASK          0x00000002
-#define MBOX_DMA_POLICY_RX_QUANTUM_GET(x)        (((x) & MBOX_DMA_POLICY_RX_QUANTUM_MASK) >> MBOX_DMA_POLICY_RX_QUANTUM_LSB)
-#define MBOX_DMA_POLICY_RX_QUANTUM_SET(x)        (((x) << MBOX_DMA_POLICY_RX_QUANTUM_LSB) & MBOX_DMA_POLICY_RX_QUANTUM_MASK)
-#define MBOX_DMA_POLICY_RX_ORDER_MSB             0
-#define MBOX_DMA_POLICY_RX_ORDER_LSB             0
-#define MBOX_DMA_POLICY_RX_ORDER_MASK            0x00000001
-#define MBOX_DMA_POLICY_RX_ORDER_GET(x)          (((x) & MBOX_DMA_POLICY_RX_ORDER_MASK) >> MBOX_DMA_POLICY_RX_ORDER_LSB)
-#define MBOX_DMA_POLICY_RX_ORDER_SET(x)          (((x) << MBOX_DMA_POLICY_RX_ORDER_LSB) & MBOX_DMA_POLICY_RX_ORDER_MASK)
-
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000018
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000018
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX0_DMA_RX_CONTROL_ADDRESS             0x0000001c
-#define MBOX0_DMA_RX_CONTROL_OFFSET              0x0000001c
-#define MBOX0_DMA_RX_CONTROL_RESUME_MSB          2
-#define MBOX0_DMA_RX_CONTROL_RESUME_LSB          2
-#define MBOX0_DMA_RX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX0_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX0_DMA_RX_CONTROL_RESUME_MASK) >> MBOX0_DMA_RX_CONTROL_RESUME_LSB)
-#define MBOX0_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX0_DMA_RX_CONTROL_RESUME_LSB) & MBOX0_DMA_RX_CONTROL_RESUME_MASK)
-#define MBOX0_DMA_RX_CONTROL_START_MSB           1
-#define MBOX0_DMA_RX_CONTROL_START_LSB           1
-#define MBOX0_DMA_RX_CONTROL_START_MASK          0x00000002
-#define MBOX0_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX0_DMA_RX_CONTROL_START_MASK) >> MBOX0_DMA_RX_CONTROL_START_LSB)
-#define MBOX0_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX0_DMA_RX_CONTROL_START_LSB) & MBOX0_DMA_RX_CONTROL_START_MASK)
-#define MBOX0_DMA_RX_CONTROL_STOP_MSB            0
-#define MBOX0_DMA_RX_CONTROL_STOP_LSB            0
-#define MBOX0_DMA_RX_CONTROL_STOP_MASK           0x00000001
-#define MBOX0_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX0_DMA_RX_CONTROL_STOP_MASK) >> MBOX0_DMA_RX_CONTROL_STOP_LSB)
-#define MBOX0_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX0_DMA_RX_CONTROL_STOP_LSB) & MBOX0_DMA_RX_CONTROL_STOP_MASK)
-
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000020
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000020
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX0_DMA_TX_CONTROL_ADDRESS             0x00000024
-#define MBOX0_DMA_TX_CONTROL_OFFSET              0x00000024
-#define MBOX0_DMA_TX_CONTROL_RESUME_MSB          2
-#define MBOX0_DMA_TX_CONTROL_RESUME_LSB          2
-#define MBOX0_DMA_TX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX0_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX0_DMA_TX_CONTROL_RESUME_MASK) >> MBOX0_DMA_TX_CONTROL_RESUME_LSB)
-#define MBOX0_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX0_DMA_TX_CONTROL_RESUME_LSB) & MBOX0_DMA_TX_CONTROL_RESUME_MASK)
-#define MBOX0_DMA_TX_CONTROL_START_MSB           1
-#define MBOX0_DMA_TX_CONTROL_START_LSB           1
-#define MBOX0_DMA_TX_CONTROL_START_MASK          0x00000002
-#define MBOX0_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX0_DMA_TX_CONTROL_START_MASK) >> MBOX0_DMA_TX_CONTROL_START_LSB)
-#define MBOX0_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX0_DMA_TX_CONTROL_START_LSB) & MBOX0_DMA_TX_CONTROL_START_MASK)
-#define MBOX0_DMA_TX_CONTROL_STOP_MSB            0
-#define MBOX0_DMA_TX_CONTROL_STOP_LSB            0
-#define MBOX0_DMA_TX_CONTROL_STOP_MASK           0x00000001
-#define MBOX0_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX0_DMA_TX_CONTROL_STOP_MASK) >> MBOX0_DMA_TX_CONTROL_STOP_LSB)
-#define MBOX0_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX0_DMA_TX_CONTROL_STOP_LSB) & MBOX0_DMA_TX_CONTROL_STOP_MASK)
-
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000028
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000028
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX1_DMA_RX_CONTROL_ADDRESS             0x0000002c
-#define MBOX1_DMA_RX_CONTROL_OFFSET              0x0000002c
-#define MBOX1_DMA_RX_CONTROL_RESUME_MSB          2
-#define MBOX1_DMA_RX_CONTROL_RESUME_LSB          2
-#define MBOX1_DMA_RX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX1_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX1_DMA_RX_CONTROL_RESUME_MASK) >> MBOX1_DMA_RX_CONTROL_RESUME_LSB)
-#define MBOX1_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX1_DMA_RX_CONTROL_RESUME_LSB) & MBOX1_DMA_RX_CONTROL_RESUME_MASK)
-#define MBOX1_DMA_RX_CONTROL_START_MSB           1
-#define MBOX1_DMA_RX_CONTROL_START_LSB           1
-#define MBOX1_DMA_RX_CONTROL_START_MASK          0x00000002
-#define MBOX1_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX1_DMA_RX_CONTROL_START_MASK) >> MBOX1_DMA_RX_CONTROL_START_LSB)
-#define MBOX1_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX1_DMA_RX_CONTROL_START_LSB) & MBOX1_DMA_RX_CONTROL_START_MASK)
-#define MBOX1_DMA_RX_CONTROL_STOP_MSB            0
-#define MBOX1_DMA_RX_CONTROL_STOP_LSB            0
-#define MBOX1_DMA_RX_CONTROL_STOP_MASK           0x00000001
-#define MBOX1_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX1_DMA_RX_CONTROL_STOP_MASK) >> MBOX1_DMA_RX_CONTROL_STOP_LSB)
-#define MBOX1_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX1_DMA_RX_CONTROL_STOP_LSB) & MBOX1_DMA_RX_CONTROL_STOP_MASK)
-
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000030
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000030
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX1_DMA_TX_CONTROL_ADDRESS             0x00000034
-#define MBOX1_DMA_TX_CONTROL_OFFSET              0x00000034
-#define MBOX1_DMA_TX_CONTROL_RESUME_MSB          2
-#define MBOX1_DMA_TX_CONTROL_RESUME_LSB          2
-#define MBOX1_DMA_TX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX1_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX1_DMA_TX_CONTROL_RESUME_MASK) >> MBOX1_DMA_TX_CONTROL_RESUME_LSB)
-#define MBOX1_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX1_DMA_TX_CONTROL_RESUME_LSB) & MBOX1_DMA_TX_CONTROL_RESUME_MASK)
-#define MBOX1_DMA_TX_CONTROL_START_MSB           1
-#define MBOX1_DMA_TX_CONTROL_START_LSB           1
-#define MBOX1_DMA_TX_CONTROL_START_MASK          0x00000002
-#define MBOX1_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX1_DMA_TX_CONTROL_START_MASK) >> MBOX1_DMA_TX_CONTROL_START_LSB)
-#define MBOX1_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX1_DMA_TX_CONTROL_START_LSB) & MBOX1_DMA_TX_CONTROL_START_MASK)
-#define MBOX1_DMA_TX_CONTROL_STOP_MSB            0
-#define MBOX1_DMA_TX_CONTROL_STOP_LSB            0
-#define MBOX1_DMA_TX_CONTROL_STOP_MASK           0x00000001
-#define MBOX1_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX1_DMA_TX_CONTROL_STOP_MASK) >> MBOX1_DMA_TX_CONTROL_STOP_LSB)
-#define MBOX1_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX1_DMA_TX_CONTROL_STOP_LSB) & MBOX1_DMA_TX_CONTROL_STOP_MASK)
-
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000038
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000038
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX2_DMA_RX_CONTROL_ADDRESS             0x0000003c
-#define MBOX2_DMA_RX_CONTROL_OFFSET              0x0000003c
-#define MBOX2_DMA_RX_CONTROL_RESUME_MSB          2
-#define MBOX2_DMA_RX_CONTROL_RESUME_LSB          2
-#define MBOX2_DMA_RX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX2_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX2_DMA_RX_CONTROL_RESUME_MASK) >> MBOX2_DMA_RX_CONTROL_RESUME_LSB)
-#define MBOX2_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX2_DMA_RX_CONTROL_RESUME_LSB) & MBOX2_DMA_RX_CONTROL_RESUME_MASK)
-#define MBOX2_DMA_RX_CONTROL_START_MSB           1
-#define MBOX2_DMA_RX_CONTROL_START_LSB           1
-#define MBOX2_DMA_RX_CONTROL_START_MASK          0x00000002
-#define MBOX2_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX2_DMA_RX_CONTROL_START_MASK) >> MBOX2_DMA_RX_CONTROL_START_LSB)
-#define MBOX2_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX2_DMA_RX_CONTROL_START_LSB) & MBOX2_DMA_RX_CONTROL_START_MASK)
-#define MBOX2_DMA_RX_CONTROL_STOP_MSB            0
-#define MBOX2_DMA_RX_CONTROL_STOP_LSB            0
-#define MBOX2_DMA_RX_CONTROL_STOP_MASK           0x00000001
-#define MBOX2_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX2_DMA_RX_CONTROL_STOP_MASK) >> MBOX2_DMA_RX_CONTROL_STOP_LSB)
-#define MBOX2_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX2_DMA_RX_CONTROL_STOP_LSB) & MBOX2_DMA_RX_CONTROL_STOP_MASK)
-
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000040
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000040
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX2_DMA_TX_CONTROL_ADDRESS             0x00000044
-#define MBOX2_DMA_TX_CONTROL_OFFSET              0x00000044
-#define MBOX2_DMA_TX_CONTROL_RESUME_MSB          2
-#define MBOX2_DMA_TX_CONTROL_RESUME_LSB          2
-#define MBOX2_DMA_TX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX2_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX2_DMA_TX_CONTROL_RESUME_MASK) >> MBOX2_DMA_TX_CONTROL_RESUME_LSB)
-#define MBOX2_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX2_DMA_TX_CONTROL_RESUME_LSB) & MBOX2_DMA_TX_CONTROL_RESUME_MASK)
-#define MBOX2_DMA_TX_CONTROL_START_MSB           1
-#define MBOX2_DMA_TX_CONTROL_START_LSB           1
-#define MBOX2_DMA_TX_CONTROL_START_MASK          0x00000002
-#define MBOX2_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX2_DMA_TX_CONTROL_START_MASK) >> MBOX2_DMA_TX_CONTROL_START_LSB)
-#define MBOX2_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX2_DMA_TX_CONTROL_START_LSB) & MBOX2_DMA_TX_CONTROL_START_MASK)
-#define MBOX2_DMA_TX_CONTROL_STOP_MSB            0
-#define MBOX2_DMA_TX_CONTROL_STOP_LSB            0
-#define MBOX2_DMA_TX_CONTROL_STOP_MASK           0x00000001
-#define MBOX2_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX2_DMA_TX_CONTROL_STOP_MASK) >> MBOX2_DMA_TX_CONTROL_STOP_LSB)
-#define MBOX2_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX2_DMA_TX_CONTROL_STOP_LSB) & MBOX2_DMA_TX_CONTROL_STOP_MASK)
-
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000048
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000048
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX3_DMA_RX_CONTROL_ADDRESS             0x0000004c
-#define MBOX3_DMA_RX_CONTROL_OFFSET              0x0000004c
-#define MBOX3_DMA_RX_CONTROL_RESUME_MSB          2
-#define MBOX3_DMA_RX_CONTROL_RESUME_LSB          2
-#define MBOX3_DMA_RX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX3_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX3_DMA_RX_CONTROL_RESUME_MASK) >> MBOX3_DMA_RX_CONTROL_RESUME_LSB)
-#define MBOX3_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX3_DMA_RX_CONTROL_RESUME_LSB) & MBOX3_DMA_RX_CONTROL_RESUME_MASK)
-#define MBOX3_DMA_RX_CONTROL_START_MSB           1
-#define MBOX3_DMA_RX_CONTROL_START_LSB           1
-#define MBOX3_DMA_RX_CONTROL_START_MASK          0x00000002
-#define MBOX3_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX3_DMA_RX_CONTROL_START_MASK) >> MBOX3_DMA_RX_CONTROL_START_LSB)
-#define MBOX3_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX3_DMA_RX_CONTROL_START_LSB) & MBOX3_DMA_RX_CONTROL_START_MASK)
-#define MBOX3_DMA_RX_CONTROL_STOP_MSB            0
-#define MBOX3_DMA_RX_CONTROL_STOP_LSB            0
-#define MBOX3_DMA_RX_CONTROL_STOP_MASK           0x00000001
-#define MBOX3_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX3_DMA_RX_CONTROL_STOP_MASK) >> MBOX3_DMA_RX_CONTROL_STOP_LSB)
-#define MBOX3_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX3_DMA_RX_CONTROL_STOP_LSB) & MBOX3_DMA_RX_CONTROL_STOP_MASK)
-
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000050
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000050
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
-#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
-
-#define MBOX3_DMA_TX_CONTROL_ADDRESS             0x00000054
-#define MBOX3_DMA_TX_CONTROL_OFFSET              0x00000054
-#define MBOX3_DMA_TX_CONTROL_RESUME_MSB          2
-#define MBOX3_DMA_TX_CONTROL_RESUME_LSB          2
-#define MBOX3_DMA_TX_CONTROL_RESUME_MASK         0x00000004
-#define MBOX3_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX3_DMA_TX_CONTROL_RESUME_MASK) >> MBOX3_DMA_TX_CONTROL_RESUME_LSB)
-#define MBOX3_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX3_DMA_TX_CONTROL_RESUME_LSB) & MBOX3_DMA_TX_CONTROL_RESUME_MASK)
-#define MBOX3_DMA_TX_CONTROL_START_MSB           1
-#define MBOX3_DMA_TX_CONTROL_START_LSB           1
-#define MBOX3_DMA_TX_CONTROL_START_MASK          0x00000002
-#define MBOX3_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX3_DMA_TX_CONTROL_START_MASK) >> MBOX3_DMA_TX_CONTROL_START_LSB)
-#define MBOX3_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX3_DMA_TX_CONTROL_START_LSB) & MBOX3_DMA_TX_CONTROL_START_MASK)
-#define MBOX3_DMA_TX_CONTROL_STOP_MSB            0
-#define MBOX3_DMA_TX_CONTROL_STOP_LSB            0
-#define MBOX3_DMA_TX_CONTROL_STOP_MASK           0x00000001
-#define MBOX3_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX3_DMA_TX_CONTROL_STOP_MASK) >> MBOX3_DMA_TX_CONTROL_STOP_LSB)
-#define MBOX3_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX3_DMA_TX_CONTROL_STOP_LSB) & MBOX3_DMA_TX_CONTROL_STOP_MASK)
-
-#define MBOX_INT_STATUS_ADDRESS                  0x00000058
-#define MBOX_INT_STATUS_OFFSET                   0x00000058
-#define MBOX_INT_STATUS_RX_DMA_COMPLETE_MSB      31
-#define MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB      28
-#define MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK     0xf0000000
-#define MBOX_INT_STATUS_RX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK) >> MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB)
-#define MBOX_INT_STATUS_RX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB) & MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK)
-#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MSB  27
-#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB  24
-#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK 0x0f000000
-#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_GET(x) (((x) & MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK) >> MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB)
-#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_SET(x) (((x) << MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB) & MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK)
-#define MBOX_INT_STATUS_TX_DMA_COMPLETE_MSB      23
-#define MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB      20
-#define MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK     0x00f00000
-#define MBOX_INT_STATUS_TX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK) >> MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB)
-#define MBOX_INT_STATUS_TX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB) & MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK)
-#define MBOX_INT_STATUS_TX_OVERFLOW_MSB          17
-#define MBOX_INT_STATUS_TX_OVERFLOW_LSB          17
-#define MBOX_INT_STATUS_TX_OVERFLOW_MASK         0x00020000
-#define MBOX_INT_STATUS_TX_OVERFLOW_GET(x)       (((x) & MBOX_INT_STATUS_TX_OVERFLOW_MASK) >> MBOX_INT_STATUS_TX_OVERFLOW_LSB)
-#define MBOX_INT_STATUS_TX_OVERFLOW_SET(x)       (((x) << MBOX_INT_STATUS_TX_OVERFLOW_LSB) & MBOX_INT_STATUS_TX_OVERFLOW_MASK)
-#define MBOX_INT_STATUS_RX_UNDERFLOW_MSB         16
-#define MBOX_INT_STATUS_RX_UNDERFLOW_LSB         16
-#define MBOX_INT_STATUS_RX_UNDERFLOW_MASK        0x00010000
-#define MBOX_INT_STATUS_RX_UNDERFLOW_GET(x)      (((x) & MBOX_INT_STATUS_RX_UNDERFLOW_MASK) >> MBOX_INT_STATUS_RX_UNDERFLOW_LSB)
-#define MBOX_INT_STATUS_RX_UNDERFLOW_SET(x)      (((x) << MBOX_INT_STATUS_RX_UNDERFLOW_LSB) & MBOX_INT_STATUS_RX_UNDERFLOW_MASK)
-#define MBOX_INT_STATUS_TX_NOT_EMPTY_MSB         15
-#define MBOX_INT_STATUS_TX_NOT_EMPTY_LSB         12
-#define MBOX_INT_STATUS_TX_NOT_EMPTY_MASK        0x0000f000
-#define MBOX_INT_STATUS_TX_NOT_EMPTY_GET(x)      (((x) & MBOX_INT_STATUS_TX_NOT_EMPTY_MASK) >> MBOX_INT_STATUS_TX_NOT_EMPTY_LSB)
-#define MBOX_INT_STATUS_TX_NOT_EMPTY_SET(x)      (((x) << MBOX_INT_STATUS_TX_NOT_EMPTY_LSB) & MBOX_INT_STATUS_TX_NOT_EMPTY_MASK)
-#define MBOX_INT_STATUS_RX_NOT_FULL_MSB          11
-#define MBOX_INT_STATUS_RX_NOT_FULL_LSB          8
-#define MBOX_INT_STATUS_RX_NOT_FULL_MASK         0x00000f00
-#define MBOX_INT_STATUS_RX_NOT_FULL_GET(x)       (((x) & MBOX_INT_STATUS_RX_NOT_FULL_MASK) >> MBOX_INT_STATUS_RX_NOT_FULL_LSB)
-#define MBOX_INT_STATUS_RX_NOT_FULL_SET(x)       (((x) << MBOX_INT_STATUS_RX_NOT_FULL_LSB) & MBOX_INT_STATUS_RX_NOT_FULL_MASK)
-#define MBOX_INT_STATUS_HOST_MSB                 7
-#define MBOX_INT_STATUS_HOST_LSB                 0
-#define MBOX_INT_STATUS_HOST_MASK                0x000000ff
-#define MBOX_INT_STATUS_HOST_GET(x)              (((x) & MBOX_INT_STATUS_HOST_MASK) >> MBOX_INT_STATUS_HOST_LSB)
-#define MBOX_INT_STATUS_HOST_SET(x)              (((x) << MBOX_INT_STATUS_HOST_LSB) & MBOX_INT_STATUS_HOST_MASK)
-
-#define MBOX_INT_ENABLE_ADDRESS                  0x0000005c
-#define MBOX_INT_ENABLE_OFFSET                   0x0000005c
-#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_MSB      31
-#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB      28
-#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK     0xf0000000
-#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK) >> MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB)
-#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB) & MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK)
-#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MSB  27
-#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB  24
-#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK 0x0f000000
-#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_GET(x) (((x) & MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK) >> MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB)
-#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_SET(x) (((x) << MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB) & MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK)
-#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_MSB      23
-#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB      20
-#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK     0x00f00000
-#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK) >> MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB)
-#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB) & MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK)
-#define MBOX_INT_ENABLE_TX_OVERFLOW_MSB          17
-#define MBOX_INT_ENABLE_TX_OVERFLOW_LSB          17
-#define MBOX_INT_ENABLE_TX_OVERFLOW_MASK         0x00020000
-#define MBOX_INT_ENABLE_TX_OVERFLOW_GET(x)       (((x) & MBOX_INT_ENABLE_TX_OVERFLOW_MASK) >> MBOX_INT_ENABLE_TX_OVERFLOW_LSB)
-#define MBOX_INT_ENABLE_TX_OVERFLOW_SET(x)       (((x) << MBOX_INT_ENABLE_TX_OVERFLOW_LSB) & MBOX_INT_ENABLE_TX_OVERFLOW_MASK)
-#define MBOX_INT_ENABLE_RX_UNDERFLOW_MSB         16
-#define MBOX_INT_ENABLE_RX_UNDERFLOW_LSB         16
-#define MBOX_INT_ENABLE_RX_UNDERFLOW_MASK        0x00010000
-#define MBOX_INT_ENABLE_RX_UNDERFLOW_GET(x)      (((x) & MBOX_INT_ENABLE_RX_UNDERFLOW_MASK) >> MBOX_INT_ENABLE_RX_UNDERFLOW_LSB)
-#define MBOX_INT_ENABLE_RX_UNDERFLOW_SET(x)      (((x) << MBOX_INT_ENABLE_RX_UNDERFLOW_LSB) & MBOX_INT_ENABLE_RX_UNDERFLOW_MASK)
-#define MBOX_INT_ENABLE_TX_NOT_EMPTY_MSB         15
-#define MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB         12
-#define MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK        0x0000f000
-#define MBOX_INT_ENABLE_TX_NOT_EMPTY_GET(x)      (((x) & MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK) >> MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB)
-#define MBOX_INT_ENABLE_TX_NOT_EMPTY_SET(x)      (((x) << MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB) & MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK)
-#define MBOX_INT_ENABLE_RX_NOT_FULL_MSB          11
-#define MBOX_INT_ENABLE_RX_NOT_FULL_LSB          8
-#define MBOX_INT_ENABLE_RX_NOT_FULL_MASK         0x00000f00
-#define MBOX_INT_ENABLE_RX_NOT_FULL_GET(x)       (((x) & MBOX_INT_ENABLE_RX_NOT_FULL_MASK) >> MBOX_INT_ENABLE_RX_NOT_FULL_LSB)
-#define MBOX_INT_ENABLE_RX_NOT_FULL_SET(x)       (((x) << MBOX_INT_ENABLE_RX_NOT_FULL_LSB) & MBOX_INT_ENABLE_RX_NOT_FULL_MASK)
-#define MBOX_INT_ENABLE_HOST_MSB                 7
-#define MBOX_INT_ENABLE_HOST_LSB                 0
-#define MBOX_INT_ENABLE_HOST_MASK                0x000000ff
-#define MBOX_INT_ENABLE_HOST_GET(x)              (((x) & MBOX_INT_ENABLE_HOST_MASK) >> MBOX_INT_ENABLE_HOST_LSB)
-#define MBOX_INT_ENABLE_HOST_SET(x)              (((x) << MBOX_INT_ENABLE_HOST_LSB) & MBOX_INT_ENABLE_HOST_MASK)
-
-#define INT_HOST_ADDRESS                         0x00000060
-#define INT_HOST_OFFSET                          0x00000060
-#define INT_HOST_VECTOR_MSB                      7
-#define INT_HOST_VECTOR_LSB                      0
-#define INT_HOST_VECTOR_MASK                     0x000000ff
-#define INT_HOST_VECTOR_GET(x)                   (((x) & INT_HOST_VECTOR_MASK) >> INT_HOST_VECTOR_LSB)
-#define INT_HOST_VECTOR_SET(x)                   (((x) << INT_HOST_VECTOR_LSB) & INT_HOST_VECTOR_MASK)
-
-#define LOCAL_COUNT_ADDRESS                      0x00000080
-#define LOCAL_COUNT_OFFSET                       0x00000080
-#define LOCAL_COUNT_VALUE_MSB                    7
-#define LOCAL_COUNT_VALUE_LSB                    0
-#define LOCAL_COUNT_VALUE_MASK                   0x000000ff
-#define LOCAL_COUNT_VALUE_GET(x)                 (((x) & LOCAL_COUNT_VALUE_MASK) >> LOCAL_COUNT_VALUE_LSB)
-#define LOCAL_COUNT_VALUE_SET(x)                 (((x) << LOCAL_COUNT_VALUE_LSB) & LOCAL_COUNT_VALUE_MASK)
-
-#define COUNT_INC_ADDRESS                        0x000000a0
-#define COUNT_INC_OFFSET                         0x000000a0
-#define COUNT_INC_VALUE_MSB                      7
-#define COUNT_INC_VALUE_LSB                      0
-#define COUNT_INC_VALUE_MASK                     0x000000ff
-#define COUNT_INC_VALUE_GET(x)                   (((x) & COUNT_INC_VALUE_MASK) >> COUNT_INC_VALUE_LSB)
-#define COUNT_INC_VALUE_SET(x)                   (((x) << COUNT_INC_VALUE_LSB) & COUNT_INC_VALUE_MASK)
-
-#define LOCAL_SCRATCH_ADDRESS                    0x000000c0
-#define LOCAL_SCRATCH_OFFSET                     0x000000c0
-#define LOCAL_SCRATCH_VALUE_MSB                  7
-#define LOCAL_SCRATCH_VALUE_LSB                  0
-#define LOCAL_SCRATCH_VALUE_MASK                 0x000000ff
-#define LOCAL_SCRATCH_VALUE_GET(x)               (((x) & LOCAL_SCRATCH_VALUE_MASK) >> LOCAL_SCRATCH_VALUE_LSB)
-#define LOCAL_SCRATCH_VALUE_SET(x)               (((x) << LOCAL_SCRATCH_VALUE_LSB) & LOCAL_SCRATCH_VALUE_MASK)
-
-#define USE_LOCAL_BUS_ADDRESS                    0x000000e0
-#define USE_LOCAL_BUS_OFFSET                     0x000000e0
-#define USE_LOCAL_BUS_PIN_INIT_MSB               0
-#define USE_LOCAL_BUS_PIN_INIT_LSB               0
-#define USE_LOCAL_BUS_PIN_INIT_MASK              0x00000001
-#define USE_LOCAL_BUS_PIN_INIT_GET(x)            (((x) & USE_LOCAL_BUS_PIN_INIT_MASK) >> USE_LOCAL_BUS_PIN_INIT_LSB)
-#define USE_LOCAL_BUS_PIN_INIT_SET(x)            (((x) << USE_LOCAL_BUS_PIN_INIT_LSB) & USE_LOCAL_BUS_PIN_INIT_MASK)
-
-#define SDIO_CONFIG_ADDRESS                      0x000000e4
-#define SDIO_CONFIG_OFFSET                       0x000000e4
-#define SDIO_CONFIG_CCCR_IOR1_MSB                0
-#define SDIO_CONFIG_CCCR_IOR1_LSB                0
-#define SDIO_CONFIG_CCCR_IOR1_MASK               0x00000001
-#define SDIO_CONFIG_CCCR_IOR1_GET(x)             (((x) & SDIO_CONFIG_CCCR_IOR1_MASK) >> SDIO_CONFIG_CCCR_IOR1_LSB)
-#define SDIO_CONFIG_CCCR_IOR1_SET(x)             (((x) << SDIO_CONFIG_CCCR_IOR1_LSB) & SDIO_CONFIG_CCCR_IOR1_MASK)
-
-#define MBOX_DEBUG_ADDRESS                       0x000000e8
-#define MBOX_DEBUG_OFFSET                        0x000000e8
-#define MBOX_DEBUG_SEL_MSB                       2
-#define MBOX_DEBUG_SEL_LSB                       0
-#define MBOX_DEBUG_SEL_MASK                      0x00000007
-#define MBOX_DEBUG_SEL_GET(x)                    (((x) & MBOX_DEBUG_SEL_MASK) >> MBOX_DEBUG_SEL_LSB)
-#define MBOX_DEBUG_SEL_SET(x)                    (((x) << MBOX_DEBUG_SEL_LSB) & MBOX_DEBUG_SEL_MASK)
-
-#define MBOX_FIFO_RESET_ADDRESS                  0x000000ec
-#define MBOX_FIFO_RESET_OFFSET                   0x000000ec
-#define MBOX_FIFO_RESET_INIT_MSB                 0
-#define MBOX_FIFO_RESET_INIT_LSB                 0
-#define MBOX_FIFO_RESET_INIT_MASK                0x00000001
-#define MBOX_FIFO_RESET_INIT_GET(x)              (((x) & MBOX_FIFO_RESET_INIT_MASK) >> MBOX_FIFO_RESET_INIT_LSB)
-#define MBOX_FIFO_RESET_INIT_SET(x)              (((x) << MBOX_FIFO_RESET_INIT_LSB) & MBOX_FIFO_RESET_INIT_MASK)
-
-#define MBOX_TXFIFO_POP_ADDRESS                  0x000000f0
-#define MBOX_TXFIFO_POP_OFFSET                   0x000000f0
-#define MBOX_TXFIFO_POP_DATA_MSB                 0
-#define MBOX_TXFIFO_POP_DATA_LSB                 0
-#define MBOX_TXFIFO_POP_DATA_MASK                0x00000001
-#define MBOX_TXFIFO_POP_DATA_GET(x)              (((x) & MBOX_TXFIFO_POP_DATA_MASK) >> MBOX_TXFIFO_POP_DATA_LSB)
-#define MBOX_TXFIFO_POP_DATA_SET(x)              (((x) << MBOX_TXFIFO_POP_DATA_LSB) & MBOX_TXFIFO_POP_DATA_MASK)
-
-#define MBOX_RXFIFO_POP_ADDRESS                  0x00000100
-#define MBOX_RXFIFO_POP_OFFSET                   0x00000100
-#define MBOX_RXFIFO_POP_DATA_MSB                 0
-#define MBOX_RXFIFO_POP_DATA_LSB                 0
-#define MBOX_RXFIFO_POP_DATA_MASK                0x00000001
-#define MBOX_RXFIFO_POP_DATA_GET(x)              (((x) & MBOX_RXFIFO_POP_DATA_MASK) >> MBOX_RXFIFO_POP_DATA_LSB)
-#define MBOX_RXFIFO_POP_DATA_SET(x)              (((x) << MBOX_RXFIFO_POP_DATA_LSB) & MBOX_RXFIFO_POP_DATA_MASK)
-
-#define SDIO_DEBUG_ADDRESS                       0x00000110
-#define SDIO_DEBUG_OFFSET                        0x00000110
-#define SDIO_DEBUG_SEL_MSB                       3
-#define SDIO_DEBUG_SEL_LSB                       0
-#define SDIO_DEBUG_SEL_MASK                      0x0000000f
-#define SDIO_DEBUG_SEL_GET(x)                    (((x) & SDIO_DEBUG_SEL_MASK) >> SDIO_DEBUG_SEL_LSB)
-#define SDIO_DEBUG_SEL_SET(x)                    (((x) << SDIO_DEBUG_SEL_LSB) & SDIO_DEBUG_SEL_MASK)
-
-#define HOST_IF_WINDOW_ADDRESS                   0x00002000
-#define HOST_IF_WINDOW_OFFSET                    0x00002000
-#define HOST_IF_WINDOW_DATA_MSB                  7
-#define HOST_IF_WINDOW_DATA_LSB                  0
-#define HOST_IF_WINDOW_DATA_MASK                 0x000000ff
-#define HOST_IF_WINDOW_DATA_GET(x)               (((x) & HOST_IF_WINDOW_DATA_MASK) >> HOST_IF_WINDOW_DATA_LSB)
-#define HOST_IF_WINDOW_DATA_SET(x)               (((x) << HOST_IF_WINDOW_DATA_LSB) & HOST_IF_WINDOW_DATA_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct mbox_reg_reg_s {
-  volatile unsigned int mbox_fifo[4];
-  volatile unsigned int mbox_fifo_status;
-  volatile unsigned int mbox_dma_policy;
-  volatile unsigned int mbox0_dma_rx_descriptor_base;
-  volatile unsigned int mbox0_dma_rx_control;
-  volatile unsigned int mbox0_dma_tx_descriptor_base;
-  volatile unsigned int mbox0_dma_tx_control;
-  volatile unsigned int mbox1_dma_rx_descriptor_base;
-  volatile unsigned int mbox1_dma_rx_control;
-  volatile unsigned int mbox1_dma_tx_descriptor_base;
-  volatile unsigned int mbox1_dma_tx_control;
-  volatile unsigned int mbox2_dma_rx_descriptor_base;
-  volatile unsigned int mbox2_dma_rx_control;
-  volatile unsigned int mbox2_dma_tx_descriptor_base;
-  volatile unsigned int mbox2_dma_tx_control;
-  volatile unsigned int mbox3_dma_rx_descriptor_base;
-  volatile unsigned int mbox3_dma_rx_control;
-  volatile unsigned int mbox3_dma_tx_descriptor_base;
-  volatile unsigned int mbox3_dma_tx_control;
-  volatile unsigned int mbox_int_status;
-  volatile unsigned int mbox_int_enable;
-  volatile unsigned int int_host;
-  unsigned char pad0[28]; /* pad to 0x80 */
-  volatile unsigned int local_count[8];
-  volatile unsigned int count_inc[8];
-  volatile unsigned int local_scratch[8];
-  volatile unsigned int use_local_bus;
-  volatile unsigned int sdio_config;
-  volatile unsigned int mbox_debug;
-  volatile unsigned int mbox_fifo_reset;
-  volatile unsigned int mbox_txfifo_pop[4];
-  volatile unsigned int mbox_rxfifo_pop[4];
-  volatile unsigned int sdio_debug;
-  unsigned char pad1[7916]; /* pad to 0x2000 */
-  volatile unsigned int host_if_window[2048];
-} mbox_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _MBOX_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h
deleted file mode 100644
index 8b3980a..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h
+++ /dev/null
@@ -1,1163 +0,0 @@
-#ifndef _RTC_REG_REG_H_
-#define _RTC_REG_REG_H_
-
-#define RESET_CONTROL_ADDRESS                    0x00000000
-#define RESET_CONTROL_OFFSET                     0x00000000
-#define RESET_CONTROL_CPU_INIT_RESET_MSB         11
-#define RESET_CONTROL_CPU_INIT_RESET_LSB         11
-#define RESET_CONTROL_CPU_INIT_RESET_MASK        0x00000800
-#define RESET_CONTROL_CPU_INIT_RESET_GET(x)      (((x) & RESET_CONTROL_CPU_INIT_RESET_MASK) >> RESET_CONTROL_CPU_INIT_RESET_LSB)
-#define RESET_CONTROL_CPU_INIT_RESET_SET(x)      (((x) << RESET_CONTROL_CPU_INIT_RESET_LSB) & RESET_CONTROL_CPU_INIT_RESET_MASK)
-#define RESET_CONTROL_VMC_REMAP_RESET_MSB        10
-#define RESET_CONTROL_VMC_REMAP_RESET_LSB        10
-#define RESET_CONTROL_VMC_REMAP_RESET_MASK       0x00000400
-#define RESET_CONTROL_VMC_REMAP_RESET_GET(x)     (((x) & RESET_CONTROL_VMC_REMAP_RESET_MASK) >> RESET_CONTROL_VMC_REMAP_RESET_LSB)
-#define RESET_CONTROL_VMC_REMAP_RESET_SET(x)     (((x) << RESET_CONTROL_VMC_REMAP_RESET_LSB) & RESET_CONTROL_VMC_REMAP_RESET_MASK)
-#define RESET_CONTROL_RST_OUT_MSB                9
-#define RESET_CONTROL_RST_OUT_LSB                9
-#define RESET_CONTROL_RST_OUT_MASK               0x00000200
-#define RESET_CONTROL_RST_OUT_GET(x)             (((x) & RESET_CONTROL_RST_OUT_MASK) >> RESET_CONTROL_RST_OUT_LSB)
-#define RESET_CONTROL_RST_OUT_SET(x)             (((x) << RESET_CONTROL_RST_OUT_LSB) & RESET_CONTROL_RST_OUT_MASK)
-#define RESET_CONTROL_COLD_RST_MSB               8
-#define RESET_CONTROL_COLD_RST_LSB               8
-#define RESET_CONTROL_COLD_RST_MASK              0x00000100
-#define RESET_CONTROL_COLD_RST_GET(x)            (((x) & RESET_CONTROL_COLD_RST_MASK) >> RESET_CONTROL_COLD_RST_LSB)
-#define RESET_CONTROL_COLD_RST_SET(x)            (((x) << RESET_CONTROL_COLD_RST_LSB) & RESET_CONTROL_COLD_RST_MASK)
-#define RESET_CONTROL_WARM_RST_MSB               7
-#define RESET_CONTROL_WARM_RST_LSB               7
-#define RESET_CONTROL_WARM_RST_MASK              0x00000080
-#define RESET_CONTROL_WARM_RST_GET(x)            (((x) & RESET_CONTROL_WARM_RST_MASK) >> RESET_CONTROL_WARM_RST_LSB)
-#define RESET_CONTROL_WARM_RST_SET(x)            (((x) << RESET_CONTROL_WARM_RST_LSB) & RESET_CONTROL_WARM_RST_MASK)
-#define RESET_CONTROL_CPU_WARM_RST_MSB           6
-#define RESET_CONTROL_CPU_WARM_RST_LSB           6
-#define RESET_CONTROL_CPU_WARM_RST_MASK          0x00000040
-#define RESET_CONTROL_CPU_WARM_RST_GET(x)        (((x) & RESET_CONTROL_CPU_WARM_RST_MASK) >> RESET_CONTROL_CPU_WARM_RST_LSB)
-#define RESET_CONTROL_CPU_WARM_RST_SET(x)        (((x) << RESET_CONTROL_CPU_WARM_RST_LSB) & RESET_CONTROL_CPU_WARM_RST_MASK)
-#define RESET_CONTROL_MAC_COLD_RST_MSB           5
-#define RESET_CONTROL_MAC_COLD_RST_LSB           5
-#define RESET_CONTROL_MAC_COLD_RST_MASK          0x00000020
-#define RESET_CONTROL_MAC_COLD_RST_GET(x)        (((x) & RESET_CONTROL_MAC_COLD_RST_MASK) >> RESET_CONTROL_MAC_COLD_RST_LSB)
-#define RESET_CONTROL_MAC_COLD_RST_SET(x)        (((x) << RESET_CONTROL_MAC_COLD_RST_LSB) & RESET_CONTROL_MAC_COLD_RST_MASK)
-#define RESET_CONTROL_MAC_WARM_RST_MSB           4
-#define RESET_CONTROL_MAC_WARM_RST_LSB           4
-#define RESET_CONTROL_MAC_WARM_RST_MASK          0x00000010
-#define RESET_CONTROL_MAC_WARM_RST_GET(x)        (((x) & RESET_CONTROL_MAC_WARM_RST_MASK) >> RESET_CONTROL_MAC_WARM_RST_LSB)
-#define RESET_CONTROL_MAC_WARM_RST_SET(x)        (((x) << RESET_CONTROL_MAC_WARM_RST_LSB) & RESET_CONTROL_MAC_WARM_RST_MASK)
-#define RESET_CONTROL_MBOX_RST_MSB               2
-#define RESET_CONTROL_MBOX_RST_LSB               2
-#define RESET_CONTROL_MBOX_RST_MASK              0x00000004
-#define RESET_CONTROL_MBOX_RST_GET(x)            (((x) & RESET_CONTROL_MBOX_RST_MASK) >> RESET_CONTROL_MBOX_RST_LSB)
-#define RESET_CONTROL_MBOX_RST_SET(x)            (((x) << RESET_CONTROL_MBOX_RST_LSB) & RESET_CONTROL_MBOX_RST_MASK)
-#define RESET_CONTROL_UART_RST_MSB               1
-#define RESET_CONTROL_UART_RST_LSB               1
-#define RESET_CONTROL_UART_RST_MASK              0x00000002
-#define RESET_CONTROL_UART_RST_GET(x)            (((x) & RESET_CONTROL_UART_RST_MASK) >> RESET_CONTROL_UART_RST_LSB)
-#define RESET_CONTROL_UART_RST_SET(x)            (((x) << RESET_CONTROL_UART_RST_LSB) & RESET_CONTROL_UART_RST_MASK)
-#define RESET_CONTROL_SI0_RST_MSB                0
-#define RESET_CONTROL_SI0_RST_LSB                0
-#define RESET_CONTROL_SI0_RST_MASK               0x00000001
-#define RESET_CONTROL_SI0_RST_GET(x)             (((x) & RESET_CONTROL_SI0_RST_MASK) >> RESET_CONTROL_SI0_RST_LSB)
-#define RESET_CONTROL_SI0_RST_SET(x)             (((x) << RESET_CONTROL_SI0_RST_LSB) & RESET_CONTROL_SI0_RST_MASK)
-
-#define XTAL_CONTROL_ADDRESS                     0x00000004
-#define XTAL_CONTROL_OFFSET                      0x00000004
-#define XTAL_CONTROL_TCXO_MSB                    0
-#define XTAL_CONTROL_TCXO_LSB                    0
-#define XTAL_CONTROL_TCXO_MASK                   0x00000001
-#define XTAL_CONTROL_TCXO_GET(x)                 (((x) & XTAL_CONTROL_TCXO_MASK) >> XTAL_CONTROL_TCXO_LSB)
-#define XTAL_CONTROL_TCXO_SET(x)                 (((x) << XTAL_CONTROL_TCXO_LSB) & XTAL_CONTROL_TCXO_MASK)
-
-#define TCXO_DETECT_ADDRESS                      0x00000008
-#define TCXO_DETECT_OFFSET                       0x00000008
-#define TCXO_DETECT_PRESENT_MSB                  0
-#define TCXO_DETECT_PRESENT_LSB                  0
-#define TCXO_DETECT_PRESENT_MASK                 0x00000001
-#define TCXO_DETECT_PRESENT_GET(x)               (((x) & TCXO_DETECT_PRESENT_MASK) >> TCXO_DETECT_PRESENT_LSB)
-#define TCXO_DETECT_PRESENT_SET(x)               (((x) << TCXO_DETECT_PRESENT_LSB) & TCXO_DETECT_PRESENT_MASK)
-
-#define XTAL_TEST_ADDRESS                        0x0000000c
-#define XTAL_TEST_OFFSET                         0x0000000c
-#define XTAL_TEST_NOTCXODET_MSB                  0
-#define XTAL_TEST_NOTCXODET_LSB                  0
-#define XTAL_TEST_NOTCXODET_MASK                 0x00000001
-#define XTAL_TEST_NOTCXODET_GET(x)               (((x) & XTAL_TEST_NOTCXODET_MASK) >> XTAL_TEST_NOTCXODET_LSB)
-#define XTAL_TEST_NOTCXODET_SET(x)               (((x) << XTAL_TEST_NOTCXODET_LSB) & XTAL_TEST_NOTCXODET_MASK)
-
-#define QUADRATURE_ADDRESS                       0x00000010
-#define QUADRATURE_OFFSET                        0x00000010
-#define QUADRATURE_ADC_MSB                       5
-#define QUADRATURE_ADC_LSB                       4
-#define QUADRATURE_ADC_MASK                      0x00000030
-#define QUADRATURE_ADC_GET(x)                    (((x) & QUADRATURE_ADC_MASK) >> QUADRATURE_ADC_LSB)
-#define QUADRATURE_ADC_SET(x)                    (((x) << QUADRATURE_ADC_LSB) & QUADRATURE_ADC_MASK)
-#define QUADRATURE_SEL_MSB                       2
-#define QUADRATURE_SEL_LSB                       2
-#define QUADRATURE_SEL_MASK                      0x00000004
-#define QUADRATURE_SEL_GET(x)                    (((x) & QUADRATURE_SEL_MASK) >> QUADRATURE_SEL_LSB)
-#define QUADRATURE_SEL_SET(x)                    (((x) << QUADRATURE_SEL_LSB) & QUADRATURE_SEL_MASK)
-#define QUADRATURE_DAC_MSB                       1
-#define QUADRATURE_DAC_LSB                       0
-#define QUADRATURE_DAC_MASK                      0x00000003
-#define QUADRATURE_DAC_GET(x)                    (((x) & QUADRATURE_DAC_MASK) >> QUADRATURE_DAC_LSB)
-#define QUADRATURE_DAC_SET(x)                    (((x) << QUADRATURE_DAC_LSB) & QUADRATURE_DAC_MASK)
-
-#define PLL_CONTROL_ADDRESS                      0x00000014
-#define PLL_CONTROL_OFFSET                       0x00000014
-#define PLL_CONTROL_DIG_TEST_CLK_MSB             20
-#define PLL_CONTROL_DIG_TEST_CLK_LSB             20
-#define PLL_CONTROL_DIG_TEST_CLK_MASK            0x00100000
-#define PLL_CONTROL_DIG_TEST_CLK_GET(x)          (((x) & PLL_CONTROL_DIG_TEST_CLK_MASK) >> PLL_CONTROL_DIG_TEST_CLK_LSB)
-#define PLL_CONTROL_DIG_TEST_CLK_SET(x)          (((x) << PLL_CONTROL_DIG_TEST_CLK_LSB) & PLL_CONTROL_DIG_TEST_CLK_MASK)
-#define PLL_CONTROL_MAC_OVERRIDE_MSB             19
-#define PLL_CONTROL_MAC_OVERRIDE_LSB             19
-#define PLL_CONTROL_MAC_OVERRIDE_MASK            0x00080000
-#define PLL_CONTROL_MAC_OVERRIDE_GET(x)          (((x) & PLL_CONTROL_MAC_OVERRIDE_MASK) >> PLL_CONTROL_MAC_OVERRIDE_LSB)
-#define PLL_CONTROL_MAC_OVERRIDE_SET(x)          (((x) << PLL_CONTROL_MAC_OVERRIDE_LSB) & PLL_CONTROL_MAC_OVERRIDE_MASK)
-#define PLL_CONTROL_NOPWD_MSB                    18
-#define PLL_CONTROL_NOPWD_LSB                    18
-#define PLL_CONTROL_NOPWD_MASK                   0x00040000
-#define PLL_CONTROL_NOPWD_GET(x)                 (((x) & PLL_CONTROL_NOPWD_MASK) >> PLL_CONTROL_NOPWD_LSB)
-#define PLL_CONTROL_NOPWD_SET(x)                 (((x) << PLL_CONTROL_NOPWD_LSB) & PLL_CONTROL_NOPWD_MASK)
-#define PLL_CONTROL_UPDATING_MSB                 17
-#define PLL_CONTROL_UPDATING_LSB                 17
-#define PLL_CONTROL_UPDATING_MASK                0x00020000
-#define PLL_CONTROL_UPDATING_GET(x)              (((x) & PLL_CONTROL_UPDATING_MASK) >> PLL_CONTROL_UPDATING_LSB)
-#define PLL_CONTROL_UPDATING_SET(x)              (((x) << PLL_CONTROL_UPDATING_LSB) & PLL_CONTROL_UPDATING_MASK)
-#define PLL_CONTROL_BYPASS_MSB                   16
-#define PLL_CONTROL_BYPASS_LSB                   16
-#define PLL_CONTROL_BYPASS_MASK                  0x00010000
-#define PLL_CONTROL_BYPASS_GET(x)                (((x) & PLL_CONTROL_BYPASS_MASK) >> PLL_CONTROL_BYPASS_LSB)
-#define PLL_CONTROL_BYPASS_SET(x)                (((x) << PLL_CONTROL_BYPASS_LSB) & PLL_CONTROL_BYPASS_MASK)
-#define PLL_CONTROL_REFDIV_MSB                   15
-#define PLL_CONTROL_REFDIV_LSB                   12
-#define PLL_CONTROL_REFDIV_MASK                  0x0000f000
-#define PLL_CONTROL_REFDIV_GET(x)                (((x) & PLL_CONTROL_REFDIV_MASK) >> PLL_CONTROL_REFDIV_LSB)
-#define PLL_CONTROL_REFDIV_SET(x)                (((x) << PLL_CONTROL_REFDIV_LSB) & PLL_CONTROL_REFDIV_MASK)
-#define PLL_CONTROL_DIV_MSB                      9
-#define PLL_CONTROL_DIV_LSB                      0
-#define PLL_CONTROL_DIV_MASK                     0x000003ff
-#define PLL_CONTROL_DIV_GET(x)                   (((x) & PLL_CONTROL_DIV_MASK) >> PLL_CONTROL_DIV_LSB)
-#define PLL_CONTROL_DIV_SET(x)                   (((x) << PLL_CONTROL_DIV_LSB) & PLL_CONTROL_DIV_MASK)
-
-#define PLL_SETTLE_ADDRESS                       0x00000018
-#define PLL_SETTLE_OFFSET                        0x00000018
-#define PLL_SETTLE_TIME_MSB                      11
-#define PLL_SETTLE_TIME_LSB                      0
-#define PLL_SETTLE_TIME_MASK                     0x00000fff
-#define PLL_SETTLE_TIME_GET(x)                   (((x) & PLL_SETTLE_TIME_MASK) >> PLL_SETTLE_TIME_LSB)
-#define PLL_SETTLE_TIME_SET(x)                   (((x) << PLL_SETTLE_TIME_LSB) & PLL_SETTLE_TIME_MASK)
-
-#define XTAL_SETTLE_ADDRESS                      0x0000001c
-#define XTAL_SETTLE_OFFSET                       0x0000001c
-#define XTAL_SETTLE_TIME_MSB                     7
-#define XTAL_SETTLE_TIME_LSB                     0
-#define XTAL_SETTLE_TIME_MASK                    0x000000ff
-#define XTAL_SETTLE_TIME_GET(x)                  (((x) & XTAL_SETTLE_TIME_MASK) >> XTAL_SETTLE_TIME_LSB)
-#define XTAL_SETTLE_TIME_SET(x)                  (((x) << XTAL_SETTLE_TIME_LSB) & XTAL_SETTLE_TIME_MASK)
-
-#define CPU_CLOCK_ADDRESS                        0x00000020
-#define CPU_CLOCK_OFFSET                         0x00000020
-#define CPU_CLOCK_STANDARD_MSB                   1
-#define CPU_CLOCK_STANDARD_LSB                   0
-#define CPU_CLOCK_STANDARD_MASK                  0x00000003
-#define CPU_CLOCK_STANDARD_GET(x)                (((x) & CPU_CLOCK_STANDARD_MASK) >> CPU_CLOCK_STANDARD_LSB)
-#define CPU_CLOCK_STANDARD_SET(x)                (((x) << CPU_CLOCK_STANDARD_LSB) & CPU_CLOCK_STANDARD_MASK)
-
-#define CLOCK_OUT_ADDRESS                        0x00000024
-#define CLOCK_OUT_OFFSET                         0x00000024
-#define CLOCK_OUT_SELECT_MSB                     3
-#define CLOCK_OUT_SELECT_LSB                     0
-#define CLOCK_OUT_SELECT_MASK                    0x0000000f
-#define CLOCK_OUT_SELECT_GET(x)                  (((x) & CLOCK_OUT_SELECT_MASK) >> CLOCK_OUT_SELECT_LSB)
-#define CLOCK_OUT_SELECT_SET(x)                  (((x) << CLOCK_OUT_SELECT_LSB) & CLOCK_OUT_SELECT_MASK)
-
-#define CLOCK_CONTROL_ADDRESS                    0x00000028
-#define CLOCK_CONTROL_OFFSET                     0x00000028
-#define CLOCK_CONTROL_LF_CLK32_MSB               2
-#define CLOCK_CONTROL_LF_CLK32_LSB               2
-#define CLOCK_CONTROL_LF_CLK32_MASK              0x00000004
-#define CLOCK_CONTROL_LF_CLK32_GET(x)            (((x) & CLOCK_CONTROL_LF_CLK32_MASK) >> CLOCK_CONTROL_LF_CLK32_LSB)
-#define CLOCK_CONTROL_LF_CLK32_SET(x)            (((x) << CLOCK_CONTROL_LF_CLK32_LSB) & CLOCK_CONTROL_LF_CLK32_MASK)
-#define CLOCK_CONTROL_UART_CLK_MSB               1
-#define CLOCK_CONTROL_UART_CLK_LSB               1
-#define CLOCK_CONTROL_UART_CLK_MASK              0x00000002
-#define CLOCK_CONTROL_UART_CLK_GET(x)            (((x) & CLOCK_CONTROL_UART_CLK_MASK) >> CLOCK_CONTROL_UART_CLK_LSB)
-#define CLOCK_CONTROL_UART_CLK_SET(x)            (((x) << CLOCK_CONTROL_UART_CLK_LSB) & CLOCK_CONTROL_UART_CLK_MASK)
-#define CLOCK_CONTROL_SI0_CLK_MSB                0
-#define CLOCK_CONTROL_SI0_CLK_LSB                0
-#define CLOCK_CONTROL_SI0_CLK_MASK               0x00000001
-#define CLOCK_CONTROL_SI0_CLK_GET(x)             (((x) & CLOCK_CONTROL_SI0_CLK_MASK) >> CLOCK_CONTROL_SI0_CLK_LSB)
-#define CLOCK_CONTROL_SI0_CLK_SET(x)             (((x) << CLOCK_CONTROL_SI0_CLK_LSB) & CLOCK_CONTROL_SI0_CLK_MASK)
-
-#define BIAS_OVERRIDE_ADDRESS                    0x0000002c
-#define BIAS_OVERRIDE_OFFSET                     0x0000002c
-#define BIAS_OVERRIDE_ON_MSB                     0
-#define BIAS_OVERRIDE_ON_LSB                     0
-#define BIAS_OVERRIDE_ON_MASK                    0x00000001
-#define BIAS_OVERRIDE_ON_GET(x)                  (((x) & BIAS_OVERRIDE_ON_MASK) >> BIAS_OVERRIDE_ON_LSB)
-#define BIAS_OVERRIDE_ON_SET(x)                  (((x) << BIAS_OVERRIDE_ON_LSB) & BIAS_OVERRIDE_ON_MASK)
-
-#define WDT_CONTROL_ADDRESS                      0x00000030
-#define WDT_CONTROL_OFFSET                       0x00000030
-#define WDT_CONTROL_ACTION_MSB                   2
-#define WDT_CONTROL_ACTION_LSB                   0
-#define WDT_CONTROL_ACTION_MASK                  0x00000007
-#define WDT_CONTROL_ACTION_GET(x)                (((x) & WDT_CONTROL_ACTION_MASK) >> WDT_CONTROL_ACTION_LSB)
-#define WDT_CONTROL_ACTION_SET(x)                (((x) << WDT_CONTROL_ACTION_LSB) & WDT_CONTROL_ACTION_MASK)
-
-#define WDT_STATUS_ADDRESS                       0x00000034
-#define WDT_STATUS_OFFSET                        0x00000034
-#define WDT_STATUS_INTERRUPT_MSB                 0
-#define WDT_STATUS_INTERRUPT_LSB                 0
-#define WDT_STATUS_INTERRUPT_MASK                0x00000001
-#define WDT_STATUS_INTERRUPT_GET(x)              (((x) & WDT_STATUS_INTERRUPT_MASK) >> WDT_STATUS_INTERRUPT_LSB)
-#define WDT_STATUS_INTERRUPT_SET(x)              (((x) << WDT_STATUS_INTERRUPT_LSB) & WDT_STATUS_INTERRUPT_MASK)
-
-#define WDT_ADDRESS                              0x00000038
-#define WDT_OFFSET                               0x00000038
-#define WDT_TARGET_MSB                           21
-#define WDT_TARGET_LSB                           0
-#define WDT_TARGET_MASK                          0x003fffff
-#define WDT_TARGET_GET(x)                        (((x) & WDT_TARGET_MASK) >> WDT_TARGET_LSB)
-#define WDT_TARGET_SET(x)                        (((x) << WDT_TARGET_LSB) & WDT_TARGET_MASK)
-
-#define WDT_COUNT_ADDRESS                        0x0000003c
-#define WDT_COUNT_OFFSET                         0x0000003c
-#define WDT_COUNT_VALUE_MSB                      21
-#define WDT_COUNT_VALUE_LSB                      0
-#define WDT_COUNT_VALUE_MASK                     0x003fffff
-#define WDT_COUNT_VALUE_GET(x)                   (((x) & WDT_COUNT_VALUE_MASK) >> WDT_COUNT_VALUE_LSB)
-#define WDT_COUNT_VALUE_SET(x)                   (((x) << WDT_COUNT_VALUE_LSB) & WDT_COUNT_VALUE_MASK)
-
-#define WDT_RESET_ADDRESS                        0x00000040
-#define WDT_RESET_OFFSET                         0x00000040
-#define WDT_RESET_VALUE_MSB                      0
-#define WDT_RESET_VALUE_LSB                      0
-#define WDT_RESET_VALUE_MASK                     0x00000001
-#define WDT_RESET_VALUE_GET(x)                   (((x) & WDT_RESET_VALUE_MASK) >> WDT_RESET_VALUE_LSB)
-#define WDT_RESET_VALUE_SET(x)                   (((x) << WDT_RESET_VALUE_LSB) & WDT_RESET_VALUE_MASK)
-
-#define INT_STATUS_ADDRESS                       0x00000044
-#define INT_STATUS_OFFSET                        0x00000044
-#define INT_STATUS_RTC_POWER_MSB                 14
-#define INT_STATUS_RTC_POWER_LSB                 14
-#define INT_STATUS_RTC_POWER_MASK                0x00004000
-#define INT_STATUS_RTC_POWER_GET(x)              (((x) & INT_STATUS_RTC_POWER_MASK) >> INT_STATUS_RTC_POWER_LSB)
-#define INT_STATUS_RTC_POWER_SET(x)              (((x) << INT_STATUS_RTC_POWER_LSB) & INT_STATUS_RTC_POWER_MASK)
-#define INT_STATUS_MAC_MSB                       13
-#define INT_STATUS_MAC_LSB                       13
-#define INT_STATUS_MAC_MASK                      0x00002000
-#define INT_STATUS_MAC_GET(x)                    (((x) & INT_STATUS_MAC_MASK) >> INT_STATUS_MAC_LSB)
-#define INT_STATUS_MAC_SET(x)                    (((x) << INT_STATUS_MAC_LSB) & INT_STATUS_MAC_MASK)
-#define INT_STATUS_MAILBOX_MSB                   12
-#define INT_STATUS_MAILBOX_LSB                   12
-#define INT_STATUS_MAILBOX_MASK                  0x00001000
-#define INT_STATUS_MAILBOX_GET(x)                (((x) & INT_STATUS_MAILBOX_MASK) >> INT_STATUS_MAILBOX_LSB)
-#define INT_STATUS_MAILBOX_SET(x)                (((x) << INT_STATUS_MAILBOX_LSB) & INT_STATUS_MAILBOX_MASK)
-#define INT_STATUS_RTC_ALARM_MSB                 11
-#define INT_STATUS_RTC_ALARM_LSB                 11
-#define INT_STATUS_RTC_ALARM_MASK                0x00000800
-#define INT_STATUS_RTC_ALARM_GET(x)              (((x) & INT_STATUS_RTC_ALARM_MASK) >> INT_STATUS_RTC_ALARM_LSB)
-#define INT_STATUS_RTC_ALARM_SET(x)              (((x) << INT_STATUS_RTC_ALARM_LSB) & INT_STATUS_RTC_ALARM_MASK)
-#define INT_STATUS_HF_TIMER_MSB                  10
-#define INT_STATUS_HF_TIMER_LSB                  10
-#define INT_STATUS_HF_TIMER_MASK                 0x00000400
-#define INT_STATUS_HF_TIMER_GET(x)               (((x) & INT_STATUS_HF_TIMER_MASK) >> INT_STATUS_HF_TIMER_LSB)
-#define INT_STATUS_HF_TIMER_SET(x)               (((x) << INT_STATUS_HF_TIMER_LSB) & INT_STATUS_HF_TIMER_MASK)
-#define INT_STATUS_LF_TIMER3_MSB                 9
-#define INT_STATUS_LF_TIMER3_LSB                 9
-#define INT_STATUS_LF_TIMER3_MASK                0x00000200
-#define INT_STATUS_LF_TIMER3_GET(x)              (((x) & INT_STATUS_LF_TIMER3_MASK) >> INT_STATUS_LF_TIMER3_LSB)
-#define INT_STATUS_LF_TIMER3_SET(x)              (((x) << INT_STATUS_LF_TIMER3_LSB) & INT_STATUS_LF_TIMER3_MASK)
-#define INT_STATUS_LF_TIMER2_MSB                 8
-#define INT_STATUS_LF_TIMER2_LSB                 8
-#define INT_STATUS_LF_TIMER2_MASK                0x00000100
-#define INT_STATUS_LF_TIMER2_GET(x)              (((x) & INT_STATUS_LF_TIMER2_MASK) >> INT_STATUS_LF_TIMER2_LSB)
-#define INT_STATUS_LF_TIMER2_SET(x)              (((x) << INT_STATUS_LF_TIMER2_LSB) & INT_STATUS_LF_TIMER2_MASK)
-#define INT_STATUS_LF_TIMER1_MSB                 7
-#define INT_STATUS_LF_TIMER1_LSB                 7
-#define INT_STATUS_LF_TIMER1_MASK                0x00000080
-#define INT_STATUS_LF_TIMER1_GET(x)              (((x) & INT_STATUS_LF_TIMER1_MASK) >> INT_STATUS_LF_TIMER1_LSB)
-#define INT_STATUS_LF_TIMER1_SET(x)              (((x) << INT_STATUS_LF_TIMER1_LSB) & INT_STATUS_LF_TIMER1_MASK)
-#define INT_STATUS_LF_TIMER0_MSB                 6
-#define INT_STATUS_LF_TIMER0_LSB                 6
-#define INT_STATUS_LF_TIMER0_MASK                0x00000040
-#define INT_STATUS_LF_TIMER0_GET(x)              (((x) & INT_STATUS_LF_TIMER0_MASK) >> INT_STATUS_LF_TIMER0_LSB)
-#define INT_STATUS_LF_TIMER0_SET(x)              (((x) << INT_STATUS_LF_TIMER0_LSB) & INT_STATUS_LF_TIMER0_MASK)
-#define INT_STATUS_KEYPAD_MSB                    5
-#define INT_STATUS_KEYPAD_LSB                    5
-#define INT_STATUS_KEYPAD_MASK                   0x00000020
-#define INT_STATUS_KEYPAD_GET(x)                 (((x) & INT_STATUS_KEYPAD_MASK) >> INT_STATUS_KEYPAD_LSB)
-#define INT_STATUS_KEYPAD_SET(x)                 (((x) << INT_STATUS_KEYPAD_LSB) & INT_STATUS_KEYPAD_MASK)
-#define INT_STATUS_SI_MSB                        4
-#define INT_STATUS_SI_LSB                        4
-#define INT_STATUS_SI_MASK                       0x00000010
-#define INT_STATUS_SI_GET(x)                     (((x) & INT_STATUS_SI_MASK) >> INT_STATUS_SI_LSB)
-#define INT_STATUS_SI_SET(x)                     (((x) << INT_STATUS_SI_LSB) & INT_STATUS_SI_MASK)
-#define INT_STATUS_GPIO_MSB                      3
-#define INT_STATUS_GPIO_LSB                      3
-#define INT_STATUS_GPIO_MASK                     0x00000008
-#define INT_STATUS_GPIO_GET(x)                   (((x) & INT_STATUS_GPIO_MASK) >> INT_STATUS_GPIO_LSB)
-#define INT_STATUS_GPIO_SET(x)                   (((x) << INT_STATUS_GPIO_LSB) & INT_STATUS_GPIO_MASK)
-#define INT_STATUS_UART_MSB                      2
-#define INT_STATUS_UART_LSB                      2
-#define INT_STATUS_UART_MASK                     0x00000004
-#define INT_STATUS_UART_GET(x)                   (((x) & INT_STATUS_UART_MASK) >> INT_STATUS_UART_LSB)
-#define INT_STATUS_UART_SET(x)                   (((x) << INT_STATUS_UART_LSB) & INT_STATUS_UART_MASK)
-#define INT_STATUS_ERROR_MSB                     1
-#define INT_STATUS_ERROR_LSB                     1
-#define INT_STATUS_ERROR_MASK                    0x00000002
-#define INT_STATUS_ERROR_GET(x)                  (((x) & INT_STATUS_ERROR_MASK) >> INT_STATUS_ERROR_LSB)
-#define INT_STATUS_ERROR_SET(x)                  (((x) << INT_STATUS_ERROR_LSB) & INT_STATUS_ERROR_MASK)
-#define INT_STATUS_WDT_INT_MSB                   0
-#define INT_STATUS_WDT_INT_LSB                   0
-#define INT_STATUS_WDT_INT_MASK                  0x00000001
-#define INT_STATUS_WDT_INT_GET(x)                (((x) & INT_STATUS_WDT_INT_MASK) >> INT_STATUS_WDT_INT_LSB)
-#define INT_STATUS_WDT_INT_SET(x)                (((x) << INT_STATUS_WDT_INT_LSB) & INT_STATUS_WDT_INT_MASK)
-
-#define LF_TIMER0_ADDRESS                        0x00000048
-#define LF_TIMER0_OFFSET                         0x00000048
-#define LF_TIMER0_TARGET_MSB                     31
-#define LF_TIMER0_TARGET_LSB                     0
-#define LF_TIMER0_TARGET_MASK                    0xffffffff
-#define LF_TIMER0_TARGET_GET(x)                  (((x) & LF_TIMER0_TARGET_MASK) >> LF_TIMER0_TARGET_LSB)
-#define LF_TIMER0_TARGET_SET(x)                  (((x) << LF_TIMER0_TARGET_LSB) & LF_TIMER0_TARGET_MASK)
-
-#define LF_TIMER_COUNT0_ADDRESS                  0x0000004c
-#define LF_TIMER_COUNT0_OFFSET                   0x0000004c
-#define LF_TIMER_COUNT0_VALUE_MSB                31
-#define LF_TIMER_COUNT0_VALUE_LSB                0
-#define LF_TIMER_COUNT0_VALUE_MASK               0xffffffff
-#define LF_TIMER_COUNT0_VALUE_GET(x)             (((x) & LF_TIMER_COUNT0_VALUE_MASK) >> LF_TIMER_COUNT0_VALUE_LSB)
-#define LF_TIMER_COUNT0_VALUE_SET(x)             (((x) << LF_TIMER_COUNT0_VALUE_LSB) & LF_TIMER_COUNT0_VALUE_MASK)
-
-#define LF_TIMER_CONTROL0_ADDRESS                0x00000050
-#define LF_TIMER_CONTROL0_OFFSET                 0x00000050
-#define LF_TIMER_CONTROL0_ENABLE_MSB             2
-#define LF_TIMER_CONTROL0_ENABLE_LSB             2
-#define LF_TIMER_CONTROL0_ENABLE_MASK            0x00000004
-#define LF_TIMER_CONTROL0_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL0_ENABLE_MASK) >> LF_TIMER_CONTROL0_ENABLE_LSB)
-#define LF_TIMER_CONTROL0_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL0_ENABLE_LSB) & LF_TIMER_CONTROL0_ENABLE_MASK)
-#define LF_TIMER_CONTROL0_AUTO_RESTART_MSB       1
-#define LF_TIMER_CONTROL0_AUTO_RESTART_LSB       1
-#define LF_TIMER_CONTROL0_AUTO_RESTART_MASK      0x00000002
-#define LF_TIMER_CONTROL0_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL0_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL0_AUTO_RESTART_LSB)
-#define LF_TIMER_CONTROL0_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL0_AUTO_RESTART_LSB) & LF_TIMER_CONTROL0_AUTO_RESTART_MASK)
-#define LF_TIMER_CONTROL0_RESET_MSB              0
-#define LF_TIMER_CONTROL0_RESET_LSB              0
-#define LF_TIMER_CONTROL0_RESET_MASK             0x00000001
-#define LF_TIMER_CONTROL0_RESET_GET(x)           (((x) & LF_TIMER_CONTROL0_RESET_MASK) >> LF_TIMER_CONTROL0_RESET_LSB)
-#define LF_TIMER_CONTROL0_RESET_SET(x)           (((x) << LF_TIMER_CONTROL0_RESET_LSB) & LF_TIMER_CONTROL0_RESET_MASK)
-
-#define LF_TIMER_STATUS0_ADDRESS                 0x00000054
-#define LF_TIMER_STATUS0_OFFSET                  0x00000054
-#define LF_TIMER_STATUS0_INTERRUPT_MSB           0
-#define LF_TIMER_STATUS0_INTERRUPT_LSB           0
-#define LF_TIMER_STATUS0_INTERRUPT_MASK          0x00000001
-#define LF_TIMER_STATUS0_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS0_INTERRUPT_MASK) >> LF_TIMER_STATUS0_INTERRUPT_LSB)
-#define LF_TIMER_STATUS0_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS0_INTERRUPT_LSB) & LF_TIMER_STATUS0_INTERRUPT_MASK)
-
-#define LF_TIMER1_ADDRESS                        0x00000058
-#define LF_TIMER1_OFFSET                         0x00000058
-#define LF_TIMER1_TARGET_MSB                     31
-#define LF_TIMER1_TARGET_LSB                     0
-#define LF_TIMER1_TARGET_MASK                    0xffffffff
-#define LF_TIMER1_TARGET_GET(x)                  (((x) & LF_TIMER1_TARGET_MASK) >> LF_TIMER1_TARGET_LSB)
-#define LF_TIMER1_TARGET_SET(x)                  (((x) << LF_TIMER1_TARGET_LSB) & LF_TIMER1_TARGET_MASK)
-
-#define LF_TIMER_COUNT1_ADDRESS                  0x0000005c
-#define LF_TIMER_COUNT1_OFFSET                   0x0000005c
-#define LF_TIMER_COUNT1_VALUE_MSB                31
-#define LF_TIMER_COUNT1_VALUE_LSB                0
-#define LF_TIMER_COUNT1_VALUE_MASK               0xffffffff
-#define LF_TIMER_COUNT1_VALUE_GET(x)             (((x) & LF_TIMER_COUNT1_VALUE_MASK) >> LF_TIMER_COUNT1_VALUE_LSB)
-#define LF_TIMER_COUNT1_VALUE_SET(x)             (((x) << LF_TIMER_COUNT1_VALUE_LSB) & LF_TIMER_COUNT1_VALUE_MASK)
-
-#define LF_TIMER_CONTROL1_ADDRESS                0x00000060
-#define LF_TIMER_CONTROL1_OFFSET                 0x00000060
-#define LF_TIMER_CONTROL1_ENABLE_MSB             2
-#define LF_TIMER_CONTROL1_ENABLE_LSB             2
-#define LF_TIMER_CONTROL1_ENABLE_MASK            0x00000004
-#define LF_TIMER_CONTROL1_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL1_ENABLE_MASK) >> LF_TIMER_CONTROL1_ENABLE_LSB)
-#define LF_TIMER_CONTROL1_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL1_ENABLE_LSB) & LF_TIMER_CONTROL1_ENABLE_MASK)
-#define LF_TIMER_CONTROL1_AUTO_RESTART_MSB       1
-#define LF_TIMER_CONTROL1_AUTO_RESTART_LSB       1
-#define LF_TIMER_CONTROL1_AUTO_RESTART_MASK      0x00000002
-#define LF_TIMER_CONTROL1_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL1_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL1_AUTO_RESTART_LSB)
-#define LF_TIMER_CONTROL1_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL1_AUTO_RESTART_LSB) & LF_TIMER_CONTROL1_AUTO_RESTART_MASK)
-#define LF_TIMER_CONTROL1_RESET_MSB              0
-#define LF_TIMER_CONTROL1_RESET_LSB              0
-#define LF_TIMER_CONTROL1_RESET_MASK             0x00000001
-#define LF_TIMER_CONTROL1_RESET_GET(x)           (((x) & LF_TIMER_CONTROL1_RESET_MASK) >> LF_TIMER_CONTROL1_RESET_LSB)
-#define LF_TIMER_CONTROL1_RESET_SET(x)           (((x) << LF_TIMER_CONTROL1_RESET_LSB) & LF_TIMER_CONTROL1_RESET_MASK)
-
-#define LF_TIMER_STATUS1_ADDRESS                 0x00000064
-#define LF_TIMER_STATUS1_OFFSET                  0x00000064
-#define LF_TIMER_STATUS1_INTERRUPT_MSB           0
-#define LF_TIMER_STATUS1_INTERRUPT_LSB           0
-#define LF_TIMER_STATUS1_INTERRUPT_MASK          0x00000001
-#define LF_TIMER_STATUS1_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS1_INTERRUPT_MASK) >> LF_TIMER_STATUS1_INTERRUPT_LSB)
-#define LF_TIMER_STATUS1_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS1_INTERRUPT_LSB) & LF_TIMER_STATUS1_INTERRUPT_MASK)
-
-#define LF_TIMER2_ADDRESS                        0x00000068
-#define LF_TIMER2_OFFSET                         0x00000068
-#define LF_TIMER2_TARGET_MSB                     31
-#define LF_TIMER2_TARGET_LSB                     0
-#define LF_TIMER2_TARGET_MASK                    0xffffffff
-#define LF_TIMER2_TARGET_GET(x)                  (((x) & LF_TIMER2_TARGET_MASK) >> LF_TIMER2_TARGET_LSB)
-#define LF_TIMER2_TARGET_SET(x)                  (((x) << LF_TIMER2_TARGET_LSB) & LF_TIMER2_TARGET_MASK)
-
-#define LF_TIMER_COUNT2_ADDRESS                  0x0000006c
-#define LF_TIMER_COUNT2_OFFSET                   0x0000006c
-#define LF_TIMER_COUNT2_VALUE_MSB                31
-#define LF_TIMER_COUNT2_VALUE_LSB                0
-#define LF_TIMER_COUNT2_VALUE_MASK               0xffffffff
-#define LF_TIMER_COUNT2_VALUE_GET(x)             (((x) & LF_TIMER_COUNT2_VALUE_MASK) >> LF_TIMER_COUNT2_VALUE_LSB)
-#define LF_TIMER_COUNT2_VALUE_SET(x)             (((x) << LF_TIMER_COUNT2_VALUE_LSB) & LF_TIMER_COUNT2_VALUE_MASK)
-
-#define LF_TIMER_CONTROL2_ADDRESS                0x00000070
-#define LF_TIMER_CONTROL2_OFFSET                 0x00000070
-#define LF_TIMER_CONTROL2_ENABLE_MSB             2
-#define LF_TIMER_CONTROL2_ENABLE_LSB             2
-#define LF_TIMER_CONTROL2_ENABLE_MASK            0x00000004
-#define LF_TIMER_CONTROL2_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL2_ENABLE_MASK) >> LF_TIMER_CONTROL2_ENABLE_LSB)
-#define LF_TIMER_CONTROL2_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL2_ENABLE_LSB) & LF_TIMER_CONTROL2_ENABLE_MASK)
-#define LF_TIMER_CONTROL2_AUTO_RESTART_MSB       1
-#define LF_TIMER_CONTROL2_AUTO_RESTART_LSB       1
-#define LF_TIMER_CONTROL2_AUTO_RESTART_MASK      0x00000002
-#define LF_TIMER_CONTROL2_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL2_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL2_AUTO_RESTART_LSB)
-#define LF_TIMER_CONTROL2_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL2_AUTO_RESTART_LSB) & LF_TIMER_CONTROL2_AUTO_RESTART_MASK)
-#define LF_TIMER_CONTROL2_RESET_MSB              0
-#define LF_TIMER_CONTROL2_RESET_LSB              0
-#define LF_TIMER_CONTROL2_RESET_MASK             0x00000001
-#define LF_TIMER_CONTROL2_RESET_GET(x)           (((x) & LF_TIMER_CONTROL2_RESET_MASK) >> LF_TIMER_CONTROL2_RESET_LSB)
-#define LF_TIMER_CONTROL2_RESET_SET(x)           (((x) << LF_TIMER_CONTROL2_RESET_LSB) & LF_TIMER_CONTROL2_RESET_MASK)
-
-#define LF_TIMER_STATUS2_ADDRESS                 0x00000074
-#define LF_TIMER_STATUS2_OFFSET                  0x00000074
-#define LF_TIMER_STATUS2_INTERRUPT_MSB           0
-#define LF_TIMER_STATUS2_INTERRUPT_LSB           0
-#define LF_TIMER_STATUS2_INTERRUPT_MASK          0x00000001
-#define LF_TIMER_STATUS2_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS2_INTERRUPT_MASK) >> LF_TIMER_STATUS2_INTERRUPT_LSB)
-#define LF_TIMER_STATUS2_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS2_INTERRUPT_LSB) & LF_TIMER_STATUS2_INTERRUPT_MASK)
-
-#define LF_TIMER3_ADDRESS                        0x00000078
-#define LF_TIMER3_OFFSET                         0x00000078
-#define LF_TIMER3_TARGET_MSB                     31
-#define LF_TIMER3_TARGET_LSB                     0
-#define LF_TIMER3_TARGET_MASK                    0xffffffff
-#define LF_TIMER3_TARGET_GET(x)                  (((x) & LF_TIMER3_TARGET_MASK) >> LF_TIMER3_TARGET_LSB)
-#define LF_TIMER3_TARGET_SET(x)                  (((x) << LF_TIMER3_TARGET_LSB) & LF_TIMER3_TARGET_MASK)
-
-#define LF_TIMER_COUNT3_ADDRESS                  0x0000007c
-#define LF_TIMER_COUNT3_OFFSET                   0x0000007c
-#define LF_TIMER_COUNT3_VALUE_MSB                31
-#define LF_TIMER_COUNT3_VALUE_LSB                0
-#define LF_TIMER_COUNT3_VALUE_MASK               0xffffffff
-#define LF_TIMER_COUNT3_VALUE_GET(x)             (((x) & LF_TIMER_COUNT3_VALUE_MASK) >> LF_TIMER_COUNT3_VALUE_LSB)
-#define LF_TIMER_COUNT3_VALUE_SET(x)             (((x) << LF_TIMER_COUNT3_VALUE_LSB) & LF_TIMER_COUNT3_VALUE_MASK)
-
-#define LF_TIMER_CONTROL3_ADDRESS                0x00000080
-#define LF_TIMER_CONTROL3_OFFSET                 0x00000080
-#define LF_TIMER_CONTROL3_ENABLE_MSB             2
-#define LF_TIMER_CONTROL3_ENABLE_LSB             2
-#define LF_TIMER_CONTROL3_ENABLE_MASK            0x00000004
-#define LF_TIMER_CONTROL3_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL3_ENABLE_MASK) >> LF_TIMER_CONTROL3_ENABLE_LSB)
-#define LF_TIMER_CONTROL3_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL3_ENABLE_LSB) & LF_TIMER_CONTROL3_ENABLE_MASK)
-#define LF_TIMER_CONTROL3_AUTO_RESTART_MSB       1
-#define LF_TIMER_CONTROL3_AUTO_RESTART_LSB       1
-#define LF_TIMER_CONTROL3_AUTO_RESTART_MASK      0x00000002
-#define LF_TIMER_CONTROL3_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL3_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL3_AUTO_RESTART_LSB)
-#define LF_TIMER_CONTROL3_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL3_AUTO_RESTART_LSB) & LF_TIMER_CONTROL3_AUTO_RESTART_MASK)
-#define LF_TIMER_CONTROL3_RESET_MSB              0
-#define LF_TIMER_CONTROL3_RESET_LSB              0
-#define LF_TIMER_CONTROL3_RESET_MASK             0x00000001
-#define LF_TIMER_CONTROL3_RESET_GET(x)           (((x) & LF_TIMER_CONTROL3_RESET_MASK) >> LF_TIMER_CONTROL3_RESET_LSB)
-#define LF_TIMER_CONTROL3_RESET_SET(x)           (((x) << LF_TIMER_CONTROL3_RESET_LSB) & LF_TIMER_CONTROL3_RESET_MASK)
-
-#define LF_TIMER_STATUS3_ADDRESS                 0x00000084
-#define LF_TIMER_STATUS3_OFFSET                  0x00000084
-#define LF_TIMER_STATUS3_INTERRUPT_MSB           0
-#define LF_TIMER_STATUS3_INTERRUPT_LSB           0
-#define LF_TIMER_STATUS3_INTERRUPT_MASK          0x00000001
-#define LF_TIMER_STATUS3_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS3_INTERRUPT_MASK) >> LF_TIMER_STATUS3_INTERRUPT_LSB)
-#define LF_TIMER_STATUS3_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS3_INTERRUPT_LSB) & LF_TIMER_STATUS3_INTERRUPT_MASK)
-
-#define HF_TIMER_ADDRESS                         0x00000088
-#define HF_TIMER_OFFSET                          0x00000088
-#define HF_TIMER_TARGET_MSB                      31
-#define HF_TIMER_TARGET_LSB                      12
-#define HF_TIMER_TARGET_MASK                     0xfffff000
-#define HF_TIMER_TARGET_GET(x)                   (((x) & HF_TIMER_TARGET_MASK) >> HF_TIMER_TARGET_LSB)
-#define HF_TIMER_TARGET_SET(x)                   (((x) << HF_TIMER_TARGET_LSB) & HF_TIMER_TARGET_MASK)
-
-#define HF_TIMER_COUNT_ADDRESS                   0x0000008c
-#define HF_TIMER_COUNT_OFFSET                    0x0000008c
-#define HF_TIMER_COUNT_VALUE_MSB                 31
-#define HF_TIMER_COUNT_VALUE_LSB                 12
-#define HF_TIMER_COUNT_VALUE_MASK                0xfffff000
-#define HF_TIMER_COUNT_VALUE_GET(x)              (((x) & HF_TIMER_COUNT_VALUE_MASK) >> HF_TIMER_COUNT_VALUE_LSB)
-#define HF_TIMER_COUNT_VALUE_SET(x)              (((x) << HF_TIMER_COUNT_VALUE_LSB) & HF_TIMER_COUNT_VALUE_MASK)
-
-#define HF_LF_COUNT_ADDRESS                      0x00000090
-#define HF_LF_COUNT_OFFSET                       0x00000090
-#define HF_LF_COUNT_VALUE_MSB                    31
-#define HF_LF_COUNT_VALUE_LSB                    0
-#define HF_LF_COUNT_VALUE_MASK                   0xffffffff
-#define HF_LF_COUNT_VALUE_GET(x)                 (((x) & HF_LF_COUNT_VALUE_MASK) >> HF_LF_COUNT_VALUE_LSB)
-#define HF_LF_COUNT_VALUE_SET(x)                 (((x) << HF_LF_COUNT_VALUE_LSB) & HF_LF_COUNT_VALUE_MASK)
-
-#define HF_TIMER_CONTROL_ADDRESS                 0x00000094
-#define HF_TIMER_CONTROL_OFFSET                  0x00000094
-#define HF_TIMER_CONTROL_ENABLE_MSB              3
-#define HF_TIMER_CONTROL_ENABLE_LSB              3
-#define HF_TIMER_CONTROL_ENABLE_MASK             0x00000008
-#define HF_TIMER_CONTROL_ENABLE_GET(x)           (((x) & HF_TIMER_CONTROL_ENABLE_MASK) >> HF_TIMER_CONTROL_ENABLE_LSB)
-#define HF_TIMER_CONTROL_ENABLE_SET(x)           (((x) << HF_TIMER_CONTROL_ENABLE_LSB) & HF_TIMER_CONTROL_ENABLE_MASK)
-#define HF_TIMER_CONTROL_ON_MSB                  2
-#define HF_TIMER_CONTROL_ON_LSB                  2
-#define HF_TIMER_CONTROL_ON_MASK                 0x00000004
-#define HF_TIMER_CONTROL_ON_GET(x)               (((x) & HF_TIMER_CONTROL_ON_MASK) >> HF_TIMER_CONTROL_ON_LSB)
-#define HF_TIMER_CONTROL_ON_SET(x)               (((x) << HF_TIMER_CONTROL_ON_LSB) & HF_TIMER_CONTROL_ON_MASK)
-#define HF_TIMER_CONTROL_AUTO_RESTART_MSB        1
-#define HF_TIMER_CONTROL_AUTO_RESTART_LSB        1
-#define HF_TIMER_CONTROL_AUTO_RESTART_MASK       0x00000002
-#define HF_TIMER_CONTROL_AUTO_RESTART_GET(x)     (((x) & HF_TIMER_CONTROL_AUTO_RESTART_MASK) >> HF_TIMER_CONTROL_AUTO_RESTART_LSB)
-#define HF_TIMER_CONTROL_AUTO_RESTART_SET(x)     (((x) << HF_TIMER_CONTROL_AUTO_RESTART_LSB) & HF_TIMER_CONTROL_AUTO_RESTART_MASK)
-#define HF_TIMER_CONTROL_RESET_MSB               0
-#define HF_TIMER_CONTROL_RESET_LSB               0
-#define HF_TIMER_CONTROL_RESET_MASK              0x00000001
-#define HF_TIMER_CONTROL_RESET_GET(x)            (((x) & HF_TIMER_CONTROL_RESET_MASK) >> HF_TIMER_CONTROL_RESET_LSB)
-#define HF_TIMER_CONTROL_RESET_SET(x)            (((x) << HF_TIMER_CONTROL_RESET_LSB) & HF_TIMER_CONTROL_RESET_MASK)
-
-#define HF_TIMER_STATUS_ADDRESS                  0x00000098
-#define HF_TIMER_STATUS_OFFSET                   0x00000098
-#define HF_TIMER_STATUS_INTERRUPT_MSB            0
-#define HF_TIMER_STATUS_INTERRUPT_LSB            0
-#define HF_TIMER_STATUS_INTERRUPT_MASK           0x00000001
-#define HF_TIMER_STATUS_INTERRUPT_GET(x)         (((x) & HF_TIMER_STATUS_INTERRUPT_MASK) >> HF_TIMER_STATUS_INTERRUPT_LSB)
-#define HF_TIMER_STATUS_INTERRUPT_SET(x)         (((x) << HF_TIMER_STATUS_INTERRUPT_LSB) & HF_TIMER_STATUS_INTERRUPT_MASK)
-
-#define RTC_CONTROL_ADDRESS                      0x0000009c
-#define RTC_CONTROL_OFFSET                       0x0000009c
-#define RTC_CONTROL_ENABLE_MSB                   2
-#define RTC_CONTROL_ENABLE_LSB                   2
-#define RTC_CONTROL_ENABLE_MASK                  0x00000004
-#define RTC_CONTROL_ENABLE_GET(x)                (((x) & RTC_CONTROL_ENABLE_MASK) >> RTC_CONTROL_ENABLE_LSB)
-#define RTC_CONTROL_ENABLE_SET(x)                (((x) << RTC_CONTROL_ENABLE_LSB) & RTC_CONTROL_ENABLE_MASK)
-#define RTC_CONTROL_LOAD_RTC_MSB                 1
-#define RTC_CONTROL_LOAD_RTC_LSB                 1
-#define RTC_CONTROL_LOAD_RTC_MASK                0x00000002
-#define RTC_CONTROL_LOAD_RTC_GET(x)              (((x) & RTC_CONTROL_LOAD_RTC_MASK) >> RTC_CONTROL_LOAD_RTC_LSB)
-#define RTC_CONTROL_LOAD_RTC_SET(x)              (((x) << RTC_CONTROL_LOAD_RTC_LSB) & RTC_CONTROL_LOAD_RTC_MASK)
-#define RTC_CONTROL_LOAD_ALARM_MSB               0
-#define RTC_CONTROL_LOAD_ALARM_LSB               0
-#define RTC_CONTROL_LOAD_ALARM_MASK              0x00000001
-#define RTC_CONTROL_LOAD_ALARM_GET(x)            (((x) & RTC_CONTROL_LOAD_ALARM_MASK) >> RTC_CONTROL_LOAD_ALARM_LSB)
-#define RTC_CONTROL_LOAD_ALARM_SET(x)            (((x) << RTC_CONTROL_LOAD_ALARM_LSB) & RTC_CONTROL_LOAD_ALARM_MASK)
-
-#define RTC_TIME_ADDRESS                         0x000000a0
-#define RTC_TIME_OFFSET                          0x000000a0
-#define RTC_TIME_WEEK_DAY_MSB                    26
-#define RTC_TIME_WEEK_DAY_LSB                    24
-#define RTC_TIME_WEEK_DAY_MASK                   0x07000000
-#define RTC_TIME_WEEK_DAY_GET(x)                 (((x) & RTC_TIME_WEEK_DAY_MASK) >> RTC_TIME_WEEK_DAY_LSB)
-#define RTC_TIME_WEEK_DAY_SET(x)                 (((x) << RTC_TIME_WEEK_DAY_LSB) & RTC_TIME_WEEK_DAY_MASK)
-#define RTC_TIME_HOUR_MSB                        21
-#define RTC_TIME_HOUR_LSB                        16
-#define RTC_TIME_HOUR_MASK                       0x003f0000
-#define RTC_TIME_HOUR_GET(x)                     (((x) & RTC_TIME_HOUR_MASK) >> RTC_TIME_HOUR_LSB)
-#define RTC_TIME_HOUR_SET(x)                     (((x) << RTC_TIME_HOUR_LSB) & RTC_TIME_HOUR_MASK)
-#define RTC_TIME_MINUTE_MSB                      14
-#define RTC_TIME_MINUTE_LSB                      8
-#define RTC_TIME_MINUTE_MASK                     0x00007f00
-#define RTC_TIME_MINUTE_GET(x)                   (((x) & RTC_TIME_MINUTE_MASK) >> RTC_TIME_MINUTE_LSB)
-#define RTC_TIME_MINUTE_SET(x)                   (((x) << RTC_TIME_MINUTE_LSB) & RTC_TIME_MINUTE_MASK)
-#define RTC_TIME_SECOND_MSB                      6
-#define RTC_TIME_SECOND_LSB                      0
-#define RTC_TIME_SECOND_MASK                     0x0000007f
-#define RTC_TIME_SECOND_GET(x)                   (((x) & RTC_TIME_SECOND_MASK) >> RTC_TIME_SECOND_LSB)
-#define RTC_TIME_SECOND_SET(x)                   (((x) << RTC_TIME_SECOND_LSB) & RTC_TIME_SECOND_MASK)
-
-#define RTC_DATE_ADDRESS                         0x000000a4
-#define RTC_DATE_OFFSET                          0x000000a4
-#define RTC_DATE_YEAR_MSB                        23
-#define RTC_DATE_YEAR_LSB                        16
-#define RTC_DATE_YEAR_MASK                       0x00ff0000
-#define RTC_DATE_YEAR_GET(x)                     (((x) & RTC_DATE_YEAR_MASK) >> RTC_DATE_YEAR_LSB)
-#define RTC_DATE_YEAR_SET(x)                     (((x) << RTC_DATE_YEAR_LSB) & RTC_DATE_YEAR_MASK)
-#define RTC_DATE_MONTH_MSB                       12
-#define RTC_DATE_MONTH_LSB                       8
-#define RTC_DATE_MONTH_MASK                      0x00001f00
-#define RTC_DATE_MONTH_GET(x)                    (((x) & RTC_DATE_MONTH_MASK) >> RTC_DATE_MONTH_LSB)
-#define RTC_DATE_MONTH_SET(x)                    (((x) << RTC_DATE_MONTH_LSB) & RTC_DATE_MONTH_MASK)
-#define RTC_DATE_MONTH_DAY_MSB                   5
-#define RTC_DATE_MONTH_DAY_LSB                   0
-#define RTC_DATE_MONTH_DAY_MASK                  0x0000003f
-#define RTC_DATE_MONTH_DAY_GET(x)                (((x) & RTC_DATE_MONTH_DAY_MASK) >> RTC_DATE_MONTH_DAY_LSB)
-#define RTC_DATE_MONTH_DAY_SET(x)                (((x) << RTC_DATE_MONTH_DAY_LSB) & RTC_DATE_MONTH_DAY_MASK)
-
-#define RTC_SET_TIME_ADDRESS                     0x000000a8
-#define RTC_SET_TIME_OFFSET                      0x000000a8
-#define RTC_SET_TIME_WEEK_DAY_MSB                26
-#define RTC_SET_TIME_WEEK_DAY_LSB                24
-#define RTC_SET_TIME_WEEK_DAY_MASK               0x07000000
-#define RTC_SET_TIME_WEEK_DAY_GET(x)             (((x) & RTC_SET_TIME_WEEK_DAY_MASK) >> RTC_SET_TIME_WEEK_DAY_LSB)
-#define RTC_SET_TIME_WEEK_DAY_SET(x)             (((x) << RTC_SET_TIME_WEEK_DAY_LSB) & RTC_SET_TIME_WEEK_DAY_MASK)
-#define RTC_SET_TIME_HOUR_MSB                    21
-#define RTC_SET_TIME_HOUR_LSB                    16
-#define RTC_SET_TIME_HOUR_MASK                   0x003f0000
-#define RTC_SET_TIME_HOUR_GET(x)                 (((x) & RTC_SET_TIME_HOUR_MASK) >> RTC_SET_TIME_HOUR_LSB)
-#define RTC_SET_TIME_HOUR_SET(x)                 (((x) << RTC_SET_TIME_HOUR_LSB) & RTC_SET_TIME_HOUR_MASK)
-#define RTC_SET_TIME_MINUTE_MSB                  14
-#define RTC_SET_TIME_MINUTE_LSB                  8
-#define RTC_SET_TIME_MINUTE_MASK                 0x00007f00
-#define RTC_SET_TIME_MINUTE_GET(x)               (((x) & RTC_SET_TIME_MINUTE_MASK) >> RTC_SET_TIME_MINUTE_LSB)
-#define RTC_SET_TIME_MINUTE_SET(x)               (((x) << RTC_SET_TIME_MINUTE_LSB) & RTC_SET_TIME_MINUTE_MASK)
-#define RTC_SET_TIME_SECOND_MSB                  6
-#define RTC_SET_TIME_SECOND_LSB                  0
-#define RTC_SET_TIME_SECOND_MASK                 0x0000007f
-#define RTC_SET_TIME_SECOND_GET(x)               (((x) & RTC_SET_TIME_SECOND_MASK) >> RTC_SET_TIME_SECOND_LSB)
-#define RTC_SET_TIME_SECOND_SET(x)               (((x) << RTC_SET_TIME_SECOND_LSB) & RTC_SET_TIME_SECOND_MASK)
-
-#define RTC_SET_DATE_ADDRESS                     0x000000ac
-#define RTC_SET_DATE_OFFSET                      0x000000ac
-#define RTC_SET_DATE_YEAR_MSB                    23
-#define RTC_SET_DATE_YEAR_LSB                    16
-#define RTC_SET_DATE_YEAR_MASK                   0x00ff0000
-#define RTC_SET_DATE_YEAR_GET(x)                 (((x) & RTC_SET_DATE_YEAR_MASK) >> RTC_SET_DATE_YEAR_LSB)
-#define RTC_SET_DATE_YEAR_SET(x)                 (((x) << RTC_SET_DATE_YEAR_LSB) & RTC_SET_DATE_YEAR_MASK)
-#define RTC_SET_DATE_MONTH_MSB                   12
-#define RTC_SET_DATE_MONTH_LSB                   8
-#define RTC_SET_DATE_MONTH_MASK                  0x00001f00
-#define RTC_SET_DATE_MONTH_GET(x)                (((x) & RTC_SET_DATE_MONTH_MASK) >> RTC_SET_DATE_MONTH_LSB)
-#define RTC_SET_DATE_MONTH_SET(x)                (((x) << RTC_SET_DATE_MONTH_LSB) & RTC_SET_DATE_MONTH_MASK)
-#define RTC_SET_DATE_MONTH_DAY_MSB               5
-#define RTC_SET_DATE_MONTH_DAY_LSB               0
-#define RTC_SET_DATE_MONTH_DAY_MASK              0x0000003f
-#define RTC_SET_DATE_MONTH_DAY_GET(x)            (((x) & RTC_SET_DATE_MONTH_DAY_MASK) >> RTC_SET_DATE_MONTH_DAY_LSB)
-#define RTC_SET_DATE_MONTH_DAY_SET(x)            (((x) << RTC_SET_DATE_MONTH_DAY_LSB) & RTC_SET_DATE_MONTH_DAY_MASK)
-
-#define RTC_SET_ALARM_ADDRESS                    0x000000b0
-#define RTC_SET_ALARM_OFFSET                     0x000000b0
-#define RTC_SET_ALARM_HOUR_MSB                   21
-#define RTC_SET_ALARM_HOUR_LSB                   16
-#define RTC_SET_ALARM_HOUR_MASK                  0x003f0000
-#define RTC_SET_ALARM_HOUR_GET(x)                (((x) & RTC_SET_ALARM_HOUR_MASK) >> RTC_SET_ALARM_HOUR_LSB)
-#define RTC_SET_ALARM_HOUR_SET(x)                (((x) << RTC_SET_ALARM_HOUR_LSB) & RTC_SET_ALARM_HOUR_MASK)
-#define RTC_SET_ALARM_MINUTE_MSB                 14
-#define RTC_SET_ALARM_MINUTE_LSB                 8
-#define RTC_SET_ALARM_MINUTE_MASK                0x00007f00
-#define RTC_SET_ALARM_MINUTE_GET(x)              (((x) & RTC_SET_ALARM_MINUTE_MASK) >> RTC_SET_ALARM_MINUTE_LSB)
-#define RTC_SET_ALARM_MINUTE_SET(x)              (((x) << RTC_SET_ALARM_MINUTE_LSB) & RTC_SET_ALARM_MINUTE_MASK)
-#define RTC_SET_ALARM_SECOND_MSB                 6
-#define RTC_SET_ALARM_SECOND_LSB                 0
-#define RTC_SET_ALARM_SECOND_MASK                0x0000007f
-#define RTC_SET_ALARM_SECOND_GET(x)              (((x) & RTC_SET_ALARM_SECOND_MASK) >> RTC_SET_ALARM_SECOND_LSB)
-#define RTC_SET_ALARM_SECOND_SET(x)              (((x) << RTC_SET_ALARM_SECOND_LSB) & RTC_SET_ALARM_SECOND_MASK)
-
-#define RTC_CONFIG_ADDRESS                       0x000000b4
-#define RTC_CONFIG_OFFSET                        0x000000b4
-#define RTC_CONFIG_BCD_MSB                       2
-#define RTC_CONFIG_BCD_LSB                       2
-#define RTC_CONFIG_BCD_MASK                      0x00000004
-#define RTC_CONFIG_BCD_GET(x)                    (((x) & RTC_CONFIG_BCD_MASK) >> RTC_CONFIG_BCD_LSB)
-#define RTC_CONFIG_BCD_SET(x)                    (((x) << RTC_CONFIG_BCD_LSB) & RTC_CONFIG_BCD_MASK)
-#define RTC_CONFIG_TWELVE_HOUR_MSB               1
-#define RTC_CONFIG_TWELVE_HOUR_LSB               1
-#define RTC_CONFIG_TWELVE_HOUR_MASK              0x00000002
-#define RTC_CONFIG_TWELVE_HOUR_GET(x)            (((x) & RTC_CONFIG_TWELVE_HOUR_MASK) >> RTC_CONFIG_TWELVE_HOUR_LSB)
-#define RTC_CONFIG_TWELVE_HOUR_SET(x)            (((x) << RTC_CONFIG_TWELVE_HOUR_LSB) & RTC_CONFIG_TWELVE_HOUR_MASK)
-#define RTC_CONFIG_DSE_MSB                       0
-#define RTC_CONFIG_DSE_LSB                       0
-#define RTC_CONFIG_DSE_MASK                      0x00000001
-#define RTC_CONFIG_DSE_GET(x)                    (((x) & RTC_CONFIG_DSE_MASK) >> RTC_CONFIG_DSE_LSB)
-#define RTC_CONFIG_DSE_SET(x)                    (((x) << RTC_CONFIG_DSE_LSB) & RTC_CONFIG_DSE_MASK)
-
-#define RTC_ALARM_STATUS_ADDRESS                 0x000000b8
-#define RTC_ALARM_STATUS_OFFSET                  0x000000b8
-#define RTC_ALARM_STATUS_ENABLE_MSB              1
-#define RTC_ALARM_STATUS_ENABLE_LSB              1
-#define RTC_ALARM_STATUS_ENABLE_MASK             0x00000002
-#define RTC_ALARM_STATUS_ENABLE_GET(x)           (((x) & RTC_ALARM_STATUS_ENABLE_MASK) >> RTC_ALARM_STATUS_ENABLE_LSB)
-#define RTC_ALARM_STATUS_ENABLE_SET(x)           (((x) << RTC_ALARM_STATUS_ENABLE_LSB) & RTC_ALARM_STATUS_ENABLE_MASK)
-#define RTC_ALARM_STATUS_INTERRUPT_MSB           0
-#define RTC_ALARM_STATUS_INTERRUPT_LSB           0
-#define RTC_ALARM_STATUS_INTERRUPT_MASK          0x00000001
-#define RTC_ALARM_STATUS_INTERRUPT_GET(x)        (((x) & RTC_ALARM_STATUS_INTERRUPT_MASK) >> RTC_ALARM_STATUS_INTERRUPT_LSB)
-#define RTC_ALARM_STATUS_INTERRUPT_SET(x)        (((x) << RTC_ALARM_STATUS_INTERRUPT_LSB) & RTC_ALARM_STATUS_INTERRUPT_MASK)
-
-#define UART_WAKEUP_ADDRESS                      0x000000bc
-#define UART_WAKEUP_OFFSET                       0x000000bc
-#define UART_WAKEUP_ENABLE_MSB                   0
-#define UART_WAKEUP_ENABLE_LSB                   0
-#define UART_WAKEUP_ENABLE_MASK                  0x00000001
-#define UART_WAKEUP_ENABLE_GET(x)                (((x) & UART_WAKEUP_ENABLE_MASK) >> UART_WAKEUP_ENABLE_LSB)
-#define UART_WAKEUP_ENABLE_SET(x)                (((x) << UART_WAKEUP_ENABLE_LSB) & UART_WAKEUP_ENABLE_MASK)
-
-#define RESET_CAUSE_ADDRESS                      0x000000c0
-#define RESET_CAUSE_OFFSET                       0x000000c0
-#define RESET_CAUSE_LAST_MSB                     2
-#define RESET_CAUSE_LAST_LSB                     0
-#define RESET_CAUSE_LAST_MASK                    0x00000007
-#define RESET_CAUSE_LAST_GET(x)                  (((x) & RESET_CAUSE_LAST_MASK) >> RESET_CAUSE_LAST_LSB)
-#define RESET_CAUSE_LAST_SET(x)                  (((x) << RESET_CAUSE_LAST_LSB) & RESET_CAUSE_LAST_MASK)
-
-#define SYSTEM_SLEEP_ADDRESS                     0x000000c4
-#define SYSTEM_SLEEP_OFFSET                      0x000000c4
-#define SYSTEM_SLEEP_HOST_IF_MSB                 4
-#define SYSTEM_SLEEP_HOST_IF_LSB                 4
-#define SYSTEM_SLEEP_HOST_IF_MASK                0x00000010
-#define SYSTEM_SLEEP_HOST_IF_GET(x)              (((x) & SYSTEM_SLEEP_HOST_IF_MASK) >> SYSTEM_SLEEP_HOST_IF_LSB)
-#define SYSTEM_SLEEP_HOST_IF_SET(x)              (((x) << SYSTEM_SLEEP_HOST_IF_LSB) & SYSTEM_SLEEP_HOST_IF_MASK)
-#define SYSTEM_SLEEP_MBOX_MSB                    3
-#define SYSTEM_SLEEP_MBOX_LSB                    3
-#define SYSTEM_SLEEP_MBOX_MASK                   0x00000008
-#define SYSTEM_SLEEP_MBOX_GET(x)                 (((x) & SYSTEM_SLEEP_MBOX_MASK) >> SYSTEM_SLEEP_MBOX_LSB)
-#define SYSTEM_SLEEP_MBOX_SET(x)                 (((x) << SYSTEM_SLEEP_MBOX_LSB) & SYSTEM_SLEEP_MBOX_MASK)
-#define SYSTEM_SLEEP_MAC_IF_MSB                  2
-#define SYSTEM_SLEEP_MAC_IF_LSB                  2
-#define SYSTEM_SLEEP_MAC_IF_MASK                 0x00000004
-#define SYSTEM_SLEEP_MAC_IF_GET(x)               (((x) & SYSTEM_SLEEP_MAC_IF_MASK) >> SYSTEM_SLEEP_MAC_IF_LSB)
-#define SYSTEM_SLEEP_MAC_IF_SET(x)               (((x) << SYSTEM_SLEEP_MAC_IF_LSB) & SYSTEM_SLEEP_MAC_IF_MASK)
-#define SYSTEM_SLEEP_LIGHT_MSB                   1
-#define SYSTEM_SLEEP_LIGHT_LSB                   1
-#define SYSTEM_SLEEP_LIGHT_MASK                  0x00000002
-#define SYSTEM_SLEEP_LIGHT_GET(x)                (((x) & SYSTEM_SLEEP_LIGHT_MASK) >> SYSTEM_SLEEP_LIGHT_LSB)
-#define SYSTEM_SLEEP_LIGHT_SET(x)                (((x) << SYSTEM_SLEEP_LIGHT_LSB) & SYSTEM_SLEEP_LIGHT_MASK)
-#define SYSTEM_SLEEP_DISABLE_MSB                 0
-#define SYSTEM_SLEEP_DISABLE_LSB                 0
-#define SYSTEM_SLEEP_DISABLE_MASK                0x00000001
-#define SYSTEM_SLEEP_DISABLE_GET(x)              (((x) & SYSTEM_SLEEP_DISABLE_MASK) >> SYSTEM_SLEEP_DISABLE_LSB)
-#define SYSTEM_SLEEP_DISABLE_SET(x)              (((x) << SYSTEM_SLEEP_DISABLE_LSB) & SYSTEM_SLEEP_DISABLE_MASK)
-
-#define SDIO_WRAPPER_ADDRESS                     0x000000c8
-#define SDIO_WRAPPER_OFFSET                      0x000000c8
-#define SDIO_WRAPPER_SLEEP_MSB                   3
-#define SDIO_WRAPPER_SLEEP_LSB                   3
-#define SDIO_WRAPPER_SLEEP_MASK                  0x00000008
-#define SDIO_WRAPPER_SLEEP_GET(x)                (((x) & SDIO_WRAPPER_SLEEP_MASK) >> SDIO_WRAPPER_SLEEP_LSB)
-#define SDIO_WRAPPER_SLEEP_SET(x)                (((x) << SDIO_WRAPPER_SLEEP_LSB) & SDIO_WRAPPER_SLEEP_MASK)
-#define SDIO_WRAPPER_WAKEUP_MSB                  2
-#define SDIO_WRAPPER_WAKEUP_LSB                  2
-#define SDIO_WRAPPER_WAKEUP_MASK                 0x00000004
-#define SDIO_WRAPPER_WAKEUP_GET(x)               (((x) & SDIO_WRAPPER_WAKEUP_MASK) >> SDIO_WRAPPER_WAKEUP_LSB)
-#define SDIO_WRAPPER_WAKEUP_SET(x)               (((x) << SDIO_WRAPPER_WAKEUP_LSB) & SDIO_WRAPPER_WAKEUP_MASK)
-#define SDIO_WRAPPER_SOC_ON_MSB                  1
-#define SDIO_WRAPPER_SOC_ON_LSB                  1
-#define SDIO_WRAPPER_SOC_ON_MASK                 0x00000002
-#define SDIO_WRAPPER_SOC_ON_GET(x)               (((x) & SDIO_WRAPPER_SOC_ON_MASK) >> SDIO_WRAPPER_SOC_ON_LSB)
-#define SDIO_WRAPPER_SOC_ON_SET(x)               (((x) << SDIO_WRAPPER_SOC_ON_LSB) & SDIO_WRAPPER_SOC_ON_MASK)
-#define SDIO_WRAPPER_ON_MSB                      0
-#define SDIO_WRAPPER_ON_LSB                      0
-#define SDIO_WRAPPER_ON_MASK                     0x00000001
-#define SDIO_WRAPPER_ON_GET(x)                   (((x) & SDIO_WRAPPER_ON_MASK) >> SDIO_WRAPPER_ON_LSB)
-#define SDIO_WRAPPER_ON_SET(x)                   (((x) << SDIO_WRAPPER_ON_LSB) & SDIO_WRAPPER_ON_MASK)
-
-#define MAC_SLEEP_CONTROL_ADDRESS                0x000000cc
-#define MAC_SLEEP_CONTROL_OFFSET                 0x000000cc
-#define MAC_SLEEP_CONTROL_ENABLE_MSB             1
-#define MAC_SLEEP_CONTROL_ENABLE_LSB             0
-#define MAC_SLEEP_CONTROL_ENABLE_MASK            0x00000003
-#define MAC_SLEEP_CONTROL_ENABLE_GET(x)          (((x) & MAC_SLEEP_CONTROL_ENABLE_MASK) >> MAC_SLEEP_CONTROL_ENABLE_LSB)
-#define MAC_SLEEP_CONTROL_ENABLE_SET(x)          (((x) << MAC_SLEEP_CONTROL_ENABLE_LSB) & MAC_SLEEP_CONTROL_ENABLE_MASK)
-
-#define KEEP_AWAKE_ADDRESS                       0x000000d0
-#define KEEP_AWAKE_OFFSET                        0x000000d0
-#define KEEP_AWAKE_COUNT_MSB                     7
-#define KEEP_AWAKE_COUNT_LSB                     0
-#define KEEP_AWAKE_COUNT_MASK                    0x000000ff
-#define KEEP_AWAKE_COUNT_GET(x)                  (((x) & KEEP_AWAKE_COUNT_MASK) >> KEEP_AWAKE_COUNT_LSB)
-#define KEEP_AWAKE_COUNT_SET(x)                  (((x) << KEEP_AWAKE_COUNT_LSB) & KEEP_AWAKE_COUNT_MASK)
-
-#define LPO_CAL_TIME_ADDRESS                     0x000000d4
-#define LPO_CAL_TIME_OFFSET                      0x000000d4
-#define LPO_CAL_TIME_LENGTH_MSB                  13
-#define LPO_CAL_TIME_LENGTH_LSB                  0
-#define LPO_CAL_TIME_LENGTH_MASK                 0x00003fff
-#define LPO_CAL_TIME_LENGTH_GET(x)               (((x) & LPO_CAL_TIME_LENGTH_MASK) >> LPO_CAL_TIME_LENGTH_LSB)
-#define LPO_CAL_TIME_LENGTH_SET(x)               (((x) << LPO_CAL_TIME_LENGTH_LSB) & LPO_CAL_TIME_LENGTH_MASK)
-
-#define LPO_INIT_DIVIDEND_INT_ADDRESS            0x000000d8
-#define LPO_INIT_DIVIDEND_INT_OFFSET             0x000000d8
-#define LPO_INIT_DIVIDEND_INT_VALUE_MSB          23
-#define LPO_INIT_DIVIDEND_INT_VALUE_LSB          0
-#define LPO_INIT_DIVIDEND_INT_VALUE_MASK         0x00ffffff
-#define LPO_INIT_DIVIDEND_INT_VALUE_GET(x)       (((x) & LPO_INIT_DIVIDEND_INT_VALUE_MASK) >> LPO_INIT_DIVIDEND_INT_VALUE_LSB)
-#define LPO_INIT_DIVIDEND_INT_VALUE_SET(x)       (((x) << LPO_INIT_DIVIDEND_INT_VALUE_LSB) & LPO_INIT_DIVIDEND_INT_VALUE_MASK)
-
-#define LPO_INIT_DIVIDEND_FRACTION_ADDRESS       0x000000dc
-#define LPO_INIT_DIVIDEND_FRACTION_OFFSET        0x000000dc
-#define LPO_INIT_DIVIDEND_FRACTION_VALUE_MSB     10
-#define LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB     0
-#define LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK    0x000007ff
-#define LPO_INIT_DIVIDEND_FRACTION_VALUE_GET(x)  (((x) & LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK) >> LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB)
-#define LPO_INIT_DIVIDEND_FRACTION_VALUE_SET(x)  (((x) << LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB) & LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK)
-
-#define LPO_CAL_ADDRESS                          0x000000e0
-#define LPO_CAL_OFFSET                           0x000000e0
-#define LPO_CAL_ENABLE_MSB                       20
-#define LPO_CAL_ENABLE_LSB                       20
-#define LPO_CAL_ENABLE_MASK                      0x00100000
-#define LPO_CAL_ENABLE_GET(x)                    (((x) & LPO_CAL_ENABLE_MASK) >> LPO_CAL_ENABLE_LSB)
-#define LPO_CAL_ENABLE_SET(x)                    (((x) << LPO_CAL_ENABLE_LSB) & LPO_CAL_ENABLE_MASK)
-#define LPO_CAL_COUNT_MSB                        19
-#define LPO_CAL_COUNT_LSB                        0
-#define LPO_CAL_COUNT_MASK                       0x000fffff
-#define LPO_CAL_COUNT_GET(x)                     (((x) & LPO_CAL_COUNT_MASK) >> LPO_CAL_COUNT_LSB)
-#define LPO_CAL_COUNT_SET(x)                     (((x) << LPO_CAL_COUNT_LSB) & LPO_CAL_COUNT_MASK)
-
-#define LPO_CAL_TEST_CONTROL_ADDRESS             0x000000e4
-#define LPO_CAL_TEST_CONTROL_OFFSET              0x000000e4
-#define LPO_CAL_TEST_CONTROL_ENABLE_MSB          5
-#define LPO_CAL_TEST_CONTROL_ENABLE_LSB          5
-#define LPO_CAL_TEST_CONTROL_ENABLE_MASK         0x00000020
-#define LPO_CAL_TEST_CONTROL_ENABLE_GET(x)       (((x) & LPO_CAL_TEST_CONTROL_ENABLE_MASK) >> LPO_CAL_TEST_CONTROL_ENABLE_LSB)
-#define LPO_CAL_TEST_CONTROL_ENABLE_SET(x)       (((x) << LPO_CAL_TEST_CONTROL_ENABLE_LSB) & LPO_CAL_TEST_CONTROL_ENABLE_MASK)
-#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_MSB      4
-#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB      0
-#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK     0x0000001f
-#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_GET(x)   (((x) & LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK) >> LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB)
-#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_SET(x)   (((x) << LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB) & LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK)
-
-#define LPO_CAL_TEST_STATUS_ADDRESS              0x000000e8
-#define LPO_CAL_TEST_STATUS_OFFSET               0x000000e8
-#define LPO_CAL_TEST_STATUS_READY_MSB            16
-#define LPO_CAL_TEST_STATUS_READY_LSB            16
-#define LPO_CAL_TEST_STATUS_READY_MASK           0x00010000
-#define LPO_CAL_TEST_STATUS_READY_GET(x)         (((x) & LPO_CAL_TEST_STATUS_READY_MASK) >> LPO_CAL_TEST_STATUS_READY_LSB)
-#define LPO_CAL_TEST_STATUS_READY_SET(x)         (((x) << LPO_CAL_TEST_STATUS_READY_LSB) & LPO_CAL_TEST_STATUS_READY_MASK)
-#define LPO_CAL_TEST_STATUS_COUNT_MSB            15
-#define LPO_CAL_TEST_STATUS_COUNT_LSB            0
-#define LPO_CAL_TEST_STATUS_COUNT_MASK           0x0000ffff
-#define LPO_CAL_TEST_STATUS_COUNT_GET(x)         (((x) & LPO_CAL_TEST_STATUS_COUNT_MASK) >> LPO_CAL_TEST_STATUS_COUNT_LSB)
-#define LPO_CAL_TEST_STATUS_COUNT_SET(x)         (((x) << LPO_CAL_TEST_STATUS_COUNT_LSB) & LPO_CAL_TEST_STATUS_COUNT_MASK)
-
-#define CHIP_ID_ADDRESS                          0x000000ec
-#define CHIP_ID_OFFSET                           0x000000ec
-#define CHIP_ID_DEVICE_ID_MSB                    31
-#define CHIP_ID_DEVICE_ID_LSB                    16
-#define CHIP_ID_DEVICE_ID_MASK                   0xffff0000
-#define CHIP_ID_DEVICE_ID_GET(x)                 (((x) & CHIP_ID_DEVICE_ID_MASK) >> CHIP_ID_DEVICE_ID_LSB)
-#define CHIP_ID_DEVICE_ID_SET(x)                 (((x) << CHIP_ID_DEVICE_ID_LSB) & CHIP_ID_DEVICE_ID_MASK)
-#define CHIP_ID_CONFIG_ID_MSB                    15
-#define CHIP_ID_CONFIG_ID_LSB                    4
-#define CHIP_ID_CONFIG_ID_MASK                   0x0000fff0
-#define CHIP_ID_CONFIG_ID_GET(x)                 (((x) & CHIP_ID_CONFIG_ID_MASK) >> CHIP_ID_CONFIG_ID_LSB)
-#define CHIP_ID_CONFIG_ID_SET(x)                 (((x) << CHIP_ID_CONFIG_ID_LSB) & CHIP_ID_CONFIG_ID_MASK)
-#define CHIP_ID_VERSION_ID_MSB                   3
-#define CHIP_ID_VERSION_ID_LSB                   0
-#define CHIP_ID_VERSION_ID_MASK                  0x0000000f
-#define CHIP_ID_VERSION_ID_GET(x)                (((x) & CHIP_ID_VERSION_ID_MASK) >> CHIP_ID_VERSION_ID_LSB)
-#define CHIP_ID_VERSION_ID_SET(x)                (((x) << CHIP_ID_VERSION_ID_LSB) & CHIP_ID_VERSION_ID_MASK)
-
-#define DERIVED_RTC_CLK_ADDRESS                  0x000000f0
-#define DERIVED_RTC_CLK_OFFSET                   0x000000f0
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MSB   20
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB   20
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK  0x00100000
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_GET(x) (((x) & DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK) >> DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB)
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_SET(x) (((x) << DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB) & DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK)
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_MSB      18
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB      18
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK     0x00040000
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_GET(x)   (((x) & DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK) >> DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB)
-#define DERIVED_RTC_CLK_EXTERNAL_DETECT_SET(x)   (((x) << DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB) & DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK)
-#define DERIVED_RTC_CLK_FORCE_MSB                17
-#define DERIVED_RTC_CLK_FORCE_LSB                16
-#define DERIVED_RTC_CLK_FORCE_MASK               0x00030000
-#define DERIVED_RTC_CLK_FORCE_GET(x)             (((x) & DERIVED_RTC_CLK_FORCE_MASK) >> DERIVED_RTC_CLK_FORCE_LSB)
-#define DERIVED_RTC_CLK_FORCE_SET(x)             (((x) << DERIVED_RTC_CLK_FORCE_LSB) & DERIVED_RTC_CLK_FORCE_MASK)
-#define DERIVED_RTC_CLK_PERIOD_MSB               15
-#define DERIVED_RTC_CLK_PERIOD_LSB               1
-#define DERIVED_RTC_CLK_PERIOD_MASK              0x0000fffe
-#define DERIVED_RTC_CLK_PERIOD_GET(x)            (((x) & DERIVED_RTC_CLK_PERIOD_MASK) >> DERIVED_RTC_CLK_PERIOD_LSB)
-#define DERIVED_RTC_CLK_PERIOD_SET(x)            (((x) << DERIVED_RTC_CLK_PERIOD_LSB) & DERIVED_RTC_CLK_PERIOD_MASK)
-
-#define MAC_PCU_SLP32_MODE_ADDRESS               0x000000f4
-#define MAC_PCU_SLP32_MODE_OFFSET                0x000000f4
-#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MSB 21
-#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB 21
-#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK 0x00200000
-#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_GET(x) (((x) & MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK) >> MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB)
-#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_SET(x) (((x) << MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB) & MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK)
-#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MSB  19
-#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB  0
-#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK 0x000fffff
-#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_GET(x) (((x) & MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK) >> MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB)
-#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_SET(x) (((x) << MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB) & MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK)
-
-#define MAC_PCU_SLP32_WAKE_ADDRESS               0x000000f8
-#define MAC_PCU_SLP32_WAKE_OFFSET                0x000000f8
-#define MAC_PCU_SLP32_WAKE_XTL_TIME_MSB          15
-#define MAC_PCU_SLP32_WAKE_XTL_TIME_LSB          0
-#define MAC_PCU_SLP32_WAKE_XTL_TIME_MASK         0x0000ffff
-#define MAC_PCU_SLP32_WAKE_XTL_TIME_GET(x)       (((x) & MAC_PCU_SLP32_WAKE_XTL_TIME_MASK) >> MAC_PCU_SLP32_WAKE_XTL_TIME_LSB)
-#define MAC_PCU_SLP32_WAKE_XTL_TIME_SET(x)       (((x) << MAC_PCU_SLP32_WAKE_XTL_TIME_LSB) & MAC_PCU_SLP32_WAKE_XTL_TIME_MASK)
-
-#define MAC_PCU_SLP32_INC_ADDRESS                0x000000fc
-#define MAC_PCU_SLP32_INC_OFFSET                 0x000000fc
-#define MAC_PCU_SLP32_INC_TSF_INC_MSB            19
-#define MAC_PCU_SLP32_INC_TSF_INC_LSB            0
-#define MAC_PCU_SLP32_INC_TSF_INC_MASK           0x000fffff
-#define MAC_PCU_SLP32_INC_TSF_INC_GET(x)         (((x) & MAC_PCU_SLP32_INC_TSF_INC_MASK) >> MAC_PCU_SLP32_INC_TSF_INC_LSB)
-#define MAC_PCU_SLP32_INC_TSF_INC_SET(x)         (((x) << MAC_PCU_SLP32_INC_TSF_INC_LSB) & MAC_PCU_SLP32_INC_TSF_INC_MASK)
-
-#define MAC_PCU_SLP_MIB1_ADDRESS                 0x00000100
-#define MAC_PCU_SLP_MIB1_OFFSET                  0x00000100
-#define MAC_PCU_SLP_MIB1_SLEEP_CNT_MSB           31
-#define MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB           0
-#define MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK          0xffffffff
-#define MAC_PCU_SLP_MIB1_SLEEP_CNT_GET(x)        (((x) & MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK) >> MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB)
-#define MAC_PCU_SLP_MIB1_SLEEP_CNT_SET(x)        (((x) << MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB) & MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK)
-
-#define MAC_PCU_SLP_MIB2_ADDRESS                 0x00000104
-#define MAC_PCU_SLP_MIB2_OFFSET                  0x00000104
-#define MAC_PCU_SLP_MIB2_CYCLE_CNT_MSB           31
-#define MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB           0
-#define MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK          0xffffffff
-#define MAC_PCU_SLP_MIB2_CYCLE_CNT_GET(x)        (((x) & MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK) >> MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB)
-#define MAC_PCU_SLP_MIB2_CYCLE_CNT_SET(x)        (((x) << MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB) & MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK)
-
-#define MAC_PCU_SLP_MIB3_ADDRESS                 0x00000108
-#define MAC_PCU_SLP_MIB3_OFFSET                  0x00000108
-#define MAC_PCU_SLP_MIB3_PENDING_MSB             1
-#define MAC_PCU_SLP_MIB3_PENDING_LSB             1
-#define MAC_PCU_SLP_MIB3_PENDING_MASK            0x00000002
-#define MAC_PCU_SLP_MIB3_PENDING_GET(x)          (((x) & MAC_PCU_SLP_MIB3_PENDING_MASK) >> MAC_PCU_SLP_MIB3_PENDING_LSB)
-#define MAC_PCU_SLP_MIB3_PENDING_SET(x)          (((x) << MAC_PCU_SLP_MIB3_PENDING_LSB) & MAC_PCU_SLP_MIB3_PENDING_MASK)
-#define MAC_PCU_SLP_MIB3_CLR_CNT_MSB             0
-#define MAC_PCU_SLP_MIB3_CLR_CNT_LSB             0
-#define MAC_PCU_SLP_MIB3_CLR_CNT_MASK            0x00000001
-#define MAC_PCU_SLP_MIB3_CLR_CNT_GET(x)          (((x) & MAC_PCU_SLP_MIB3_CLR_CNT_MASK) >> MAC_PCU_SLP_MIB3_CLR_CNT_LSB)
-#define MAC_PCU_SLP_MIB3_CLR_CNT_SET(x)          (((x) << MAC_PCU_SLP_MIB3_CLR_CNT_LSB) & MAC_PCU_SLP_MIB3_CLR_CNT_MASK)
-
-#define MAC_PCU_SLP_BEACON_ADDRESS               0x0000010c
-#define MAC_PCU_SLP_BEACON_OFFSET                0x0000010c
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MSB 24
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB 24
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK 0x01000000
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_GET(x) (((x) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK) >> MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB)
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_SET(x) (((x) << MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK)
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MSB     23
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB     0
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK    0x00ffffff
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_GET(x)  (((x) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK) >> MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB)
-#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_SET(x)  (((x) << MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK)
-
-#define POWER_REG_ADDRESS                        0x00000110
-#define POWER_REG_OFFSET                         0x00000110
-#define POWER_REG_VLVL_MSB                       11
-#define POWER_REG_VLVL_LSB                       8
-#define POWER_REG_VLVL_MASK                      0x00000f00
-#define POWER_REG_VLVL_GET(x)                    (((x) & POWER_REG_VLVL_MASK) >> POWER_REG_VLVL_LSB)
-#define POWER_REG_VLVL_SET(x)                    (((x) << POWER_REG_VLVL_LSB) & POWER_REG_VLVL_MASK)
-#define POWER_REG_CPU_INT_ENABLE_MSB             7
-#define POWER_REG_CPU_INT_ENABLE_LSB             7
-#define POWER_REG_CPU_INT_ENABLE_MASK            0x00000080
-#define POWER_REG_CPU_INT_ENABLE_GET(x)          (((x) & POWER_REG_CPU_INT_ENABLE_MASK) >> POWER_REG_CPU_INT_ENABLE_LSB)
-#define POWER_REG_CPU_INT_ENABLE_SET(x)          (((x) << POWER_REG_CPU_INT_ENABLE_LSB) & POWER_REG_CPU_INT_ENABLE_MASK)
-#define POWER_REG_WLAN_ISO_DIS_MSB               6
-#define POWER_REG_WLAN_ISO_DIS_LSB               6
-#define POWER_REG_WLAN_ISO_DIS_MASK              0x00000040
-#define POWER_REG_WLAN_ISO_DIS_GET(x)            (((x) & POWER_REG_WLAN_ISO_DIS_MASK) >> POWER_REG_WLAN_ISO_DIS_LSB)
-#define POWER_REG_WLAN_ISO_DIS_SET(x)            (((x) << POWER_REG_WLAN_ISO_DIS_LSB) & POWER_REG_WLAN_ISO_DIS_MASK)
-#define POWER_REG_WLAN_ISO_CNTL_MSB              5
-#define POWER_REG_WLAN_ISO_CNTL_LSB              5
-#define POWER_REG_WLAN_ISO_CNTL_MASK             0x00000020
-#define POWER_REG_WLAN_ISO_CNTL_GET(x)           (((x) & POWER_REG_WLAN_ISO_CNTL_MASK) >> POWER_REG_WLAN_ISO_CNTL_LSB)
-#define POWER_REG_WLAN_ISO_CNTL_SET(x)           (((x) << POWER_REG_WLAN_ISO_CNTL_LSB) & POWER_REG_WLAN_ISO_CNTL_MASK)
-#define POWER_REG_RADIO_PWD_EN_MSB               4
-#define POWER_REG_RADIO_PWD_EN_LSB               4
-#define POWER_REG_RADIO_PWD_EN_MASK              0x00000010
-#define POWER_REG_RADIO_PWD_EN_GET(x)            (((x) & POWER_REG_RADIO_PWD_EN_MASK) >> POWER_REG_RADIO_PWD_EN_LSB)
-#define POWER_REG_RADIO_PWD_EN_SET(x)            (((x) << POWER_REG_RADIO_PWD_EN_LSB) & POWER_REG_RADIO_PWD_EN_MASK)
-#define POWER_REG_SOC_SCALE_EN_MSB               3
-#define POWER_REG_SOC_SCALE_EN_LSB               3
-#define POWER_REG_SOC_SCALE_EN_MASK              0x00000008
-#define POWER_REG_SOC_SCALE_EN_GET(x)            (((x) & POWER_REG_SOC_SCALE_EN_MASK) >> POWER_REG_SOC_SCALE_EN_LSB)
-#define POWER_REG_SOC_SCALE_EN_SET(x)            (((x) << POWER_REG_SOC_SCALE_EN_LSB) & POWER_REG_SOC_SCALE_EN_MASK)
-#define POWER_REG_WLAN_SCALE_EN_MSB              2
-#define POWER_REG_WLAN_SCALE_EN_LSB              2
-#define POWER_REG_WLAN_SCALE_EN_MASK             0x00000004
-#define POWER_REG_WLAN_SCALE_EN_GET(x)           (((x) & POWER_REG_WLAN_SCALE_EN_MASK) >> POWER_REG_WLAN_SCALE_EN_LSB)
-#define POWER_REG_WLAN_SCALE_EN_SET(x)           (((x) << POWER_REG_WLAN_SCALE_EN_LSB) & POWER_REG_WLAN_SCALE_EN_MASK)
-#define POWER_REG_WLAN_PWD_EN_MSB                1
-#define POWER_REG_WLAN_PWD_EN_LSB                1
-#define POWER_REG_WLAN_PWD_EN_MASK               0x00000002
-#define POWER_REG_WLAN_PWD_EN_GET(x)             (((x) & POWER_REG_WLAN_PWD_EN_MASK) >> POWER_REG_WLAN_PWD_EN_LSB)
-#define POWER_REG_WLAN_PWD_EN_SET(x)             (((x) << POWER_REG_WLAN_PWD_EN_LSB) & POWER_REG_WLAN_PWD_EN_MASK)
-#define POWER_REG_POWER_EN_MSB                   0
-#define POWER_REG_POWER_EN_LSB                   0
-#define POWER_REG_POWER_EN_MASK                  0x00000001
-#define POWER_REG_POWER_EN_GET(x)                (((x) & POWER_REG_POWER_EN_MASK) >> POWER_REG_POWER_EN_LSB)
-#define POWER_REG_POWER_EN_SET(x)                (((x) << POWER_REG_POWER_EN_LSB) & POWER_REG_POWER_EN_MASK)
-
-#define CORE_CLK_CTRL_ADDRESS                    0x00000114
-#define CORE_CLK_CTRL_OFFSET                     0x00000114
-#define CORE_CLK_CTRL_DIV_MSB                    2
-#define CORE_CLK_CTRL_DIV_LSB                    0
-#define CORE_CLK_CTRL_DIV_MASK                   0x00000007
-#define CORE_CLK_CTRL_DIV_GET(x)                 (((x) & CORE_CLK_CTRL_DIV_MASK) >> CORE_CLK_CTRL_DIV_LSB)
-#define CORE_CLK_CTRL_DIV_SET(x)                 (((x) << CORE_CLK_CTRL_DIV_LSB) & CORE_CLK_CTRL_DIV_MASK)
-
-#define SDIO_SETUP_CIRCUIT_ADDRESS               0x00000120
-#define SDIO_SETUP_CIRCUIT_OFFSET                0x00000120
-#define SDIO_SETUP_CIRCUIT_VECTOR_MSB            7
-#define SDIO_SETUP_CIRCUIT_VECTOR_LSB            0
-#define SDIO_SETUP_CIRCUIT_VECTOR_MASK           0x000000ff
-#define SDIO_SETUP_CIRCUIT_VECTOR_GET(x)         (((x) & SDIO_SETUP_CIRCUIT_VECTOR_MASK) >> SDIO_SETUP_CIRCUIT_VECTOR_LSB)
-#define SDIO_SETUP_CIRCUIT_VECTOR_SET(x)         (((x) << SDIO_SETUP_CIRCUIT_VECTOR_LSB) & SDIO_SETUP_CIRCUIT_VECTOR_MASK)
-
-#define SDIO_SETUP_CONFIG_ADDRESS                0x00000140
-#define SDIO_SETUP_CONFIG_OFFSET                 0x00000140
-#define SDIO_SETUP_CONFIG_ENABLE_MSB             1
-#define SDIO_SETUP_CONFIG_ENABLE_LSB             1
-#define SDIO_SETUP_CONFIG_ENABLE_MASK            0x00000002
-#define SDIO_SETUP_CONFIG_ENABLE_GET(x)          (((x) & SDIO_SETUP_CONFIG_ENABLE_MASK) >> SDIO_SETUP_CONFIG_ENABLE_LSB)
-#define SDIO_SETUP_CONFIG_ENABLE_SET(x)          (((x) << SDIO_SETUP_CONFIG_ENABLE_LSB) & SDIO_SETUP_CONFIG_ENABLE_MASK)
-#define SDIO_SETUP_CONFIG_CLEAR_MSB              0
-#define SDIO_SETUP_CONFIG_CLEAR_LSB              0
-#define SDIO_SETUP_CONFIG_CLEAR_MASK             0x00000001
-#define SDIO_SETUP_CONFIG_CLEAR_GET(x)           (((x) & SDIO_SETUP_CONFIG_CLEAR_MASK) >> SDIO_SETUP_CONFIG_CLEAR_LSB)
-#define SDIO_SETUP_CONFIG_CLEAR_SET(x)           (((x) << SDIO_SETUP_CONFIG_CLEAR_LSB) & SDIO_SETUP_CONFIG_CLEAR_MASK)
-
-#define CPU_SETUP_CONFIG_ADDRESS                 0x00000144
-#define CPU_SETUP_CONFIG_OFFSET                  0x00000144
-#define CPU_SETUP_CONFIG_ENABLE_MSB              1
-#define CPU_SETUP_CONFIG_ENABLE_LSB              1
-#define CPU_SETUP_CONFIG_ENABLE_MASK             0x00000002
-#define CPU_SETUP_CONFIG_ENABLE_GET(x)           (((x) & CPU_SETUP_CONFIG_ENABLE_MASK) >> CPU_SETUP_CONFIG_ENABLE_LSB)
-#define CPU_SETUP_CONFIG_ENABLE_SET(x)           (((x) << CPU_SETUP_CONFIG_ENABLE_LSB) & CPU_SETUP_CONFIG_ENABLE_MASK)
-#define CPU_SETUP_CONFIG_CLEAR_MSB               0
-#define CPU_SETUP_CONFIG_CLEAR_LSB               0
-#define CPU_SETUP_CONFIG_CLEAR_MASK              0x00000001
-#define CPU_SETUP_CONFIG_CLEAR_GET(x)            (((x) & CPU_SETUP_CONFIG_CLEAR_MASK) >> CPU_SETUP_CONFIG_CLEAR_LSB)
-#define CPU_SETUP_CONFIG_CLEAR_SET(x)            (((x) << CPU_SETUP_CONFIG_CLEAR_LSB) & CPU_SETUP_CONFIG_CLEAR_MASK)
-
-#define CPU_SETUP_CIRCUIT_ADDRESS                0x00000160
-#define CPU_SETUP_CIRCUIT_OFFSET                 0x00000160
-#define CPU_SETUP_CIRCUIT_VECTOR_MSB             7
-#define CPU_SETUP_CIRCUIT_VECTOR_LSB             0
-#define CPU_SETUP_CIRCUIT_VECTOR_MASK            0x000000ff
-#define CPU_SETUP_CIRCUIT_VECTOR_GET(x)          (((x) & CPU_SETUP_CIRCUIT_VECTOR_MASK) >> CPU_SETUP_CIRCUIT_VECTOR_LSB)
-#define CPU_SETUP_CIRCUIT_VECTOR_SET(x)          (((x) << CPU_SETUP_CIRCUIT_VECTOR_LSB) & CPU_SETUP_CIRCUIT_VECTOR_MASK)
-
-#define BB_SETUP_CONFIG_ADDRESS                  0x00000180
-#define BB_SETUP_CONFIG_OFFSET                   0x00000180
-#define BB_SETUP_CONFIG_ENABLE_MSB               1
-#define BB_SETUP_CONFIG_ENABLE_LSB               1
-#define BB_SETUP_CONFIG_ENABLE_MASK              0x00000002
-#define BB_SETUP_CONFIG_ENABLE_GET(x)            (((x) & BB_SETUP_CONFIG_ENABLE_MASK) >> BB_SETUP_CONFIG_ENABLE_LSB)
-#define BB_SETUP_CONFIG_ENABLE_SET(x)            (((x) << BB_SETUP_CONFIG_ENABLE_LSB) & BB_SETUP_CONFIG_ENABLE_MASK)
-#define BB_SETUP_CONFIG_CLEAR_MSB                0
-#define BB_SETUP_CONFIG_CLEAR_LSB                0
-#define BB_SETUP_CONFIG_CLEAR_MASK               0x00000001
-#define BB_SETUP_CONFIG_CLEAR_GET(x)             (((x) & BB_SETUP_CONFIG_CLEAR_MASK) >> BB_SETUP_CONFIG_CLEAR_LSB)
-#define BB_SETUP_CONFIG_CLEAR_SET(x)             (((x) << BB_SETUP_CONFIG_CLEAR_LSB) & BB_SETUP_CONFIG_CLEAR_MASK)
-
-#define BB_SETUP_CIRCUIT_ADDRESS                 0x000001a0
-#define BB_SETUP_CIRCUIT_OFFSET                  0x000001a0
-#define BB_SETUP_CIRCUIT_VECTOR_MSB              7
-#define BB_SETUP_CIRCUIT_VECTOR_LSB              0
-#define BB_SETUP_CIRCUIT_VECTOR_MASK             0x000000ff
-#define BB_SETUP_CIRCUIT_VECTOR_GET(x)           (((x) & BB_SETUP_CIRCUIT_VECTOR_MASK) >> BB_SETUP_CIRCUIT_VECTOR_LSB)
-#define BB_SETUP_CIRCUIT_VECTOR_SET(x)           (((x) << BB_SETUP_CIRCUIT_VECTOR_LSB) & BB_SETUP_CIRCUIT_VECTOR_MASK)
-
-#define GPIO_WAKEUP_CONTROL_ADDRESS              0x000001c0
-#define GPIO_WAKEUP_CONTROL_OFFSET               0x000001c0
-#define GPIO_WAKEUP_CONTROL_ENABLE_MSB           0
-#define GPIO_WAKEUP_CONTROL_ENABLE_LSB           0
-#define GPIO_WAKEUP_CONTROL_ENABLE_MASK          0x00000001
-#define GPIO_WAKEUP_CONTROL_ENABLE_GET(x)        (((x) & GPIO_WAKEUP_CONTROL_ENABLE_MASK) >> GPIO_WAKEUP_CONTROL_ENABLE_LSB)
-#define GPIO_WAKEUP_CONTROL_ENABLE_SET(x)        (((x) << GPIO_WAKEUP_CONTROL_ENABLE_LSB) & GPIO_WAKEUP_CONTROL_ENABLE_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct rtc_reg_reg_s {
-  volatile unsigned int reset_control;
-  volatile unsigned int xtal_control;
-  volatile unsigned int tcxo_detect;
-  volatile unsigned int xtal_test;
-  volatile unsigned int quadrature;
-  volatile unsigned int pll_control;
-  volatile unsigned int pll_settle;
-  volatile unsigned int xtal_settle;
-  volatile unsigned int cpu_clock;
-  volatile unsigned int clock_out;
-  volatile unsigned int clock_control;
-  volatile unsigned int bias_override;
-  volatile unsigned int wdt_control;
-  volatile unsigned int wdt_status;
-  volatile unsigned int wdt;
-  volatile unsigned int wdt_count;
-  volatile unsigned int wdt_reset;
-  volatile unsigned int int_status;
-  volatile unsigned int lf_timer0;
-  volatile unsigned int lf_timer_count0;
-  volatile unsigned int lf_timer_control0;
-  volatile unsigned int lf_timer_status0;
-  volatile unsigned int lf_timer1;
-  volatile unsigned int lf_timer_count1;
-  volatile unsigned int lf_timer_control1;
-  volatile unsigned int lf_timer_status1;
-  volatile unsigned int lf_timer2;
-  volatile unsigned int lf_timer_count2;
-  volatile unsigned int lf_timer_control2;
-  volatile unsigned int lf_timer_status2;
-  volatile unsigned int lf_timer3;
-  volatile unsigned int lf_timer_count3;
-  volatile unsigned int lf_timer_control3;
-  volatile unsigned int lf_timer_status3;
-  volatile unsigned int hf_timer;
-  volatile unsigned int hf_timer_count;
-  volatile unsigned int hf_lf_count;
-  volatile unsigned int hf_timer_control;
-  volatile unsigned int hf_timer_status;
-  volatile unsigned int rtc_control;
-  volatile unsigned int rtc_time;
-  volatile unsigned int rtc_date;
-  volatile unsigned int rtc_set_time;
-  volatile unsigned int rtc_set_date;
-  volatile unsigned int rtc_set_alarm;
-  volatile unsigned int rtc_config;
-  volatile unsigned int rtc_alarm_status;
-  volatile unsigned int uart_wakeup;
-  volatile unsigned int reset_cause;
-  volatile unsigned int system_sleep;
-  volatile unsigned int sdio_wrapper;
-  volatile unsigned int mac_sleep_control;
-  volatile unsigned int keep_awake;
-  volatile unsigned int lpo_cal_time;
-  volatile unsigned int lpo_init_dividend_int;
-  volatile unsigned int lpo_init_dividend_fraction;
-  volatile unsigned int lpo_cal;
-  volatile unsigned int lpo_cal_test_control;
-  volatile unsigned int lpo_cal_test_status;
-  volatile unsigned int chip_id;
-  volatile unsigned int derived_rtc_clk;
-  volatile unsigned int mac_pcu_slp32_mode;
-  volatile unsigned int mac_pcu_slp32_wake;
-  volatile unsigned int mac_pcu_slp32_inc;
-  volatile unsigned int mac_pcu_slp_mib1;
-  volatile unsigned int mac_pcu_slp_mib2;
-  volatile unsigned int mac_pcu_slp_mib3;
-  volatile unsigned int mac_pcu_slp_beacon;
-  volatile unsigned int power_reg;
-  volatile unsigned int core_clk_ctrl;
-  unsigned char pad0[8]; /* pad to 0x120 */
-  volatile unsigned int sdio_setup_circuit[8];
-  volatile unsigned int sdio_setup_config;
-  volatile unsigned int cpu_setup_config;
-  unsigned char pad1[24]; /* pad to 0x160 */
-  volatile unsigned int cpu_setup_circuit[8];
-  volatile unsigned int bb_setup_config;
-  unsigned char pad2[28]; /* pad to 0x1a0 */
-  volatile unsigned int bb_setup_circuit[8];
-  volatile unsigned int gpio_wakeup_control;
-} rtc_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _RTC_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h
deleted file mode 100644
index 16fb99c..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h
+++ /dev/null
@@ -1,186 +0,0 @@
-#ifndef _SI_REG_REG_H_
-#define _SI_REG_REG_H_
-
-#define SI_CONFIG_ADDRESS                        0x00000000
-#define SI_CONFIG_OFFSET                         0x00000000
-#define SI_CONFIG_ERR_INT_MSB                    19
-#define SI_CONFIG_ERR_INT_LSB                    19
-#define SI_CONFIG_ERR_INT_MASK                   0x00080000
-#define SI_CONFIG_ERR_INT_GET(x)                 (((x) & SI_CONFIG_ERR_INT_MASK) >> SI_CONFIG_ERR_INT_LSB)
-#define SI_CONFIG_ERR_INT_SET(x)                 (((x) << SI_CONFIG_ERR_INT_LSB) & SI_CONFIG_ERR_INT_MASK)
-#define SI_CONFIG_BIDIR_OD_DATA_MSB              18
-#define SI_CONFIG_BIDIR_OD_DATA_LSB              18
-#define SI_CONFIG_BIDIR_OD_DATA_MASK             0x00040000
-#define SI_CONFIG_BIDIR_OD_DATA_GET(x)           (((x) & SI_CONFIG_BIDIR_OD_DATA_MASK) >> SI_CONFIG_BIDIR_OD_DATA_LSB)
-#define SI_CONFIG_BIDIR_OD_DATA_SET(x)           (((x) << SI_CONFIG_BIDIR_OD_DATA_LSB) & SI_CONFIG_BIDIR_OD_DATA_MASK)
-#define SI_CONFIG_I2C_MSB                        16
-#define SI_CONFIG_I2C_LSB                        16
-#define SI_CONFIG_I2C_MASK                       0x00010000
-#define SI_CONFIG_I2C_GET(x)                     (((x) & SI_CONFIG_I2C_MASK) >> SI_CONFIG_I2C_LSB)
-#define SI_CONFIG_I2C_SET(x)                     (((x) << SI_CONFIG_I2C_LSB) & SI_CONFIG_I2C_MASK)
-#define SI_CONFIG_POS_SAMPLE_MSB                 7
-#define SI_CONFIG_POS_SAMPLE_LSB                 7
-#define SI_CONFIG_POS_SAMPLE_MASK                0x00000080
-#define SI_CONFIG_POS_SAMPLE_GET(x)              (((x) & SI_CONFIG_POS_SAMPLE_MASK) >> SI_CONFIG_POS_SAMPLE_LSB)
-#define SI_CONFIG_POS_SAMPLE_SET(x)              (((x) << SI_CONFIG_POS_SAMPLE_LSB) & SI_CONFIG_POS_SAMPLE_MASK)
-#define SI_CONFIG_POS_DRIVE_MSB                  6
-#define SI_CONFIG_POS_DRIVE_LSB                  6
-#define SI_CONFIG_POS_DRIVE_MASK                 0x00000040
-#define SI_CONFIG_POS_DRIVE_GET(x)               (((x) & SI_CONFIG_POS_DRIVE_MASK) >> SI_CONFIG_POS_DRIVE_LSB)
-#define SI_CONFIG_POS_DRIVE_SET(x)               (((x) << SI_CONFIG_POS_DRIVE_LSB) & SI_CONFIG_POS_DRIVE_MASK)
-#define SI_CONFIG_INACTIVE_DATA_MSB              5
-#define SI_CONFIG_INACTIVE_DATA_LSB              5
-#define SI_CONFIG_INACTIVE_DATA_MASK             0x00000020
-#define SI_CONFIG_INACTIVE_DATA_GET(x)           (((x) & SI_CONFIG_INACTIVE_DATA_MASK) >> SI_CONFIG_INACTIVE_DATA_LSB)
-#define SI_CONFIG_INACTIVE_DATA_SET(x)           (((x) << SI_CONFIG_INACTIVE_DATA_LSB) & SI_CONFIG_INACTIVE_DATA_MASK)
-#define SI_CONFIG_INACTIVE_CLK_MSB               4
-#define SI_CONFIG_INACTIVE_CLK_LSB               4
-#define SI_CONFIG_INACTIVE_CLK_MASK              0x00000010
-#define SI_CONFIG_INACTIVE_CLK_GET(x)            (((x) & SI_CONFIG_INACTIVE_CLK_MASK) >> SI_CONFIG_INACTIVE_CLK_LSB)
-#define SI_CONFIG_INACTIVE_CLK_SET(x)            (((x) << SI_CONFIG_INACTIVE_CLK_LSB) & SI_CONFIG_INACTIVE_CLK_MASK)
-#define SI_CONFIG_DIVIDER_MSB                    3
-#define SI_CONFIG_DIVIDER_LSB                    0
-#define SI_CONFIG_DIVIDER_MASK                   0x0000000f
-#define SI_CONFIG_DIVIDER_GET(x)                 (((x) & SI_CONFIG_DIVIDER_MASK) >> SI_CONFIG_DIVIDER_LSB)
-#define SI_CONFIG_DIVIDER_SET(x)                 (((x) << SI_CONFIG_DIVIDER_LSB) & SI_CONFIG_DIVIDER_MASK)
-
-#define SI_CS_ADDRESS                            0x00000004
-#define SI_CS_OFFSET                             0x00000004
-#define SI_CS_BIT_CNT_IN_LAST_BYTE_MSB           13
-#define SI_CS_BIT_CNT_IN_LAST_BYTE_LSB           11
-#define SI_CS_BIT_CNT_IN_LAST_BYTE_MASK          0x00003800
-#define SI_CS_BIT_CNT_IN_LAST_BYTE_GET(x)        (((x) & SI_CS_BIT_CNT_IN_LAST_BYTE_MASK) >> SI_CS_BIT_CNT_IN_LAST_BYTE_LSB)
-#define SI_CS_BIT_CNT_IN_LAST_BYTE_SET(x)        (((x) << SI_CS_BIT_CNT_IN_LAST_BYTE_LSB) & SI_CS_BIT_CNT_IN_LAST_BYTE_MASK)
-#define SI_CS_DONE_ERR_MSB                       10
-#define SI_CS_DONE_ERR_LSB                       10
-#define SI_CS_DONE_ERR_MASK                      0x00000400
-#define SI_CS_DONE_ERR_GET(x)                    (((x) & SI_CS_DONE_ERR_MASK) >> SI_CS_DONE_ERR_LSB)
-#define SI_CS_DONE_ERR_SET(x)                    (((x) << SI_CS_DONE_ERR_LSB) & SI_CS_DONE_ERR_MASK)
-#define SI_CS_DONE_INT_MSB                       9
-#define SI_CS_DONE_INT_LSB                       9
-#define SI_CS_DONE_INT_MASK                      0x00000200
-#define SI_CS_DONE_INT_GET(x)                    (((x) & SI_CS_DONE_INT_MASK) >> SI_CS_DONE_INT_LSB)
-#define SI_CS_DONE_INT_SET(x)                    (((x) << SI_CS_DONE_INT_LSB) & SI_CS_DONE_INT_MASK)
-#define SI_CS_START_MSB                          8
-#define SI_CS_START_LSB                          8
-#define SI_CS_START_MASK                         0x00000100
-#define SI_CS_START_GET(x)                       (((x) & SI_CS_START_MASK) >> SI_CS_START_LSB)
-#define SI_CS_START_SET(x)                       (((x) << SI_CS_START_LSB) & SI_CS_START_MASK)
-#define SI_CS_RX_CNT_MSB                         7
-#define SI_CS_RX_CNT_LSB                         4
-#define SI_CS_RX_CNT_MASK                        0x000000f0
-#define SI_CS_RX_CNT_GET(x)                      (((x) & SI_CS_RX_CNT_MASK) >> SI_CS_RX_CNT_LSB)
-#define SI_CS_RX_CNT_SET(x)                      (((x) << SI_CS_RX_CNT_LSB) & SI_CS_RX_CNT_MASK)
-#define SI_CS_TX_CNT_MSB                         3
-#define SI_CS_TX_CNT_LSB                         0
-#define SI_CS_TX_CNT_MASK                        0x0000000f
-#define SI_CS_TX_CNT_GET(x)                      (((x) & SI_CS_TX_CNT_MASK) >> SI_CS_TX_CNT_LSB)
-#define SI_CS_TX_CNT_SET(x)                      (((x) << SI_CS_TX_CNT_LSB) & SI_CS_TX_CNT_MASK)
-
-#define SI_TX_DATA0_ADDRESS                      0x00000008
-#define SI_TX_DATA0_OFFSET                       0x00000008
-#define SI_TX_DATA0_DATA3_MSB                    31
-#define SI_TX_DATA0_DATA3_LSB                    24
-#define SI_TX_DATA0_DATA3_MASK                   0xff000000
-#define SI_TX_DATA0_DATA3_GET(x)                 (((x) & SI_TX_DATA0_DATA3_MASK) >> SI_TX_DATA0_DATA3_LSB)
-#define SI_TX_DATA0_DATA3_SET(x)                 (((x) << SI_TX_DATA0_DATA3_LSB) & SI_TX_DATA0_DATA3_MASK)
-#define SI_TX_DATA0_DATA2_MSB                    23
-#define SI_TX_DATA0_DATA2_LSB                    16
-#define SI_TX_DATA0_DATA2_MASK                   0x00ff0000
-#define SI_TX_DATA0_DATA2_GET(x)                 (((x) & SI_TX_DATA0_DATA2_MASK) >> SI_TX_DATA0_DATA2_LSB)
-#define SI_TX_DATA0_DATA2_SET(x)                 (((x) << SI_TX_DATA0_DATA2_LSB) & SI_TX_DATA0_DATA2_MASK)
-#define SI_TX_DATA0_DATA1_MSB                    15
-#define SI_TX_DATA0_DATA1_LSB                    8
-#define SI_TX_DATA0_DATA1_MASK                   0x0000ff00
-#define SI_TX_DATA0_DATA1_GET(x)                 (((x) & SI_TX_DATA0_DATA1_MASK) >> SI_TX_DATA0_DATA1_LSB)
-#define SI_TX_DATA0_DATA1_SET(x)                 (((x) << SI_TX_DATA0_DATA1_LSB) & SI_TX_DATA0_DATA1_MASK)
-#define SI_TX_DATA0_DATA0_MSB                    7
-#define SI_TX_DATA0_DATA0_LSB                    0
-#define SI_TX_DATA0_DATA0_MASK                   0x000000ff
-#define SI_TX_DATA0_DATA0_GET(x)                 (((x) & SI_TX_DATA0_DATA0_MASK) >> SI_TX_DATA0_DATA0_LSB)
-#define SI_TX_DATA0_DATA0_SET(x)                 (((x) << SI_TX_DATA0_DATA0_LSB) & SI_TX_DATA0_DATA0_MASK)
-
-#define SI_TX_DATA1_ADDRESS                      0x0000000c
-#define SI_TX_DATA1_OFFSET                       0x0000000c
-#define SI_TX_DATA1_DATA7_MSB                    31
-#define SI_TX_DATA1_DATA7_LSB                    24
-#define SI_TX_DATA1_DATA7_MASK                   0xff000000
-#define SI_TX_DATA1_DATA7_GET(x)                 (((x) & SI_TX_DATA1_DATA7_MASK) >> SI_TX_DATA1_DATA7_LSB)
-#define SI_TX_DATA1_DATA7_SET(x)                 (((x) << SI_TX_DATA1_DATA7_LSB) & SI_TX_DATA1_DATA7_MASK)
-#define SI_TX_DATA1_DATA6_MSB                    23
-#define SI_TX_DATA1_DATA6_LSB                    16
-#define SI_TX_DATA1_DATA6_MASK                   0x00ff0000
-#define SI_TX_DATA1_DATA6_GET(x)                 (((x) & SI_TX_DATA1_DATA6_MASK) >> SI_TX_DATA1_DATA6_LSB)
-#define SI_TX_DATA1_DATA6_SET(x)                 (((x) << SI_TX_DATA1_DATA6_LSB) & SI_TX_DATA1_DATA6_MASK)
-#define SI_TX_DATA1_DATA5_MSB                    15
-#define SI_TX_DATA1_DATA5_LSB                    8
-#define SI_TX_DATA1_DATA5_MASK                   0x0000ff00
-#define SI_TX_DATA1_DATA5_GET(x)                 (((x) & SI_TX_DATA1_DATA5_MASK) >> SI_TX_DATA1_DATA5_LSB)
-#define SI_TX_DATA1_DATA5_SET(x)                 (((x) << SI_TX_DATA1_DATA5_LSB) & SI_TX_DATA1_DATA5_MASK)
-#define SI_TX_DATA1_DATA4_MSB                    7
-#define SI_TX_DATA1_DATA4_LSB                    0
-#define SI_TX_DATA1_DATA4_MASK                   0x000000ff
-#define SI_TX_DATA1_DATA4_GET(x)                 (((x) & SI_TX_DATA1_DATA4_MASK) >> SI_TX_DATA1_DATA4_LSB)
-#define SI_TX_DATA1_DATA4_SET(x)                 (((x) << SI_TX_DATA1_DATA4_LSB) & SI_TX_DATA1_DATA4_MASK)
-
-#define SI_RX_DATA0_ADDRESS                      0x00000010
-#define SI_RX_DATA0_OFFSET                       0x00000010
-#define SI_RX_DATA0_DATA3_MSB                    31
-#define SI_RX_DATA0_DATA3_LSB                    24
-#define SI_RX_DATA0_DATA3_MASK                   0xff000000
-#define SI_RX_DATA0_DATA3_GET(x)                 (((x) & SI_RX_DATA0_DATA3_MASK) >> SI_RX_DATA0_DATA3_LSB)
-#define SI_RX_DATA0_DATA3_SET(x)                 (((x) << SI_RX_DATA0_DATA3_LSB) & SI_RX_DATA0_DATA3_MASK)
-#define SI_RX_DATA0_DATA2_MSB                    23
-#define SI_RX_DATA0_DATA2_LSB                    16
-#define SI_RX_DATA0_DATA2_MASK                   0x00ff0000
-#define SI_RX_DATA0_DATA2_GET(x)                 (((x) & SI_RX_DATA0_DATA2_MASK) >> SI_RX_DATA0_DATA2_LSB)
-#define SI_RX_DATA0_DATA2_SET(x)                 (((x) << SI_RX_DATA0_DATA2_LSB) & SI_RX_DATA0_DATA2_MASK)
-#define SI_RX_DATA0_DATA1_MSB                    15
-#define SI_RX_DATA0_DATA1_LSB                    8
-#define SI_RX_DATA0_DATA1_MASK                   0x0000ff00
-#define SI_RX_DATA0_DATA1_GET(x)                 (((x) & SI_RX_DATA0_DATA1_MASK) >> SI_RX_DATA0_DATA1_LSB)
-#define SI_RX_DATA0_DATA1_SET(x)                 (((x) << SI_RX_DATA0_DATA1_LSB) & SI_RX_DATA0_DATA1_MASK)
-#define SI_RX_DATA0_DATA0_MSB                    7
-#define SI_RX_DATA0_DATA0_LSB                    0
-#define SI_RX_DATA0_DATA0_MASK                   0x000000ff
-#define SI_RX_DATA0_DATA0_GET(x)                 (((x) & SI_RX_DATA0_DATA0_MASK) >> SI_RX_DATA0_DATA0_LSB)
-#define SI_RX_DATA0_DATA0_SET(x)                 (((x) << SI_RX_DATA0_DATA0_LSB) & SI_RX_DATA0_DATA0_MASK)
-
-#define SI_RX_DATA1_ADDRESS                      0x00000014
-#define SI_RX_DATA1_OFFSET                       0x00000014
-#define SI_RX_DATA1_DATA7_MSB                    31
-#define SI_RX_DATA1_DATA7_LSB                    24
-#define SI_RX_DATA1_DATA7_MASK                   0xff000000
-#define SI_RX_DATA1_DATA7_GET(x)                 (((x) & SI_RX_DATA1_DATA7_MASK) >> SI_RX_DATA1_DATA7_LSB)
-#define SI_RX_DATA1_DATA7_SET(x)                 (((x) << SI_RX_DATA1_DATA7_LSB) & SI_RX_DATA1_DATA7_MASK)
-#define SI_RX_DATA1_DATA6_MSB                    23
-#define SI_RX_DATA1_DATA6_LSB                    16
-#define SI_RX_DATA1_DATA6_MASK                   0x00ff0000
-#define SI_RX_DATA1_DATA6_GET(x)                 (((x) & SI_RX_DATA1_DATA6_MASK) >> SI_RX_DATA1_DATA6_LSB)
-#define SI_RX_DATA1_DATA6_SET(x)                 (((x) << SI_RX_DATA1_DATA6_LSB) & SI_RX_DATA1_DATA6_MASK)
-#define SI_RX_DATA1_DATA5_MSB                    15
-#define SI_RX_DATA1_DATA5_LSB                    8
-#define SI_RX_DATA1_DATA5_MASK                   0x0000ff00
-#define SI_RX_DATA1_DATA5_GET(x)                 (((x) & SI_RX_DATA1_DATA5_MASK) >> SI_RX_DATA1_DATA5_LSB)
-#define SI_RX_DATA1_DATA5_SET(x)                 (((x) << SI_RX_DATA1_DATA5_LSB) & SI_RX_DATA1_DATA5_MASK)
-#define SI_RX_DATA1_DATA4_MSB                    7
-#define SI_RX_DATA1_DATA4_LSB                    0
-#define SI_RX_DATA1_DATA4_MASK                   0x000000ff
-#define SI_RX_DATA1_DATA4_GET(x)                 (((x) & SI_RX_DATA1_DATA4_MASK) >> SI_RX_DATA1_DATA4_LSB)
-#define SI_RX_DATA1_DATA4_SET(x)                 (((x) << SI_RX_DATA1_DATA4_LSB) & SI_RX_DATA1_DATA4_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct si_reg_reg_s {
-  volatile unsigned int si_config;
-  volatile unsigned int si_cs;
-  volatile unsigned int si_tx_data0;
-  volatile unsigned int si_tx_data1;
-  volatile unsigned int si_rx_data0;
-  volatile unsigned int si_rx_data1;
-} si_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _SI_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h
deleted file mode 100644
index 5db321b..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h
+++ /dev/null
@@ -1,327 +0,0 @@
-#ifndef _UART_REG_REG_H_
-#define _UART_REG_REG_H_
-
-#define RBR_ADDRESS                              0x00000000
-#define RBR_OFFSET                               0x00000000
-#define RBR_RBR_MSB                              7
-#define RBR_RBR_LSB                              0
-#define RBR_RBR_MASK                             0x000000ff
-#define RBR_RBR_GET(x)                           (((x) & RBR_RBR_MASK) >> RBR_RBR_LSB)
-#define RBR_RBR_SET(x)                           (((x) << RBR_RBR_LSB) & RBR_RBR_MASK)
-
-#define THR_ADDRESS                              0x00000000
-#define THR_OFFSET                               0x00000000
-#define THR_THR_MSB                              7
-#define THR_THR_LSB                              0
-#define THR_THR_MASK                             0x000000ff
-#define THR_THR_GET(x)                           (((x) & THR_THR_MASK) >> THR_THR_LSB)
-#define THR_THR_SET(x)                           (((x) << THR_THR_LSB) & THR_THR_MASK)
-
-#define DLL_ADDRESS                              0x00000000
-#define DLL_OFFSET                               0x00000000
-#define DLL_DLL_MSB                              7
-#define DLL_DLL_LSB                              0
-#define DLL_DLL_MASK                             0x000000ff
-#define DLL_DLL_GET(x)                           (((x) & DLL_DLL_MASK) >> DLL_DLL_LSB)
-#define DLL_DLL_SET(x)                           (((x) << DLL_DLL_LSB) & DLL_DLL_MASK)
-
-#define DLH_ADDRESS                              0x00000004
-#define DLH_OFFSET                               0x00000004
-#define DLH_DLH_MSB                              7
-#define DLH_DLH_LSB                              0
-#define DLH_DLH_MASK                             0x000000ff
-#define DLH_DLH_GET(x)                           (((x) & DLH_DLH_MASK) >> DLH_DLH_LSB)
-#define DLH_DLH_SET(x)                           (((x) << DLH_DLH_LSB) & DLH_DLH_MASK)
-
-#define IER_ADDRESS                              0x00000004
-#define IER_OFFSET                               0x00000004
-#define IER_EDDSI_MSB                            3
-#define IER_EDDSI_LSB                            3
-#define IER_EDDSI_MASK                           0x00000008
-#define IER_EDDSI_GET(x)                         (((x) & IER_EDDSI_MASK) >> IER_EDDSI_LSB)
-#define IER_EDDSI_SET(x)                         (((x) << IER_EDDSI_LSB) & IER_EDDSI_MASK)
-#define IER_ELSI_MSB                             2
-#define IER_ELSI_LSB                             2
-#define IER_ELSI_MASK                            0x00000004
-#define IER_ELSI_GET(x)                          (((x) & IER_ELSI_MASK) >> IER_ELSI_LSB)
-#define IER_ELSI_SET(x)                          (((x) << IER_ELSI_LSB) & IER_ELSI_MASK)
-#define IER_ETBEI_MSB                            1
-#define IER_ETBEI_LSB                            1
-#define IER_ETBEI_MASK                           0x00000002
-#define IER_ETBEI_GET(x)                         (((x) & IER_ETBEI_MASK) >> IER_ETBEI_LSB)
-#define IER_ETBEI_SET(x)                         (((x) << IER_ETBEI_LSB) & IER_ETBEI_MASK)
-#define IER_ERBFI_MSB                            0
-#define IER_ERBFI_LSB                            0
-#define IER_ERBFI_MASK                           0x00000001
-#define IER_ERBFI_GET(x)                         (((x) & IER_ERBFI_MASK) >> IER_ERBFI_LSB)
-#define IER_ERBFI_SET(x)                         (((x) << IER_ERBFI_LSB) & IER_ERBFI_MASK)
-
-#define IIR_ADDRESS                              0x00000008
-#define IIR_OFFSET                               0x00000008
-#define IIR_FIFO_STATUS_MSB                      7
-#define IIR_FIFO_STATUS_LSB                      6
-#define IIR_FIFO_STATUS_MASK                     0x000000c0
-#define IIR_FIFO_STATUS_GET(x)                   (((x) & IIR_FIFO_STATUS_MASK) >> IIR_FIFO_STATUS_LSB)
-#define IIR_FIFO_STATUS_SET(x)                   (((x) << IIR_FIFO_STATUS_LSB) & IIR_FIFO_STATUS_MASK)
-#define IIR_IID_MSB                              3
-#define IIR_IID_LSB                              0
-#define IIR_IID_MASK                             0x0000000f
-#define IIR_IID_GET(x)                           (((x) & IIR_IID_MASK) >> IIR_IID_LSB)
-#define IIR_IID_SET(x)                           (((x) << IIR_IID_LSB) & IIR_IID_MASK)
-
-#define FCR_ADDRESS                              0x00000008
-#define FCR_OFFSET                               0x00000008
-#define FCR_RCVR_TRIG_MSB                        7
-#define FCR_RCVR_TRIG_LSB                        6
-#define FCR_RCVR_TRIG_MASK                       0x000000c0
-#define FCR_RCVR_TRIG_GET(x)                     (((x) & FCR_RCVR_TRIG_MASK) >> FCR_RCVR_TRIG_LSB)
-#define FCR_RCVR_TRIG_SET(x)                     (((x) << FCR_RCVR_TRIG_LSB) & FCR_RCVR_TRIG_MASK)
-#define FCR_DMA_MODE_MSB                         3
-#define FCR_DMA_MODE_LSB                         3
-#define FCR_DMA_MODE_MASK                        0x00000008
-#define FCR_DMA_MODE_GET(x)                      (((x) & FCR_DMA_MODE_MASK) >> FCR_DMA_MODE_LSB)
-#define FCR_DMA_MODE_SET(x)                      (((x) << FCR_DMA_MODE_LSB) & FCR_DMA_MODE_MASK)
-#define FCR_XMIT_FIFO_RST_MSB                    2
-#define FCR_XMIT_FIFO_RST_LSB                    2
-#define FCR_XMIT_FIFO_RST_MASK                   0x00000004
-#define FCR_XMIT_FIFO_RST_GET(x)                 (((x) & FCR_XMIT_FIFO_RST_MASK) >> FCR_XMIT_FIFO_RST_LSB)
-#define FCR_XMIT_FIFO_RST_SET(x)                 (((x) << FCR_XMIT_FIFO_RST_LSB) & FCR_XMIT_FIFO_RST_MASK)
-#define FCR_RCVR_FIFO_RST_MSB                    1
-#define FCR_RCVR_FIFO_RST_LSB                    1
-#define FCR_RCVR_FIFO_RST_MASK                   0x00000002
-#define FCR_RCVR_FIFO_RST_GET(x)                 (((x) & FCR_RCVR_FIFO_RST_MASK) >> FCR_RCVR_FIFO_RST_LSB)
-#define FCR_RCVR_FIFO_RST_SET(x)                 (((x) << FCR_RCVR_FIFO_RST_LSB) & FCR_RCVR_FIFO_RST_MASK)
-#define FCR_FIFO_EN_MSB                          0
-#define FCR_FIFO_EN_LSB                          0
-#define FCR_FIFO_EN_MASK                         0x00000001
-#define FCR_FIFO_EN_GET(x)                       (((x) & FCR_FIFO_EN_MASK) >> FCR_FIFO_EN_LSB)
-#define FCR_FIFO_EN_SET(x)                       (((x) << FCR_FIFO_EN_LSB) & FCR_FIFO_EN_MASK)
-
-#define LCR_ADDRESS                              0x0000000c
-#define LCR_OFFSET                               0x0000000c
-#define LCR_DLAB_MSB                             7
-#define LCR_DLAB_LSB                             7
-#define LCR_DLAB_MASK                            0x00000080
-#define LCR_DLAB_GET(x)                          (((x) & LCR_DLAB_MASK) >> LCR_DLAB_LSB)
-#define LCR_DLAB_SET(x)                          (((x) << LCR_DLAB_LSB) & LCR_DLAB_MASK)
-#define LCR_BREAK_MSB                            6
-#define LCR_BREAK_LSB                            6
-#define LCR_BREAK_MASK                           0x00000040
-#define LCR_BREAK_GET(x)                         (((x) & LCR_BREAK_MASK) >> LCR_BREAK_LSB)
-#define LCR_BREAK_SET(x)                         (((x) << LCR_BREAK_LSB) & LCR_BREAK_MASK)
-#define LCR_EPS_MSB                              4
-#define LCR_EPS_LSB                              4
-#define LCR_EPS_MASK                             0x00000010
-#define LCR_EPS_GET(x)                           (((x) & LCR_EPS_MASK) >> LCR_EPS_LSB)
-#define LCR_EPS_SET(x)                           (((x) << LCR_EPS_LSB) & LCR_EPS_MASK)
-#define LCR_PEN_MSB                              3
-#define LCR_PEN_LSB                              3
-#define LCR_PEN_MASK                             0x00000008
-#define LCR_PEN_GET(x)                           (((x) & LCR_PEN_MASK) >> LCR_PEN_LSB)
-#define LCR_PEN_SET(x)                           (((x) << LCR_PEN_LSB) & LCR_PEN_MASK)
-#define LCR_STOP_MSB                             2
-#define LCR_STOP_LSB                             2
-#define LCR_STOP_MASK                            0x00000004
-#define LCR_STOP_GET(x)                          (((x) & LCR_STOP_MASK) >> LCR_STOP_LSB)
-#define LCR_STOP_SET(x)                          (((x) << LCR_STOP_LSB) & LCR_STOP_MASK)
-#define LCR_CLS_MSB                              1
-#define LCR_CLS_LSB                              0
-#define LCR_CLS_MASK                             0x00000003
-#define LCR_CLS_GET(x)                           (((x) & LCR_CLS_MASK) >> LCR_CLS_LSB)
-#define LCR_CLS_SET(x)                           (((x) << LCR_CLS_LSB) & LCR_CLS_MASK)
-
-#define MCR_ADDRESS                              0x00000010
-#define MCR_OFFSET                               0x00000010
-#define MCR_LOOPBACK_MSB                         5
-#define MCR_LOOPBACK_LSB                         5
-#define MCR_LOOPBACK_MASK                        0x00000020
-#define MCR_LOOPBACK_GET(x)                      (((x) & MCR_LOOPBACK_MASK) >> MCR_LOOPBACK_LSB)
-#define MCR_LOOPBACK_SET(x)                      (((x) << MCR_LOOPBACK_LSB) & MCR_LOOPBACK_MASK)
-#define MCR_OUT2_MSB                             3
-#define MCR_OUT2_LSB                             3
-#define MCR_OUT2_MASK                            0x00000008
-#define MCR_OUT2_GET(x)                          (((x) & MCR_OUT2_MASK) >> MCR_OUT2_LSB)
-#define MCR_OUT2_SET(x)                          (((x) << MCR_OUT2_LSB) & MCR_OUT2_MASK)
-#define MCR_OUT1_MSB                             2
-#define MCR_OUT1_LSB                             2
-#define MCR_OUT1_MASK                            0x00000004
-#define MCR_OUT1_GET(x)                          (((x) & MCR_OUT1_MASK) >> MCR_OUT1_LSB)
-#define MCR_OUT1_SET(x)                          (((x) << MCR_OUT1_LSB) & MCR_OUT1_MASK)
-#define MCR_RTS_MSB                              1
-#define MCR_RTS_LSB                              1
-#define MCR_RTS_MASK                             0x00000002
-#define MCR_RTS_GET(x)                           (((x) & MCR_RTS_MASK) >> MCR_RTS_LSB)
-#define MCR_RTS_SET(x)                           (((x) << MCR_RTS_LSB) & MCR_RTS_MASK)
-#define MCR_DTR_MSB                              0
-#define MCR_DTR_LSB                              0
-#define MCR_DTR_MASK                             0x00000001
-#define MCR_DTR_GET(x)                           (((x) & MCR_DTR_MASK) >> MCR_DTR_LSB)
-#define MCR_DTR_SET(x)                           (((x) << MCR_DTR_LSB) & MCR_DTR_MASK)
-
-#define LSR_ADDRESS                              0x00000014
-#define LSR_OFFSET                               0x00000014
-#define LSR_FERR_MSB                             7
-#define LSR_FERR_LSB                             7
-#define LSR_FERR_MASK                            0x00000080
-#define LSR_FERR_GET(x)                          (((x) & LSR_FERR_MASK) >> LSR_FERR_LSB)
-#define LSR_FERR_SET(x)                          (((x) << LSR_FERR_LSB) & LSR_FERR_MASK)
-#define LSR_TEMT_MSB                             6
-#define LSR_TEMT_LSB                             6
-#define LSR_TEMT_MASK                            0x00000040
-#define LSR_TEMT_GET(x)                          (((x) & LSR_TEMT_MASK) >> LSR_TEMT_LSB)
-#define LSR_TEMT_SET(x)                          (((x) << LSR_TEMT_LSB) & LSR_TEMT_MASK)
-#define LSR_THRE_MSB                             5
-#define LSR_THRE_LSB                             5
-#define LSR_THRE_MASK                            0x00000020
-#define LSR_THRE_GET(x)                          (((x) & LSR_THRE_MASK) >> LSR_THRE_LSB)
-#define LSR_THRE_SET(x)                          (((x) << LSR_THRE_LSB) & LSR_THRE_MASK)
-#define LSR_BI_MSB                               4
-#define LSR_BI_LSB                               4
-#define LSR_BI_MASK                              0x00000010
-#define LSR_BI_GET(x)                            (((x) & LSR_BI_MASK) >> LSR_BI_LSB)
-#define LSR_BI_SET(x)                            (((x) << LSR_BI_LSB) & LSR_BI_MASK)
-#define LSR_FE_MSB                               3
-#define LSR_FE_LSB                               3
-#define LSR_FE_MASK                              0x00000008
-#define LSR_FE_GET(x)                            (((x) & LSR_FE_MASK) >> LSR_FE_LSB)
-#define LSR_FE_SET(x)                            (((x) << LSR_FE_LSB) & LSR_FE_MASK)
-#define LSR_PE_MSB                               2
-#define LSR_PE_LSB                               2
-#define LSR_PE_MASK                              0x00000004
-#define LSR_PE_GET(x)                            (((x) & LSR_PE_MASK) >> LSR_PE_LSB)
-#define LSR_PE_SET(x)                            (((x) << LSR_PE_LSB) & LSR_PE_MASK)
-#define LSR_OE_MSB                               1
-#define LSR_OE_LSB                               1
-#define LSR_OE_MASK                              0x00000002
-#define LSR_OE_GET(x)                            (((x) & LSR_OE_MASK) >> LSR_OE_LSB)
-#define LSR_OE_SET(x)                            (((x) << LSR_OE_LSB) & LSR_OE_MASK)
-#define LSR_DR_MSB                               0
-#define LSR_DR_LSB                               0
-#define LSR_DR_MASK                              0x00000001
-#define LSR_DR_GET(x)                            (((x) & LSR_DR_MASK) >> LSR_DR_LSB)
-#define LSR_DR_SET(x)                            (((x) << LSR_DR_LSB) & LSR_DR_MASK)
-
-#define MSR_ADDRESS                              0x00000018
-#define MSR_OFFSET                               0x00000018
-#define MSR_DCD_MSB                              7
-#define MSR_DCD_LSB                              7
-#define MSR_DCD_MASK                             0x00000080
-#define MSR_DCD_GET(x)                           (((x) & MSR_DCD_MASK) >> MSR_DCD_LSB)
-#define MSR_DCD_SET(x)                           (((x) << MSR_DCD_LSB) & MSR_DCD_MASK)
-#define MSR_RI_MSB                               6
-#define MSR_RI_LSB                               6
-#define MSR_RI_MASK                              0x00000040
-#define MSR_RI_GET(x)                            (((x) & MSR_RI_MASK) >> MSR_RI_LSB)
-#define MSR_RI_SET(x)                            (((x) << MSR_RI_LSB) & MSR_RI_MASK)
-#define MSR_DSR_MSB                              5
-#define MSR_DSR_LSB                              5
-#define MSR_DSR_MASK                             0x00000020
-#define MSR_DSR_GET(x)                           (((x) & MSR_DSR_MASK) >> MSR_DSR_LSB)
-#define MSR_DSR_SET(x)                           (((x) << MSR_DSR_LSB) & MSR_DSR_MASK)
-#define MSR_CTS_MSB                              4
-#define MSR_CTS_LSB                              4
-#define MSR_CTS_MASK                             0x00000010
-#define MSR_CTS_GET(x)                           (((x) & MSR_CTS_MASK) >> MSR_CTS_LSB)
-#define MSR_CTS_SET(x)                           (((x) << MSR_CTS_LSB) & MSR_CTS_MASK)
-#define MSR_DDCD_MSB                             3
-#define MSR_DDCD_LSB                             3
-#define MSR_DDCD_MASK                            0x00000008
-#define MSR_DDCD_GET(x)                          (((x) & MSR_DDCD_MASK) >> MSR_DDCD_LSB)
-#define MSR_DDCD_SET(x)                          (((x) << MSR_DDCD_LSB) & MSR_DDCD_MASK)
-#define MSR_TERI_MSB                             2
-#define MSR_TERI_LSB                             2
-#define MSR_TERI_MASK                            0x00000004
-#define MSR_TERI_GET(x)                          (((x) & MSR_TERI_MASK) >> MSR_TERI_LSB)
-#define MSR_TERI_SET(x)                          (((x) << MSR_TERI_LSB) & MSR_TERI_MASK)
-#define MSR_DDSR_MSB                             1
-#define MSR_DDSR_LSB                             1
-#define MSR_DDSR_MASK                            0x00000002
-#define MSR_DDSR_GET(x)                          (((x) & MSR_DDSR_MASK) >> MSR_DDSR_LSB)
-#define MSR_DDSR_SET(x)                          (((x) << MSR_DDSR_LSB) & MSR_DDSR_MASK)
-#define MSR_DCTS_MSB                             0
-#define MSR_DCTS_LSB                             0
-#define MSR_DCTS_MASK                            0x00000001
-#define MSR_DCTS_GET(x)                          (((x) & MSR_DCTS_MASK) >> MSR_DCTS_LSB)
-#define MSR_DCTS_SET(x)                          (((x) << MSR_DCTS_LSB) & MSR_DCTS_MASK)
-
-#define SCR_ADDRESS                              0x0000001c
-#define SCR_OFFSET                               0x0000001c
-#define SCR_SCR_MSB                              7
-#define SCR_SCR_LSB                              0
-#define SCR_SCR_MASK                             0x000000ff
-#define SCR_SCR_GET(x)                           (((x) & SCR_SCR_MASK) >> SCR_SCR_LSB)
-#define SCR_SCR_SET(x)                           (((x) << SCR_SCR_LSB) & SCR_SCR_MASK)
-
-#define SRBR_ADDRESS                             0x00000020
-#define SRBR_OFFSET                              0x00000020
-#define SRBR_SRBR_MSB                            7
-#define SRBR_SRBR_LSB                            0
-#define SRBR_SRBR_MASK                           0x000000ff
-#define SRBR_SRBR_GET(x)                         (((x) & SRBR_SRBR_MASK) >> SRBR_SRBR_LSB)
-#define SRBR_SRBR_SET(x)                         (((x) << SRBR_SRBR_LSB) & SRBR_SRBR_MASK)
-
-#define SIIR_ADDRESS                             0x00000028
-#define SIIR_OFFSET                              0x00000028
-#define SIIR_SIIR_MSB                            7
-#define SIIR_SIIR_LSB                            0
-#define SIIR_SIIR_MASK                           0x000000ff
-#define SIIR_SIIR_GET(x)                         (((x) & SIIR_SIIR_MASK) >> SIIR_SIIR_LSB)
-#define SIIR_SIIR_SET(x)                         (((x) << SIIR_SIIR_LSB) & SIIR_SIIR_MASK)
-
-#define MWR_ADDRESS                              0x0000002c
-#define MWR_OFFSET                               0x0000002c
-#define MWR_MWR_MSB                              31
-#define MWR_MWR_LSB                              0
-#define MWR_MWR_MASK                             0xffffffff
-#define MWR_MWR_GET(x)                           (((x) & MWR_MWR_MASK) >> MWR_MWR_LSB)
-#define MWR_MWR_SET(x)                           (((x) << MWR_MWR_LSB) & MWR_MWR_MASK)
-
-#define SLSR_ADDRESS                             0x00000034
-#define SLSR_OFFSET                              0x00000034
-#define SLSR_SLSR_MSB                            7
-#define SLSR_SLSR_LSB                            0
-#define SLSR_SLSR_MASK                           0x000000ff
-#define SLSR_SLSR_GET(x)                         (((x) & SLSR_SLSR_MASK) >> SLSR_SLSR_LSB)
-#define SLSR_SLSR_SET(x)                         (((x) << SLSR_SLSR_LSB) & SLSR_SLSR_MASK)
-
-#define SMSR_ADDRESS                             0x00000038
-#define SMSR_OFFSET                              0x00000038
-#define SMSR_SMSR_MSB                            7
-#define SMSR_SMSR_LSB                            0
-#define SMSR_SMSR_MASK                           0x000000ff
-#define SMSR_SMSR_GET(x)                         (((x) & SMSR_SMSR_MASK) >> SMSR_SMSR_LSB)
-#define SMSR_SMSR_SET(x)                         (((x) << SMSR_SMSR_LSB) & SMSR_SMSR_MASK)
-
-#define MRR_ADDRESS                              0x0000003c
-#define MRR_OFFSET                               0x0000003c
-#define MRR_MRR_MSB                              31
-#define MRR_MRR_LSB                              0
-#define MRR_MRR_MASK                             0xffffffff
-#define MRR_MRR_GET(x)                           (((x) & MRR_MRR_MASK) >> MRR_MRR_LSB)
-#define MRR_MRR_SET(x)                           (((x) << MRR_MRR_LSB) & MRR_MRR_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct uart_reg_reg_s {
-  volatile unsigned int rbr;
-  volatile unsigned int dlh;
-  volatile unsigned int iir;
-  volatile unsigned int lcr;
-  volatile unsigned int mcr;
-  volatile unsigned int lsr;
-  volatile unsigned int msr;
-  volatile unsigned int scr;
-  volatile unsigned int srbr;
-  unsigned char pad0[4]; /* pad to 0x28 */
-  volatile unsigned int siir;
-  volatile unsigned int mwr;
-  unsigned char pad1[4]; /* pad to 0x34 */
-  volatile unsigned int slsr;
-  volatile unsigned int smsr;
-  volatile unsigned int mrr;
-} uart_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _UART_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h
deleted file mode 100644
index 932ec51..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h
+++ /dev/null
@@ -1,76 +0,0 @@
-#ifndef _VMC_REG_REG_H_
-#define _VMC_REG_REG_H_
-
-#define MC_TCAM_VALID_ADDRESS                    0x00000000
-#define MC_TCAM_VALID_OFFSET                     0x00000000
-#define MC_TCAM_VALID_BIT_MSB                    0
-#define MC_TCAM_VALID_BIT_LSB                    0
-#define MC_TCAM_VALID_BIT_MASK                   0x00000001
-#define MC_TCAM_VALID_BIT_GET(x)                 (((x) & MC_TCAM_VALID_BIT_MASK) >> MC_TCAM_VALID_BIT_LSB)
-#define MC_TCAM_VALID_BIT_SET(x)                 (((x) << MC_TCAM_VALID_BIT_LSB) & MC_TCAM_VALID_BIT_MASK)
-
-#define MC_TCAM_MASK_ADDRESS                     0x00000080
-#define MC_TCAM_MASK_OFFSET                      0x00000080
-#define MC_TCAM_MASK_SIZE_MSB                    2
-#define MC_TCAM_MASK_SIZE_LSB                    0
-#define MC_TCAM_MASK_SIZE_MASK                   0x00000007
-#define MC_TCAM_MASK_SIZE_GET(x)                 (((x) & MC_TCAM_MASK_SIZE_MASK) >> MC_TCAM_MASK_SIZE_LSB)
-#define MC_TCAM_MASK_SIZE_SET(x)                 (((x) << MC_TCAM_MASK_SIZE_LSB) & MC_TCAM_MASK_SIZE_MASK)
-
-#define MC_TCAM_COMPARE_ADDRESS                  0x00000100
-#define MC_TCAM_COMPARE_OFFSET                   0x00000100
-#define MC_TCAM_COMPARE_KEY_MSB                  21
-#define MC_TCAM_COMPARE_KEY_LSB                  5
-#define MC_TCAM_COMPARE_KEY_MASK                 0x003fffe0
-#define MC_TCAM_COMPARE_KEY_GET(x)               (((x) & MC_TCAM_COMPARE_KEY_MASK) >> MC_TCAM_COMPARE_KEY_LSB)
-#define MC_TCAM_COMPARE_KEY_SET(x)               (((x) << MC_TCAM_COMPARE_KEY_LSB) & MC_TCAM_COMPARE_KEY_MASK)
-
-#define MC_TCAM_TARGET_ADDRESS                   0x00000180
-#define MC_TCAM_TARGET_OFFSET                    0x00000180
-#define MC_TCAM_TARGET_ADDR_MSB                  21
-#define MC_TCAM_TARGET_ADDR_LSB                  5
-#define MC_TCAM_TARGET_ADDR_MASK                 0x003fffe0
-#define MC_TCAM_TARGET_ADDR_GET(x)               (((x) & MC_TCAM_TARGET_ADDR_MASK) >> MC_TCAM_TARGET_ADDR_LSB)
-#define MC_TCAM_TARGET_ADDR_SET(x)               (((x) << MC_TCAM_TARGET_ADDR_LSB) & MC_TCAM_TARGET_ADDR_MASK)
-
-#define ADDR_ERROR_CONTROL_ADDRESS               0x00000200
-#define ADDR_ERROR_CONTROL_OFFSET                0x00000200
-#define ADDR_ERROR_CONTROL_QUAL_ENABLE_MSB       1
-#define ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB       1
-#define ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK      0x00000002
-#define ADDR_ERROR_CONTROL_QUAL_ENABLE_GET(x)    (((x) & ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK) >> ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB)
-#define ADDR_ERROR_CONTROL_QUAL_ENABLE_SET(x)    (((x) << ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB) & ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK)
-#define ADDR_ERROR_CONTROL_ENABLE_MSB            0
-#define ADDR_ERROR_CONTROL_ENABLE_LSB            0
-#define ADDR_ERROR_CONTROL_ENABLE_MASK           0x00000001
-#define ADDR_ERROR_CONTROL_ENABLE_GET(x)         (((x) & ADDR_ERROR_CONTROL_ENABLE_MASK) >> ADDR_ERROR_CONTROL_ENABLE_LSB)
-#define ADDR_ERROR_CONTROL_ENABLE_SET(x)         (((x) << ADDR_ERROR_CONTROL_ENABLE_LSB) & ADDR_ERROR_CONTROL_ENABLE_MASK)
-
-#define ADDR_ERROR_STATUS_ADDRESS                0x00000204
-#define ADDR_ERROR_STATUS_OFFSET                 0x00000204
-#define ADDR_ERROR_STATUS_WRITE_MSB              25
-#define ADDR_ERROR_STATUS_WRITE_LSB              25
-#define ADDR_ERROR_STATUS_WRITE_MASK             0x02000000
-#define ADDR_ERROR_STATUS_WRITE_GET(x)           (((x) & ADDR_ERROR_STATUS_WRITE_MASK) >> ADDR_ERROR_STATUS_WRITE_LSB)
-#define ADDR_ERROR_STATUS_WRITE_SET(x)           (((x) << ADDR_ERROR_STATUS_WRITE_LSB) & ADDR_ERROR_STATUS_WRITE_MASK)
-#define ADDR_ERROR_STATUS_ADDRESS_MSB            24
-#define ADDR_ERROR_STATUS_ADDRESS_LSB            0
-#define ADDR_ERROR_STATUS_ADDRESS_MASK           0x01ffffff
-#define ADDR_ERROR_STATUS_ADDRESS_GET(x)         (((x) & ADDR_ERROR_STATUS_ADDRESS_MASK) >> ADDR_ERROR_STATUS_ADDRESS_LSB)
-#define ADDR_ERROR_STATUS_ADDRESS_SET(x)         (((x) << ADDR_ERROR_STATUS_ADDRESS_LSB) & ADDR_ERROR_STATUS_ADDRESS_MASK)
-
-
-#ifndef __ASSEMBLER__
-
-typedef struct vmc_reg_reg_s {
-  volatile unsigned int mc_tcam_valid[32];
-  volatile unsigned int mc_tcam_mask[32];
-  volatile unsigned int mc_tcam_compare[32];
-  volatile unsigned int mc_tcam_target[32];
-  volatile unsigned int addr_error_control;
-  volatile unsigned int addr_error_status;
-} vmc_reg_reg_t;
-
-#endif /* __ASSEMBLER__ */
-
-#endif /* _VMC_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
deleted file mode 120000
index 8fae5c6..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
+++ /dev/null
@@ -1 +0,0 @@
-../hw.0
\ No newline at end of file
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
new file mode 100644
index 0000000..9c82767
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
@@ -0,0 +1,64 @@
+#ifndef _ANALOG_INTF_REG_REG_H_
+#define _ANALOG_INTF_REG_REG_H_
+
+#define SW_OVERRIDE_ADDRESS                      0x00000080
+#define SW_OVERRIDE_OFFSET                       0x00000080
+#define SW_OVERRIDE_SUPDATE_DELAY_MSB            1
+#define SW_OVERRIDE_SUPDATE_DELAY_LSB            1
+#define SW_OVERRIDE_SUPDATE_DELAY_MASK           0x00000002
+#define SW_OVERRIDE_SUPDATE_DELAY_GET(x)         (((x) & SW_OVERRIDE_SUPDATE_DELAY_MASK) >> SW_OVERRIDE_SUPDATE_DELAY_LSB)
+#define SW_OVERRIDE_SUPDATE_DELAY_SET(x)         (((x) << SW_OVERRIDE_SUPDATE_DELAY_LSB) & SW_OVERRIDE_SUPDATE_DELAY_MASK)
+#define SW_OVERRIDE_ENABLE_MSB                   0
+#define SW_OVERRIDE_ENABLE_LSB                   0
+#define SW_OVERRIDE_ENABLE_MASK                  0x00000001
+#define SW_OVERRIDE_ENABLE_GET(x)                (((x) & SW_OVERRIDE_ENABLE_MASK) >> SW_OVERRIDE_ENABLE_LSB)
+#define SW_OVERRIDE_ENABLE_SET(x)                (((x) << SW_OVERRIDE_ENABLE_LSB) & SW_OVERRIDE_ENABLE_MASK)
+
+#define SIN_VAL_ADDRESS                          0x00000084
+#define SIN_VAL_OFFSET                           0x00000084
+#define SIN_VAL_SIN_MSB                          0
+#define SIN_VAL_SIN_LSB                          0
+#define SIN_VAL_SIN_MASK                         0x00000001
+#define SIN_VAL_SIN_GET(x)                       (((x) & SIN_VAL_SIN_MASK) >> SIN_VAL_SIN_LSB)
+#define SIN_VAL_SIN_SET(x)                       (((x) << SIN_VAL_SIN_LSB) & SIN_VAL_SIN_MASK)
+
+#define SW_SCLK_ADDRESS                          0x00000088
+#define SW_SCLK_OFFSET                           0x00000088
+#define SW_SCLK_SW_SCLK_MSB                      0
+#define SW_SCLK_SW_SCLK_LSB                      0
+#define SW_SCLK_SW_SCLK_MASK                     0x00000001
+#define SW_SCLK_SW_SCLK_GET(x)                   (((x) & SW_SCLK_SW_SCLK_MASK) >> SW_SCLK_SW_SCLK_LSB)
+#define SW_SCLK_SW_SCLK_SET(x)                   (((x) << SW_SCLK_SW_SCLK_LSB) & SW_SCLK_SW_SCLK_MASK)
+
+#define SW_CNTL_ADDRESS                          0x0000008c
+#define SW_CNTL_OFFSET                           0x0000008c
+#define SW_CNTL_SW_SCAPTURE_MSB                  2
+#define SW_CNTL_SW_SCAPTURE_LSB                  2
+#define SW_CNTL_SW_SCAPTURE_MASK                 0x00000004
+#define SW_CNTL_SW_SCAPTURE_GET(x)               (((x) & SW_CNTL_SW_SCAPTURE_MASK) >> SW_CNTL_SW_SCAPTURE_LSB)
+#define SW_CNTL_SW_SCAPTURE_SET(x)               (((x) << SW_CNTL_SW_SCAPTURE_LSB) & SW_CNTL_SW_SCAPTURE_MASK)
+#define SW_CNTL_SW_SUPDATE_MSB                   1
+#define SW_CNTL_SW_SUPDATE_LSB                   1
+#define SW_CNTL_SW_SUPDATE_MASK                  0x00000002
+#define SW_CNTL_SW_SUPDATE_GET(x)                (((x) & SW_CNTL_SW_SUPDATE_MASK) >> SW_CNTL_SW_SUPDATE_LSB)
+#define SW_CNTL_SW_SUPDATE_SET(x)                (((x) << SW_CNTL_SW_SUPDATE_LSB) & SW_CNTL_SW_SUPDATE_MASK)
+#define SW_CNTL_SW_SOUT_MSB                      0
+#define SW_CNTL_SW_SOUT_LSB                      0
+#define SW_CNTL_SW_SOUT_MASK                     0x00000001
+#define SW_CNTL_SW_SOUT_GET(x)                   (((x) & SW_CNTL_SW_SOUT_MASK) >> SW_CNTL_SW_SOUT_LSB)
+#define SW_CNTL_SW_SOUT_SET(x)                   (((x) << SW_CNTL_SW_SOUT_LSB) & SW_CNTL_SW_SOUT_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct analog_intf_reg_reg_s {
+  unsigned char pad0[128]; /* pad to 0x80 */
+  volatile unsigned int sw_override;
+  volatile unsigned int sin_val;
+  volatile unsigned int sw_sclk;
+  volatile unsigned int sw_cntl;
+} analog_intf_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _ANALOG_INTF_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
new file mode 100644
index 0000000..cf562b8
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
@@ -0,0 +1,1932 @@
+#ifndef _ANALOG_REG_REG_H_
+#define _ANALOG_REG_REG_H_
+
+#define SYNTH_SYNTH1_ADDRESS                     0x00000000
+#define SYNTH_SYNTH1_OFFSET                      0x00000000
+#define SYNTH_SYNTH1_PWD_BIAS_MSB                31
+#define SYNTH_SYNTH1_PWD_BIAS_LSB                31
+#define SYNTH_SYNTH1_PWD_BIAS_MASK               0x80000000
+#define SYNTH_SYNTH1_PWD_BIAS_GET(x)             (((x) & SYNTH_SYNTH1_PWD_BIAS_MASK) >> SYNTH_SYNTH1_PWD_BIAS_LSB)
+#define SYNTH_SYNTH1_PWD_BIAS_SET(x)             (((x) << SYNTH_SYNTH1_PWD_BIAS_LSB) & SYNTH_SYNTH1_PWD_BIAS_MASK)
+#define SYNTH_SYNTH1_PWD_CP_MSB                  30
+#define SYNTH_SYNTH1_PWD_CP_LSB                  30
+#define SYNTH_SYNTH1_PWD_CP_MASK                 0x40000000
+#define SYNTH_SYNTH1_PWD_CP_GET(x)               (((x) & SYNTH_SYNTH1_PWD_CP_MASK) >> SYNTH_SYNTH1_PWD_CP_LSB)
+#define SYNTH_SYNTH1_PWD_CP_SET(x)               (((x) << SYNTH_SYNTH1_PWD_CP_LSB) & SYNTH_SYNTH1_PWD_CP_MASK)
+#define SYNTH_SYNTH1_PWD_VCMON_MSB               29
+#define SYNTH_SYNTH1_PWD_VCMON_LSB               29
+#define SYNTH_SYNTH1_PWD_VCMON_MASK              0x20000000
+#define SYNTH_SYNTH1_PWD_VCMON_GET(x)            (((x) & SYNTH_SYNTH1_PWD_VCMON_MASK) >> SYNTH_SYNTH1_PWD_VCMON_LSB)
+#define SYNTH_SYNTH1_PWD_VCMON_SET(x)            (((x) << SYNTH_SYNTH1_PWD_VCMON_LSB) & SYNTH_SYNTH1_PWD_VCMON_MASK)
+#define SYNTH_SYNTH1_PWD_VCO_MSB                 28
+#define SYNTH_SYNTH1_PWD_VCO_LSB                 28
+#define SYNTH_SYNTH1_PWD_VCO_MASK                0x10000000
+#define SYNTH_SYNTH1_PWD_VCO_GET(x)              (((x) & SYNTH_SYNTH1_PWD_VCO_MASK) >> SYNTH_SYNTH1_PWD_VCO_LSB)
+#define SYNTH_SYNTH1_PWD_VCO_SET(x)              (((x) << SYNTH_SYNTH1_PWD_VCO_LSB) & SYNTH_SYNTH1_PWD_VCO_MASK)
+#define SYNTH_SYNTH1_PWD_PRESC_MSB               27
+#define SYNTH_SYNTH1_PWD_PRESC_LSB               27
+#define SYNTH_SYNTH1_PWD_PRESC_MASK              0x08000000
+#define SYNTH_SYNTH1_PWD_PRESC_GET(x)            (((x) & SYNTH_SYNTH1_PWD_PRESC_MASK) >> SYNTH_SYNTH1_PWD_PRESC_LSB)
+#define SYNTH_SYNTH1_PWD_PRESC_SET(x)            (((x) << SYNTH_SYNTH1_PWD_PRESC_LSB) & SYNTH_SYNTH1_PWD_PRESC_MASK)
+#define SYNTH_SYNTH1_PWD_LODIV_MSB               26
+#define SYNTH_SYNTH1_PWD_LODIV_LSB               26
+#define SYNTH_SYNTH1_PWD_LODIV_MASK              0x04000000
+#define SYNTH_SYNTH1_PWD_LODIV_GET(x)            (((x) & SYNTH_SYNTH1_PWD_LODIV_MASK) >> SYNTH_SYNTH1_PWD_LODIV_LSB)
+#define SYNTH_SYNTH1_PWD_LODIV_SET(x)            (((x) << SYNTH_SYNTH1_PWD_LODIV_LSB) & SYNTH_SYNTH1_PWD_LODIV_MASK)
+#define SYNTH_SYNTH1_PWD_LOMIX_MSB               25
+#define SYNTH_SYNTH1_PWD_LOMIX_LSB               25
+#define SYNTH_SYNTH1_PWD_LOMIX_MASK              0x02000000
+#define SYNTH_SYNTH1_PWD_LOMIX_GET(x)            (((x) & SYNTH_SYNTH1_PWD_LOMIX_MASK) >> SYNTH_SYNTH1_PWD_LOMIX_LSB)
+#define SYNTH_SYNTH1_PWD_LOMIX_SET(x)            (((x) << SYNTH_SYNTH1_PWD_LOMIX_LSB) & SYNTH_SYNTH1_PWD_LOMIX_MASK)
+#define SYNTH_SYNTH1_FORCE_LO_ON_MSB             24
+#define SYNTH_SYNTH1_FORCE_LO_ON_LSB             24
+#define SYNTH_SYNTH1_FORCE_LO_ON_MASK            0x01000000
+#define SYNTH_SYNTH1_FORCE_LO_ON_GET(x)          (((x) & SYNTH_SYNTH1_FORCE_LO_ON_MASK) >> SYNTH_SYNTH1_FORCE_LO_ON_LSB)
+#define SYNTH_SYNTH1_FORCE_LO_ON_SET(x)          (((x) << SYNTH_SYNTH1_FORCE_LO_ON_LSB) & SYNTH_SYNTH1_FORCE_LO_ON_MASK)
+#define SYNTH_SYNTH1_PWD_LOBUF5G_MSB             23
+#define SYNTH_SYNTH1_PWD_LOBUF5G_LSB             23
+#define SYNTH_SYNTH1_PWD_LOBUF5G_MASK            0x00800000
+#define SYNTH_SYNTH1_PWD_LOBUF5G_GET(x)          (((x) & SYNTH_SYNTH1_PWD_LOBUF5G_MASK) >> SYNTH_SYNTH1_PWD_LOBUF5G_LSB)
+#define SYNTH_SYNTH1_PWD_LOBUF5G_SET(x)          (((x) << SYNTH_SYNTH1_PWD_LOBUF5G_LSB) & SYNTH_SYNTH1_PWD_LOBUF5G_MASK)
+#define SYNTH_SYNTH1_VCOREGBYPASS_MSB            22
+#define SYNTH_SYNTH1_VCOREGBYPASS_LSB            22
+#define SYNTH_SYNTH1_VCOREGBYPASS_MASK           0x00400000
+#define SYNTH_SYNTH1_VCOREGBYPASS_GET(x)         (((x) & SYNTH_SYNTH1_VCOREGBYPASS_MASK) >> SYNTH_SYNTH1_VCOREGBYPASS_LSB)
+#define SYNTH_SYNTH1_VCOREGBYPASS_SET(x)         (((x) << SYNTH_SYNTH1_VCOREGBYPASS_LSB) & SYNTH_SYNTH1_VCOREGBYPASS_MASK)
+#define SYNTH_SYNTH1_VCOREGLEVEL_MSB             21
+#define SYNTH_SYNTH1_VCOREGLEVEL_LSB             20
+#define SYNTH_SYNTH1_VCOREGLEVEL_MASK            0x00300000
+#define SYNTH_SYNTH1_VCOREGLEVEL_GET(x)          (((x) & SYNTH_SYNTH1_VCOREGLEVEL_MASK) >> SYNTH_SYNTH1_VCOREGLEVEL_LSB)
+#define SYNTH_SYNTH1_VCOREGLEVEL_SET(x)          (((x) << SYNTH_SYNTH1_VCOREGLEVEL_LSB) & SYNTH_SYNTH1_VCOREGLEVEL_MASK)
+#define SYNTH_SYNTH1_VCOREGBIAS_MSB              19
+#define SYNTH_SYNTH1_VCOREGBIAS_LSB              18
+#define SYNTH_SYNTH1_VCOREGBIAS_MASK             0x000c0000
+#define SYNTH_SYNTH1_VCOREGBIAS_GET(x)           (((x) & SYNTH_SYNTH1_VCOREGBIAS_MASK) >> SYNTH_SYNTH1_VCOREGBIAS_LSB)
+#define SYNTH_SYNTH1_VCOREGBIAS_SET(x)           (((x) << SYNTH_SYNTH1_VCOREGBIAS_LSB) & SYNTH_SYNTH1_VCOREGBIAS_MASK)
+#define SYNTH_SYNTH1_SLIDINGIF_MSB               17
+#define SYNTH_SYNTH1_SLIDINGIF_LSB               17
+#define SYNTH_SYNTH1_SLIDINGIF_MASK              0x00020000
+#define SYNTH_SYNTH1_SLIDINGIF_GET(x)            (((x) & SYNTH_SYNTH1_SLIDINGIF_MASK) >> SYNTH_SYNTH1_SLIDINGIF_LSB)
+#define SYNTH_SYNTH1_SLIDINGIF_SET(x)            (((x) << SYNTH_SYNTH1_SLIDINGIF_LSB) & SYNTH_SYNTH1_SLIDINGIF_MASK)
+#define SYNTH_SYNTH1_SPARE_PWD_MSB               16
+#define SYNTH_SYNTH1_SPARE_PWD_LSB               16
+#define SYNTH_SYNTH1_SPARE_PWD_MASK              0x00010000
+#define SYNTH_SYNTH1_SPARE_PWD_GET(x)            (((x) & SYNTH_SYNTH1_SPARE_PWD_MASK) >> SYNTH_SYNTH1_SPARE_PWD_LSB)
+#define SYNTH_SYNTH1_SPARE_PWD_SET(x)            (((x) << SYNTH_SYNTH1_SPARE_PWD_LSB) & SYNTH_SYNTH1_SPARE_PWD_MASK)
+#define SYNTH_SYNTH1_CON_VDDVCOREG_MSB           15
+#define SYNTH_SYNTH1_CON_VDDVCOREG_LSB           15
+#define SYNTH_SYNTH1_CON_VDDVCOREG_MASK          0x00008000
+#define SYNTH_SYNTH1_CON_VDDVCOREG_GET(x)        (((x) & SYNTH_SYNTH1_CON_VDDVCOREG_MASK) >> SYNTH_SYNTH1_CON_VDDVCOREG_LSB)
+#define SYNTH_SYNTH1_CON_VDDVCOREG_SET(x)        (((x) << SYNTH_SYNTH1_CON_VDDVCOREG_LSB) & SYNTH_SYNTH1_CON_VDDVCOREG_MASK)
+#define SYNTH_SYNTH1_CON_IVCOREG_MSB             14
+#define SYNTH_SYNTH1_CON_IVCOREG_LSB             14
+#define SYNTH_SYNTH1_CON_IVCOREG_MASK            0x00004000
+#define SYNTH_SYNTH1_CON_IVCOREG_GET(x)          (((x) & SYNTH_SYNTH1_CON_IVCOREG_MASK) >> SYNTH_SYNTH1_CON_IVCOREG_LSB)
+#define SYNTH_SYNTH1_CON_IVCOREG_SET(x)          (((x) << SYNTH_SYNTH1_CON_IVCOREG_LSB) & SYNTH_SYNTH1_CON_IVCOREG_MASK)
+#define SYNTH_SYNTH1_CON_IVCOBUF_MSB             13
+#define SYNTH_SYNTH1_CON_IVCOBUF_LSB             13
+#define SYNTH_SYNTH1_CON_IVCOBUF_MASK            0x00002000
+#define SYNTH_SYNTH1_CON_IVCOBUF_GET(x)          (((x) & SYNTH_SYNTH1_CON_IVCOBUF_MASK) >> SYNTH_SYNTH1_CON_IVCOBUF_LSB)
+#define SYNTH_SYNTH1_CON_IVCOBUF_SET(x)          (((x) << SYNTH_SYNTH1_CON_IVCOBUF_LSB) & SYNTH_SYNTH1_CON_IVCOBUF_MASK)
+#define SYNTH_SYNTH1_SEL_VCMONABUS_MSB           12
+#define SYNTH_SYNTH1_SEL_VCMONABUS_LSB           10
+#define SYNTH_SYNTH1_SEL_VCMONABUS_MASK          0x00001c00
+#define SYNTH_SYNTH1_SEL_VCMONABUS_GET(x)        (((x) & SYNTH_SYNTH1_SEL_VCMONABUS_MASK) >> SYNTH_SYNTH1_SEL_VCMONABUS_LSB)
+#define SYNTH_SYNTH1_SEL_VCMONABUS_SET(x)        (((x) << SYNTH_SYNTH1_SEL_VCMONABUS_LSB) & SYNTH_SYNTH1_SEL_VCMONABUS_MASK)
+#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_MSB          9
+#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB          9
+#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK         0x00000200
+#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_GET(x)       (((x) & SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK) >> SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB)
+#define SYNTH_SYNTH1_PWUP_VCOBUF_PD_SET(x)       (((x) << SYNTH_SYNTH1_PWUP_VCOBUF_PD_LSB) & SYNTH_SYNTH1_PWUP_VCOBUF_PD_MASK)
+#define SYNTH_SYNTH1_PWUP_LODIV_PD_MSB           8
+#define SYNTH_SYNTH1_PWUP_LODIV_PD_LSB           8
+#define SYNTH_SYNTH1_PWUP_LODIV_PD_MASK          0x00000100
+#define SYNTH_SYNTH1_PWUP_LODIV_PD_GET(x)        (((x) & SYNTH_SYNTH1_PWUP_LODIV_PD_MASK) >> SYNTH_SYNTH1_PWUP_LODIV_PD_LSB)
+#define SYNTH_SYNTH1_PWUP_LODIV_PD_SET(x)        (((x) << SYNTH_SYNTH1_PWUP_LODIV_PD_LSB) & SYNTH_SYNTH1_PWUP_LODIV_PD_MASK)
+#define SYNTH_SYNTH1_PWUP_LOMIX_PD_MSB           7
+#define SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB           7
+#define SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK          0x00000080
+#define SYNTH_SYNTH1_PWUP_LOMIX_PD_GET(x)        (((x) & SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK) >> SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB)
+#define SYNTH_SYNTH1_PWUP_LOMIX_PD_SET(x)        (((x) << SYNTH_SYNTH1_PWUP_LOMIX_PD_LSB) & SYNTH_SYNTH1_PWUP_LOMIX_PD_MASK)
+#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MSB         6
+#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB         6
+#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK        0x00000040
+#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_GET(x)      (((x) & SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK) >> SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB)
+#define SYNTH_SYNTH1_PWUP_LOBUF5G_PD_SET(x)      (((x) << SYNTH_SYNTH1_PWUP_LOBUF5G_PD_LSB) & SYNTH_SYNTH1_PWUP_LOBUF5G_PD_MASK)
+#define SYNTH_SYNTH1_MONITOR_FB_MSB              5
+#define SYNTH_SYNTH1_MONITOR_FB_LSB              5
+#define SYNTH_SYNTH1_MONITOR_FB_MASK             0x00000020
+#define SYNTH_SYNTH1_MONITOR_FB_GET(x)           (((x) & SYNTH_SYNTH1_MONITOR_FB_MASK) >> SYNTH_SYNTH1_MONITOR_FB_LSB)
+#define SYNTH_SYNTH1_MONITOR_FB_SET(x)           (((x) << SYNTH_SYNTH1_MONITOR_FB_LSB) & SYNTH_SYNTH1_MONITOR_FB_MASK)
+#define SYNTH_SYNTH1_MONITOR_REF_MSB             4
+#define SYNTH_SYNTH1_MONITOR_REF_LSB             4
+#define SYNTH_SYNTH1_MONITOR_REF_MASK            0x00000010
+#define SYNTH_SYNTH1_MONITOR_REF_GET(x)          (((x) & SYNTH_SYNTH1_MONITOR_REF_MASK) >> SYNTH_SYNTH1_MONITOR_REF_LSB)
+#define SYNTH_SYNTH1_MONITOR_REF_SET(x)          (((x) << SYNTH_SYNTH1_MONITOR_REF_LSB) & SYNTH_SYNTH1_MONITOR_REF_MASK)
+#define SYNTH_SYNTH1_MONITOR_FB_DIV2_MSB         3
+#define SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB         3
+#define SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK        0x00000008
+#define SYNTH_SYNTH1_MONITOR_FB_DIV2_GET(x)      (((x) & SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK) >> SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB)
+#define SYNTH_SYNTH1_MONITOR_FB_DIV2_SET(x)      (((x) << SYNTH_SYNTH1_MONITOR_FB_DIV2_LSB) & SYNTH_SYNTH1_MONITOR_FB_DIV2_MASK)
+#define SYNTH_SYNTH1_MONITOR_VC2HIGH_MSB         2
+#define SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB         2
+#define SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK        0x00000004
+#define SYNTH_SYNTH1_MONITOR_VC2HIGH_GET(x)      (((x) & SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK) >> SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB)
+#define SYNTH_SYNTH1_MONITOR_VC2HIGH_SET(x)      (((x) << SYNTH_SYNTH1_MONITOR_VC2HIGH_LSB) & SYNTH_SYNTH1_MONITOR_VC2HIGH_MASK)
+#define SYNTH_SYNTH1_MONITOR_VC2LOW_MSB          1
+#define SYNTH_SYNTH1_MONITOR_VC2LOW_LSB          1
+#define SYNTH_SYNTH1_MONITOR_VC2LOW_MASK         0x00000002
+#define SYNTH_SYNTH1_MONITOR_VC2LOW_GET(x)       (((x) & SYNTH_SYNTH1_MONITOR_VC2LOW_MASK) >> SYNTH_SYNTH1_MONITOR_VC2LOW_LSB)
+#define SYNTH_SYNTH1_MONITOR_VC2LOW_SET(x)       (((x) << SYNTH_SYNTH1_MONITOR_VC2LOW_LSB) & SYNTH_SYNTH1_MONITOR_VC2LOW_MASK)
+#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MSB   0
+#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB   0
+#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK  0x00000001
+#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_GET(x) (((x) & SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK) >> SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB)
+#define SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_SET(x) (((x) << SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_LSB) & SYNTH_SYNTH1_MONITOR_SYNTHLOCKVCOK_MASK)
+
+#define SYNTH_SYNTH2_ADDRESS                     0x00000004
+#define SYNTH_SYNTH2_OFFSET                      0x00000004
+#define SYNTH_SYNTH2_VC_CAL_REF_MSB              31
+#define SYNTH_SYNTH2_VC_CAL_REF_LSB              29
+#define SYNTH_SYNTH2_VC_CAL_REF_MASK             0xe0000000
+#define SYNTH_SYNTH2_VC_CAL_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_CAL_REF_MASK) >> SYNTH_SYNTH2_VC_CAL_REF_LSB)
+#define SYNTH_SYNTH2_VC_CAL_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_CAL_REF_LSB) & SYNTH_SYNTH2_VC_CAL_REF_MASK)
+#define SYNTH_SYNTH2_VC_HI_REF_MSB               28
+#define SYNTH_SYNTH2_VC_HI_REF_LSB               26
+#define SYNTH_SYNTH2_VC_HI_REF_MASK              0x1c000000
+#define SYNTH_SYNTH2_VC_HI_REF_GET(x)            (((x) & SYNTH_SYNTH2_VC_HI_REF_MASK) >> SYNTH_SYNTH2_VC_HI_REF_LSB)
+#define SYNTH_SYNTH2_VC_HI_REF_SET(x)            (((x) << SYNTH_SYNTH2_VC_HI_REF_LSB) & SYNTH_SYNTH2_VC_HI_REF_MASK)
+#define SYNTH_SYNTH2_VC_MID_REF_MSB              25
+#define SYNTH_SYNTH2_VC_MID_REF_LSB              23
+#define SYNTH_SYNTH2_VC_MID_REF_MASK             0x03800000
+#define SYNTH_SYNTH2_VC_MID_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_MID_REF_MASK) >> SYNTH_SYNTH2_VC_MID_REF_LSB)
+#define SYNTH_SYNTH2_VC_MID_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_MID_REF_LSB) & SYNTH_SYNTH2_VC_MID_REF_MASK)
+#define SYNTH_SYNTH2_VC_LOW_REF_MSB              22
+#define SYNTH_SYNTH2_VC_LOW_REF_LSB              20
+#define SYNTH_SYNTH2_VC_LOW_REF_MASK             0x00700000
+#define SYNTH_SYNTH2_VC_LOW_REF_GET(x)           (((x) & SYNTH_SYNTH2_VC_LOW_REF_MASK) >> SYNTH_SYNTH2_VC_LOW_REF_LSB)
+#define SYNTH_SYNTH2_VC_LOW_REF_SET(x)           (((x) << SYNTH_SYNTH2_VC_LOW_REF_LSB) & SYNTH_SYNTH2_VC_LOW_REF_MASK)
+#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MSB        19
+#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB        15
+#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK       0x000f8000
+#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_GET(x)     (((x) & SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK) >> SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB)
+#define SYNTH_SYNTH2_LOOP_3RD_ORDER_R_SET(x)     (((x) << SYNTH_SYNTH2_LOOP_3RD_ORDER_R_LSB) & SYNTH_SYNTH2_LOOP_3RD_ORDER_R_MASK)
+#define SYNTH_SYNTH2_LOOP_CP_MSB                 14
+#define SYNTH_SYNTH2_LOOP_CP_LSB                 10
+#define SYNTH_SYNTH2_LOOP_CP_MASK                0x00007c00
+#define SYNTH_SYNTH2_LOOP_CP_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_CP_MASK) >> SYNTH_SYNTH2_LOOP_CP_LSB)
+#define SYNTH_SYNTH2_LOOP_CP_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_CP_LSB) & SYNTH_SYNTH2_LOOP_CP_MASK)
+#define SYNTH_SYNTH2_LOOP_RS_MSB                 9
+#define SYNTH_SYNTH2_LOOP_RS_LSB                 5
+#define SYNTH_SYNTH2_LOOP_RS_MASK                0x000003e0
+#define SYNTH_SYNTH2_LOOP_RS_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_RS_MASK) >> SYNTH_SYNTH2_LOOP_RS_LSB)
+#define SYNTH_SYNTH2_LOOP_RS_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_RS_LSB) & SYNTH_SYNTH2_LOOP_RS_MASK)
+#define SYNTH_SYNTH2_LOOP_CS_MSB                 4
+#define SYNTH_SYNTH2_LOOP_CS_LSB                 3
+#define SYNTH_SYNTH2_LOOP_CS_MASK                0x00000018
+#define SYNTH_SYNTH2_LOOP_CS_GET(x)              (((x) & SYNTH_SYNTH2_LOOP_CS_MASK) >> SYNTH_SYNTH2_LOOP_CS_LSB)
+#define SYNTH_SYNTH2_LOOP_CS_SET(x)              (((x) << SYNTH_SYNTH2_LOOP_CS_LSB) & SYNTH_SYNTH2_LOOP_CS_MASK)
+#define SYNTH_SYNTH2_SPARE_BITS_MSB              2
+#define SYNTH_SYNTH2_SPARE_BITS_LSB              0
+#define SYNTH_SYNTH2_SPARE_BITS_MASK             0x00000007
+#define SYNTH_SYNTH2_SPARE_BITS_GET(x)           (((x) & SYNTH_SYNTH2_SPARE_BITS_MASK) >> SYNTH_SYNTH2_SPARE_BITS_LSB)
+#define SYNTH_SYNTH2_SPARE_BITS_SET(x)           (((x) << SYNTH_SYNTH2_SPARE_BITS_LSB) & SYNTH_SYNTH2_SPARE_BITS_MASK)
+
+#define SYNTH_SYNTH3_ADDRESS                     0x00000008
+#define SYNTH_SYNTH3_OFFSET                      0x00000008
+#define SYNTH_SYNTH3_DIS_CLK_XTAL_MSB            31
+#define SYNTH_SYNTH3_DIS_CLK_XTAL_LSB            31
+#define SYNTH_SYNTH3_DIS_CLK_XTAL_MASK           0x80000000
+#define SYNTH_SYNTH3_DIS_CLK_XTAL_GET(x)         (((x) & SYNTH_SYNTH3_DIS_CLK_XTAL_MASK) >> SYNTH_SYNTH3_DIS_CLK_XTAL_LSB)
+#define SYNTH_SYNTH3_DIS_CLK_XTAL_SET(x)         (((x) << SYNTH_SYNTH3_DIS_CLK_XTAL_LSB) & SYNTH_SYNTH3_DIS_CLK_XTAL_MASK)
+#define SYNTH_SYNTH3_SEL_CLK_DIV2_MSB            30
+#define SYNTH_SYNTH3_SEL_CLK_DIV2_LSB            30
+#define SYNTH_SYNTH3_SEL_CLK_DIV2_MASK           0x40000000
+#define SYNTH_SYNTH3_SEL_CLK_DIV2_GET(x)         (((x) & SYNTH_SYNTH3_SEL_CLK_DIV2_MASK) >> SYNTH_SYNTH3_SEL_CLK_DIV2_LSB)
+#define SYNTH_SYNTH3_SEL_CLK_DIV2_SET(x)         (((x) << SYNTH_SYNTH3_SEL_CLK_DIV2_LSB) & SYNTH_SYNTH3_SEL_CLK_DIV2_MASK)
+#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MSB       29
+#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB       24
+#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK      0x3f000000
+#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_GET(x)    (((x) & SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK) >> SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB)
+#define SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_SET(x)    (((x) << SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_LSB) & SYNTH_SYNTH3_WAIT_SHORTR_PWRUP_MASK)
+#define SYNTH_SYNTH3_WAIT_PWRUP_MSB              23
+#define SYNTH_SYNTH3_WAIT_PWRUP_LSB              18
+#define SYNTH_SYNTH3_WAIT_PWRUP_MASK             0x00fc0000
+#define SYNTH_SYNTH3_WAIT_PWRUP_GET(x)           (((x) & SYNTH_SYNTH3_WAIT_PWRUP_MASK) >> SYNTH_SYNTH3_WAIT_PWRUP_LSB)
+#define SYNTH_SYNTH3_WAIT_PWRUP_SET(x)           (((x) << SYNTH_SYNTH3_WAIT_PWRUP_LSB) & SYNTH_SYNTH3_WAIT_PWRUP_MASK)
+#define SYNTH_SYNTH3_WAIT_CAL_BIN_MSB            17
+#define SYNTH_SYNTH3_WAIT_CAL_BIN_LSB            12
+#define SYNTH_SYNTH3_WAIT_CAL_BIN_MASK           0x0003f000
+#define SYNTH_SYNTH3_WAIT_CAL_BIN_GET(x)         (((x) & SYNTH_SYNTH3_WAIT_CAL_BIN_MASK) >> SYNTH_SYNTH3_WAIT_CAL_BIN_LSB)
+#define SYNTH_SYNTH3_WAIT_CAL_BIN_SET(x)         (((x) << SYNTH_SYNTH3_WAIT_CAL_BIN_LSB) & SYNTH_SYNTH3_WAIT_CAL_BIN_MASK)
+#define SYNTH_SYNTH3_WAIT_CAL_LIN_MSB            11
+#define SYNTH_SYNTH3_WAIT_CAL_LIN_LSB            6
+#define SYNTH_SYNTH3_WAIT_CAL_LIN_MASK           0x00000fc0
+#define SYNTH_SYNTH3_WAIT_CAL_LIN_GET(x)         (((x) & SYNTH_SYNTH3_WAIT_CAL_LIN_MASK) >> SYNTH_SYNTH3_WAIT_CAL_LIN_LSB)
+#define SYNTH_SYNTH3_WAIT_CAL_LIN_SET(x)         (((x) << SYNTH_SYNTH3_WAIT_CAL_LIN_LSB) & SYNTH_SYNTH3_WAIT_CAL_LIN_MASK)
+#define SYNTH_SYNTH3_WAIT_VC_CHECK_MSB           5
+#define SYNTH_SYNTH3_WAIT_VC_CHECK_LSB           0
+#define SYNTH_SYNTH3_WAIT_VC_CHECK_MASK          0x0000003f
+#define SYNTH_SYNTH3_WAIT_VC_CHECK_GET(x)        (((x) & SYNTH_SYNTH3_WAIT_VC_CHECK_MASK) >> SYNTH_SYNTH3_WAIT_VC_CHECK_LSB)
+#define SYNTH_SYNTH3_WAIT_VC_CHECK_SET(x)        (((x) << SYNTH_SYNTH3_WAIT_VC_CHECK_LSB) & SYNTH_SYNTH3_WAIT_VC_CHECK_MASK)
+
+#define SYNTH_SYNTH4_ADDRESS                     0x0000000c
+#define SYNTH_SYNTH4_OFFSET                      0x0000000c
+#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MSB       31
+#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB       31
+#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK      0x80000000
+#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_GET(x)    (((x) & SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK) >> SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB)
+#define SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_SET(x)    (((x) << SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_LSB) & SYNTH_SYNTH4_DIS_LIN_CAPSEARCH_MASK)
+#define SYNTH_SYNTH4_DIS_LOSTVC_MSB              30
+#define SYNTH_SYNTH4_DIS_LOSTVC_LSB              30
+#define SYNTH_SYNTH4_DIS_LOSTVC_MASK             0x40000000
+#define SYNTH_SYNTH4_DIS_LOSTVC_GET(x)           (((x) & SYNTH_SYNTH4_DIS_LOSTVC_MASK) >> SYNTH_SYNTH4_DIS_LOSTVC_LSB)
+#define SYNTH_SYNTH4_DIS_LOSTVC_SET(x)           (((x) << SYNTH_SYNTH4_DIS_LOSTVC_LSB) & SYNTH_SYNTH4_DIS_LOSTVC_MASK)
+#define SYNTH_SYNTH4_ALWAYS_SHORTR_MSB           29
+#define SYNTH_SYNTH4_ALWAYS_SHORTR_LSB           29
+#define SYNTH_SYNTH4_ALWAYS_SHORTR_MASK          0x20000000
+#define SYNTH_SYNTH4_ALWAYS_SHORTR_GET(x)        (((x) & SYNTH_SYNTH4_ALWAYS_SHORTR_MASK) >> SYNTH_SYNTH4_ALWAYS_SHORTR_LSB)
+#define SYNTH_SYNTH4_ALWAYS_SHORTR_SET(x)        (((x) << SYNTH_SYNTH4_ALWAYS_SHORTR_LSB) & SYNTH_SYNTH4_ALWAYS_SHORTR_MASK)
+#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MSB     28
+#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB     28
+#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK    0x10000000
+#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_GET(x)  (((x) & SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK) >> SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB)
+#define SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_SET(x)  (((x) << SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_LSB) & SYNTH_SYNTH4_SHORTR_UNTIL_LOCKED_MASK)
+#define SYNTH_SYNTH4_FORCE_PINVC_MSB             27
+#define SYNTH_SYNTH4_FORCE_PINVC_LSB             27
+#define SYNTH_SYNTH4_FORCE_PINVC_MASK            0x08000000
+#define SYNTH_SYNTH4_FORCE_PINVC_GET(x)          (((x) & SYNTH_SYNTH4_FORCE_PINVC_MASK) >> SYNTH_SYNTH4_FORCE_PINVC_LSB)
+#define SYNTH_SYNTH4_FORCE_PINVC_SET(x)          (((x) << SYNTH_SYNTH4_FORCE_PINVC_LSB) & SYNTH_SYNTH4_FORCE_PINVC_MASK)
+#define SYNTH_SYNTH4_FORCE_VCOCAP_MSB            26
+#define SYNTH_SYNTH4_FORCE_VCOCAP_LSB            26
+#define SYNTH_SYNTH4_FORCE_VCOCAP_MASK           0x04000000
+#define SYNTH_SYNTH4_FORCE_VCOCAP_GET(x)         (((x) & SYNTH_SYNTH4_FORCE_VCOCAP_MASK) >> SYNTH_SYNTH4_FORCE_VCOCAP_LSB)
+#define SYNTH_SYNTH4_FORCE_VCOCAP_SET(x)         (((x) << SYNTH_SYNTH4_FORCE_VCOCAP_LSB) & SYNTH_SYNTH4_FORCE_VCOCAP_MASK)
+#define SYNTH_SYNTH4_VCOCAP_OVR_MSB              25
+#define SYNTH_SYNTH4_VCOCAP_OVR_LSB              18
+#define SYNTH_SYNTH4_VCOCAP_OVR_MASK             0x03fc0000
+#define SYNTH_SYNTH4_VCOCAP_OVR_GET(x)           (((x) & SYNTH_SYNTH4_VCOCAP_OVR_MASK) >> SYNTH_SYNTH4_VCOCAP_OVR_LSB)
+#define SYNTH_SYNTH4_VCOCAP_OVR_SET(x)           (((x) << SYNTH_SYNTH4_VCOCAP_OVR_LSB) & SYNTH_SYNTH4_VCOCAP_OVR_MASK)
+#define SYNTH_SYNTH4_VCOCAPPULLUP_MSB            17
+#define SYNTH_SYNTH4_VCOCAPPULLUP_LSB            17
+#define SYNTH_SYNTH4_VCOCAPPULLUP_MASK           0x00020000
+#define SYNTH_SYNTH4_VCOCAPPULLUP_GET(x)         (((x) & SYNTH_SYNTH4_VCOCAPPULLUP_MASK) >> SYNTH_SYNTH4_VCOCAPPULLUP_LSB)
+#define SYNTH_SYNTH4_VCOCAPPULLUP_SET(x)         (((x) << SYNTH_SYNTH4_VCOCAPPULLUP_LSB) & SYNTH_SYNTH4_VCOCAPPULLUP_MASK)
+#define SYNTH_SYNTH4_REFDIVSEL_MSB               16
+#define SYNTH_SYNTH4_REFDIVSEL_LSB               15
+#define SYNTH_SYNTH4_REFDIVSEL_MASK              0x00018000
+#define SYNTH_SYNTH4_REFDIVSEL_GET(x)            (((x) & SYNTH_SYNTH4_REFDIVSEL_MASK) >> SYNTH_SYNTH4_REFDIVSEL_LSB)
+#define SYNTH_SYNTH4_REFDIVSEL_SET(x)            (((x) << SYNTH_SYNTH4_REFDIVSEL_LSB) & SYNTH_SYNTH4_REFDIVSEL_MASK)
+#define SYNTH_SYNTH4_PFDDELAY_MSB                14
+#define SYNTH_SYNTH4_PFDDELAY_LSB                14
+#define SYNTH_SYNTH4_PFDDELAY_MASK               0x00004000
+#define SYNTH_SYNTH4_PFDDELAY_GET(x)             (((x) & SYNTH_SYNTH4_PFDDELAY_MASK) >> SYNTH_SYNTH4_PFDDELAY_LSB)
+#define SYNTH_SYNTH4_PFDDELAY_SET(x)             (((x) << SYNTH_SYNTH4_PFDDELAY_LSB) & SYNTH_SYNTH4_PFDDELAY_MASK)
+#define SYNTH_SYNTH4_PFD_DISABLE_MSB             13
+#define SYNTH_SYNTH4_PFD_DISABLE_LSB             13
+#define SYNTH_SYNTH4_PFD_DISABLE_MASK            0x00002000
+#define SYNTH_SYNTH4_PFD_DISABLE_GET(x)          (((x) & SYNTH_SYNTH4_PFD_DISABLE_MASK) >> SYNTH_SYNTH4_PFD_DISABLE_LSB)
+#define SYNTH_SYNTH4_PFD_DISABLE_SET(x)          (((x) << SYNTH_SYNTH4_PFD_DISABLE_LSB) & SYNTH_SYNTH4_PFD_DISABLE_MASK)
+#define SYNTH_SYNTH4_PRESCSEL_MSB                12
+#define SYNTH_SYNTH4_PRESCSEL_LSB                11
+#define SYNTH_SYNTH4_PRESCSEL_MASK               0x00001800
+#define SYNTH_SYNTH4_PRESCSEL_GET(x)             (((x) & SYNTH_SYNTH4_PRESCSEL_MASK) >> SYNTH_SYNTH4_PRESCSEL_LSB)
+#define SYNTH_SYNTH4_PRESCSEL_SET(x)             (((x) << SYNTH_SYNTH4_PRESCSEL_LSB) & SYNTH_SYNTH4_PRESCSEL_MASK)
+#define SYNTH_SYNTH4_RESET_PRESC_MSB             10
+#define SYNTH_SYNTH4_RESET_PRESC_LSB             10
+#define SYNTH_SYNTH4_RESET_PRESC_MASK            0x00000400
+#define SYNTH_SYNTH4_RESET_PRESC_GET(x)          (((x) & SYNTH_SYNTH4_RESET_PRESC_MASK) >> SYNTH_SYNTH4_RESET_PRESC_LSB)
+#define SYNTH_SYNTH4_RESET_PRESC_SET(x)          (((x) << SYNTH_SYNTH4_RESET_PRESC_LSB) & SYNTH_SYNTH4_RESET_PRESC_MASK)
+#define SYNTH_SYNTH4_SDM_DISABLE_MSB             9
+#define SYNTH_SYNTH4_SDM_DISABLE_LSB             9
+#define SYNTH_SYNTH4_SDM_DISABLE_MASK            0x00000200
+#define SYNTH_SYNTH4_SDM_DISABLE_GET(x)          (((x) & SYNTH_SYNTH4_SDM_DISABLE_MASK) >> SYNTH_SYNTH4_SDM_DISABLE_LSB)
+#define SYNTH_SYNTH4_SDM_DISABLE_SET(x)          (((x) << SYNTH_SYNTH4_SDM_DISABLE_LSB) & SYNTH_SYNTH4_SDM_DISABLE_MASK)
+#define SYNTH_SYNTH4_SDM_MODE_MSB                8
+#define SYNTH_SYNTH4_SDM_MODE_LSB                8
+#define SYNTH_SYNTH4_SDM_MODE_MASK               0x00000100
+#define SYNTH_SYNTH4_SDM_MODE_GET(x)             (((x) & SYNTH_SYNTH4_SDM_MODE_MASK) >> SYNTH_SYNTH4_SDM_MODE_LSB)
+#define SYNTH_SYNTH4_SDM_MODE_SET(x)             (((x) << SYNTH_SYNTH4_SDM_MODE_LSB) & SYNTH_SYNTH4_SDM_MODE_MASK)
+#define SYNTH_SYNTH4_SDM_DITHER_MSB              7
+#define SYNTH_SYNTH4_SDM_DITHER_LSB              6
+#define SYNTH_SYNTH4_SDM_DITHER_MASK             0x000000c0
+#define SYNTH_SYNTH4_SDM_DITHER_GET(x)           (((x) & SYNTH_SYNTH4_SDM_DITHER_MASK) >> SYNTH_SYNTH4_SDM_DITHER_LSB)
+#define SYNTH_SYNTH4_SDM_DITHER_SET(x)           (((x) << SYNTH_SYNTH4_SDM_DITHER_LSB) & SYNTH_SYNTH4_SDM_DITHER_MASK)
+#define SYNTH_SYNTH4_PSCOUNT_FBSEL_MSB           5
+#define SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB           5
+#define SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK          0x00000020
+#define SYNTH_SYNTH4_PSCOUNT_FBSEL_GET(x)        (((x) & SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK) >> SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB)
+#define SYNTH_SYNTH4_PSCOUNT_FBSEL_SET(x)        (((x) << SYNTH_SYNTH4_PSCOUNT_FBSEL_LSB) & SYNTH_SYNTH4_PSCOUNT_FBSEL_MASK)
+#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MSB        4
+#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB        4
+#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK       0x00000010
+#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_GET(x)     (((x) & SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK) >> SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB)
+#define SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_SET(x)     (((x) << SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_LSB) & SYNTH_SYNTH4_SEL_CLKXTAL_EDGE_MASK)
+#define SYNTH_SYNTH4_SPARE_MISC_MSB              3
+#define SYNTH_SYNTH4_SPARE_MISC_LSB              2
+#define SYNTH_SYNTH4_SPARE_MISC_MASK             0x0000000c
+#define SYNTH_SYNTH4_SPARE_MISC_GET(x)           (((x) & SYNTH_SYNTH4_SPARE_MISC_MASK) >> SYNTH_SYNTH4_SPARE_MISC_LSB)
+#define SYNTH_SYNTH4_SPARE_MISC_SET(x)           (((x) << SYNTH_SYNTH4_SPARE_MISC_LSB) & SYNTH_SYNTH4_SPARE_MISC_MASK)
+#define SYNTH_SYNTH4_LONGSHIFTSEL_MSB            1
+#define SYNTH_SYNTH4_LONGSHIFTSEL_LSB            1
+#define SYNTH_SYNTH4_LONGSHIFTSEL_MASK           0x00000002
+#define SYNTH_SYNTH4_LONGSHIFTSEL_GET(x)         (((x) & SYNTH_SYNTH4_LONGSHIFTSEL_MASK) >> SYNTH_SYNTH4_LONGSHIFTSEL_LSB)
+#define SYNTH_SYNTH4_LONGSHIFTSEL_SET(x)         (((x) << SYNTH_SYNTH4_LONGSHIFTSEL_LSB) & SYNTH_SYNTH4_LONGSHIFTSEL_MASK)
+#define SYNTH_SYNTH4_FORCE_SHIFTREG_MSB          0
+#define SYNTH_SYNTH4_FORCE_SHIFTREG_LSB          0
+#define SYNTH_SYNTH4_FORCE_SHIFTREG_MASK         0x00000001
+#define SYNTH_SYNTH4_FORCE_SHIFTREG_GET(x)       (((x) & SYNTH_SYNTH4_FORCE_SHIFTREG_MASK) >> SYNTH_SYNTH4_FORCE_SHIFTREG_LSB)
+#define SYNTH_SYNTH4_FORCE_SHIFTREG_SET(x)       (((x) << SYNTH_SYNTH4_FORCE_SHIFTREG_LSB) & SYNTH_SYNTH4_FORCE_SHIFTREG_MASK)
+
+#define SYNTH_SYNTH5_ADDRESS                     0x00000010
+#define SYNTH_SYNTH5_OFFSET                      0x00000010
+#define SYNTH_SYNTH5_LOOP_IP0_MSB                31
+#define SYNTH_SYNTH5_LOOP_IP0_LSB                28
+#define SYNTH_SYNTH5_LOOP_IP0_MASK               0xf0000000
+#define SYNTH_SYNTH5_LOOP_IP0_GET(x)             (((x) & SYNTH_SYNTH5_LOOP_IP0_MASK) >> SYNTH_SYNTH5_LOOP_IP0_LSB)
+#define SYNTH_SYNTH5_LOOP_IP0_SET(x)             (((x) << SYNTH_SYNTH5_LOOP_IP0_LSB) & SYNTH_SYNTH5_LOOP_IP0_MASK)
+#define SYNTH_SYNTH5_SLOPE_IP_MSB                27
+#define SYNTH_SYNTH5_SLOPE_IP_LSB                25
+#define SYNTH_SYNTH5_SLOPE_IP_MASK               0x0e000000
+#define SYNTH_SYNTH5_SLOPE_IP_GET(x)             (((x) & SYNTH_SYNTH5_SLOPE_IP_MASK) >> SYNTH_SYNTH5_SLOPE_IP_LSB)
+#define SYNTH_SYNTH5_SLOPE_IP_SET(x)             (((x) << SYNTH_SYNTH5_SLOPE_IP_LSB) & SYNTH_SYNTH5_SLOPE_IP_MASK)
+#define SYNTH_SYNTH5_CPBIAS_MSB                  24
+#define SYNTH_SYNTH5_CPBIAS_LSB                  23
+#define SYNTH_SYNTH5_CPBIAS_MASK                 0x01800000
+#define SYNTH_SYNTH5_CPBIAS_GET(x)               (((x) & SYNTH_SYNTH5_CPBIAS_MASK) >> SYNTH_SYNTH5_CPBIAS_LSB)
+#define SYNTH_SYNTH5_CPBIAS_SET(x)               (((x) << SYNTH_SYNTH5_CPBIAS_LSB) & SYNTH_SYNTH5_CPBIAS_MASK)
+#define SYNTH_SYNTH5_CPSTEERING_EN_MSB           22
+#define SYNTH_SYNTH5_CPSTEERING_EN_LSB           22
+#define SYNTH_SYNTH5_CPSTEERING_EN_MASK          0x00400000
+#define SYNTH_SYNTH5_CPSTEERING_EN_GET(x)        (((x) & SYNTH_SYNTH5_CPSTEERING_EN_MASK) >> SYNTH_SYNTH5_CPSTEERING_EN_LSB)
+#define SYNTH_SYNTH5_CPSTEERING_EN_SET(x)        (((x) << SYNTH_SYNTH5_CPSTEERING_EN_LSB) & SYNTH_SYNTH5_CPSTEERING_EN_MASK)
+#define SYNTH_SYNTH5_CPLOWLK_MSB                 21
+#define SYNTH_SYNTH5_CPLOWLK_LSB                 21
+#define SYNTH_SYNTH5_CPLOWLK_MASK                0x00200000
+#define SYNTH_SYNTH5_CPLOWLK_GET(x)              (((x) & SYNTH_SYNTH5_CPLOWLK_MASK) >> SYNTH_SYNTH5_CPLOWLK_LSB)
+#define SYNTH_SYNTH5_CPLOWLK_SET(x)              (((x) << SYNTH_SYNTH5_CPLOWLK_LSB) & SYNTH_SYNTH5_CPLOWLK_MASK)
+#define SYNTH_SYNTH5_LOOPLEAKCUR_MSB             20
+#define SYNTH_SYNTH5_LOOPLEAKCUR_LSB             17
+#define SYNTH_SYNTH5_LOOPLEAKCUR_MASK            0x001e0000
+#define SYNTH_SYNTH5_LOOPLEAKCUR_GET(x)          (((x) & SYNTH_SYNTH5_LOOPLEAKCUR_MASK) >> SYNTH_SYNTH5_LOOPLEAKCUR_LSB)
+#define SYNTH_SYNTH5_LOOPLEAKCUR_SET(x)          (((x) << SYNTH_SYNTH5_LOOPLEAKCUR_LSB) & SYNTH_SYNTH5_LOOPLEAKCUR_MASK)
+#define SYNTH_SYNTH5_CAPRANGE1_MSB               16
+#define SYNTH_SYNTH5_CAPRANGE1_LSB               13
+#define SYNTH_SYNTH5_CAPRANGE1_MASK              0x0001e000
+#define SYNTH_SYNTH5_CAPRANGE1_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE1_MASK) >> SYNTH_SYNTH5_CAPRANGE1_LSB)
+#define SYNTH_SYNTH5_CAPRANGE1_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE1_LSB) & SYNTH_SYNTH5_CAPRANGE1_MASK)
+#define SYNTH_SYNTH5_CAPRANGE2_MSB               12
+#define SYNTH_SYNTH5_CAPRANGE2_LSB               9
+#define SYNTH_SYNTH5_CAPRANGE2_MASK              0x00001e00
+#define SYNTH_SYNTH5_CAPRANGE2_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE2_MASK) >> SYNTH_SYNTH5_CAPRANGE2_LSB)
+#define SYNTH_SYNTH5_CAPRANGE2_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE2_LSB) & SYNTH_SYNTH5_CAPRANGE2_MASK)
+#define SYNTH_SYNTH5_CAPRANGE3_MSB               8
+#define SYNTH_SYNTH5_CAPRANGE3_LSB               5
+#define SYNTH_SYNTH5_CAPRANGE3_MASK              0x000001e0
+#define SYNTH_SYNTH5_CAPRANGE3_GET(x)            (((x) & SYNTH_SYNTH5_CAPRANGE3_MASK) >> SYNTH_SYNTH5_CAPRANGE3_LSB)
+#define SYNTH_SYNTH5_CAPRANGE3_SET(x)            (((x) << SYNTH_SYNTH5_CAPRANGE3_LSB) & SYNTH_SYNTH5_CAPRANGE3_MASK)
+#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MSB       4
+#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB       4
+#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK      0x00000010
+#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_GET(x)    (((x) & SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK) >> SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB)
+#define SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_SET(x)    (((x) << SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_LSB) & SYNTH_SYNTH5_FORCE_LOBUF5GTUNE_MASK)
+#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MSB         3
+#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB         2
+#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK        0x0000000c
+#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_GET(x)      (((x) & SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK) >> SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB)
+#define SYNTH_SYNTH5_LOBUF5GTUNE_OVR_SET(x)      (((x) << SYNTH_SYNTH5_LOBUF5GTUNE_OVR_LSB) & SYNTH_SYNTH5_LOBUF5GTUNE_OVR_MASK)
+#define SYNTH_SYNTH5_SPARE_MSB                   1
+#define SYNTH_SYNTH5_SPARE_LSB                   0
+#define SYNTH_SYNTH5_SPARE_MASK                  0x00000003
+#define SYNTH_SYNTH5_SPARE_GET(x)                (((x) & SYNTH_SYNTH5_SPARE_MASK) >> SYNTH_SYNTH5_SPARE_LSB)
+#define SYNTH_SYNTH5_SPARE_SET(x)                (((x) << SYNTH_SYNTH5_SPARE_LSB) & SYNTH_SYNTH5_SPARE_MASK)
+
+#define SYNTH_SYNTH6_ADDRESS                     0x00000014
+#define SYNTH_SYNTH6_OFFSET                      0x00000014
+#define SYNTH_SYNTH6_IRCP_MSB                    31
+#define SYNTH_SYNTH6_IRCP_LSB                    29
+#define SYNTH_SYNTH6_IRCP_MASK                   0xe0000000
+#define SYNTH_SYNTH6_IRCP_GET(x)                 (((x) & SYNTH_SYNTH6_IRCP_MASK) >> SYNTH_SYNTH6_IRCP_LSB)
+#define SYNTH_SYNTH6_IRCP_SET(x)                 (((x) << SYNTH_SYNTH6_IRCP_LSB) & SYNTH_SYNTH6_IRCP_MASK)
+#define SYNTH_SYNTH6_IRVCMON_MSB                 28
+#define SYNTH_SYNTH6_IRVCMON_LSB                 26
+#define SYNTH_SYNTH6_IRVCMON_MASK                0x1c000000
+#define SYNTH_SYNTH6_IRVCMON_GET(x)              (((x) & SYNTH_SYNTH6_IRVCMON_MASK) >> SYNTH_SYNTH6_IRVCMON_LSB)
+#define SYNTH_SYNTH6_IRVCMON_SET(x)              (((x) << SYNTH_SYNTH6_IRVCMON_LSB) & SYNTH_SYNTH6_IRVCMON_MASK)
+#define SYNTH_SYNTH6_IRSPARE_MSB                 25
+#define SYNTH_SYNTH6_IRSPARE_LSB                 23
+#define SYNTH_SYNTH6_IRSPARE_MASK                0x03800000
+#define SYNTH_SYNTH6_IRSPARE_GET(x)              (((x) & SYNTH_SYNTH6_IRSPARE_MASK) >> SYNTH_SYNTH6_IRSPARE_LSB)
+#define SYNTH_SYNTH6_IRSPARE_SET(x)              (((x) << SYNTH_SYNTH6_IRSPARE_LSB) & SYNTH_SYNTH6_IRSPARE_MASK)
+#define SYNTH_SYNTH6_ICPRESC_MSB                 22
+#define SYNTH_SYNTH6_ICPRESC_LSB                 20
+#define SYNTH_SYNTH6_ICPRESC_MASK                0x00700000
+#define SYNTH_SYNTH6_ICPRESC_GET(x)              (((x) & SYNTH_SYNTH6_ICPRESC_MASK) >> SYNTH_SYNTH6_ICPRESC_LSB)
+#define SYNTH_SYNTH6_ICPRESC_SET(x)              (((x) << SYNTH_SYNTH6_ICPRESC_LSB) & SYNTH_SYNTH6_ICPRESC_MASK)
+#define SYNTH_SYNTH6_ICLODIV_MSB                 19
+#define SYNTH_SYNTH6_ICLODIV_LSB                 17
+#define SYNTH_SYNTH6_ICLODIV_MASK                0x000e0000
+#define SYNTH_SYNTH6_ICLODIV_GET(x)              (((x) & SYNTH_SYNTH6_ICLODIV_MASK) >> SYNTH_SYNTH6_ICLODIV_LSB)
+#define SYNTH_SYNTH6_ICLODIV_SET(x)              (((x) << SYNTH_SYNTH6_ICLODIV_LSB) & SYNTH_SYNTH6_ICLODIV_MASK)
+#define SYNTH_SYNTH6_ICLOMIX_MSB                 16
+#define SYNTH_SYNTH6_ICLOMIX_LSB                 14
+#define SYNTH_SYNTH6_ICLOMIX_MASK                0x0001c000
+#define SYNTH_SYNTH6_ICLOMIX_GET(x)              (((x) & SYNTH_SYNTH6_ICLOMIX_MASK) >> SYNTH_SYNTH6_ICLOMIX_LSB)
+#define SYNTH_SYNTH6_ICLOMIX_SET(x)              (((x) << SYNTH_SYNTH6_ICLOMIX_LSB) & SYNTH_SYNTH6_ICLOMIX_MASK)
+#define SYNTH_SYNTH6_ICSPAREA_MSB                13
+#define SYNTH_SYNTH6_ICSPAREA_LSB                11
+#define SYNTH_SYNTH6_ICSPAREA_MASK               0x00003800
+#define SYNTH_SYNTH6_ICSPAREA_GET(x)             (((x) & SYNTH_SYNTH6_ICSPAREA_MASK) >> SYNTH_SYNTH6_ICSPAREA_LSB)
+#define SYNTH_SYNTH6_ICSPAREA_SET(x)             (((x) << SYNTH_SYNTH6_ICSPAREA_LSB) & SYNTH_SYNTH6_ICSPAREA_MASK)
+#define SYNTH_SYNTH6_ICSPAREB_MSB                10
+#define SYNTH_SYNTH6_ICSPAREB_LSB                8
+#define SYNTH_SYNTH6_ICSPAREB_MASK               0x00000700
+#define SYNTH_SYNTH6_ICSPAREB_GET(x)             (((x) & SYNTH_SYNTH6_ICSPAREB_MASK) >> SYNTH_SYNTH6_ICSPAREB_LSB)
+#define SYNTH_SYNTH6_ICSPAREB_SET(x)             (((x) << SYNTH_SYNTH6_ICSPAREB_LSB) & SYNTH_SYNTH6_ICSPAREB_MASK)
+#define SYNTH_SYNTH6_ICVCO_MSB                   7
+#define SYNTH_SYNTH6_ICVCO_LSB                   5
+#define SYNTH_SYNTH6_ICVCO_MASK                  0x000000e0
+#define SYNTH_SYNTH6_ICVCO_GET(x)                (((x) & SYNTH_SYNTH6_ICVCO_MASK) >> SYNTH_SYNTH6_ICVCO_LSB)
+#define SYNTH_SYNTH6_ICVCO_SET(x)                (((x) << SYNTH_SYNTH6_ICVCO_LSB) & SYNTH_SYNTH6_ICVCO_MASK)
+#define SYNTH_SYNTH6_VCOBUFBIAS_MSB              4
+#define SYNTH_SYNTH6_VCOBUFBIAS_LSB              3
+#define SYNTH_SYNTH6_VCOBUFBIAS_MASK             0x00000018
+#define SYNTH_SYNTH6_VCOBUFBIAS_GET(x)           (((x) & SYNTH_SYNTH6_VCOBUFBIAS_MASK) >> SYNTH_SYNTH6_VCOBUFBIAS_LSB)
+#define SYNTH_SYNTH6_VCOBUFBIAS_SET(x)           (((x) << SYNTH_SYNTH6_VCOBUFBIAS_LSB) & SYNTH_SYNTH6_VCOBUFBIAS_MASK)
+#define SYNTH_SYNTH6_SPARE_BIAS_MSB              2
+#define SYNTH_SYNTH6_SPARE_BIAS_LSB              0
+#define SYNTH_SYNTH6_SPARE_BIAS_MASK             0x00000007
+#define SYNTH_SYNTH6_SPARE_BIAS_GET(x)           (((x) & SYNTH_SYNTH6_SPARE_BIAS_MASK) >> SYNTH_SYNTH6_SPARE_BIAS_LSB)
+#define SYNTH_SYNTH6_SPARE_BIAS_SET(x)           (((x) << SYNTH_SYNTH6_SPARE_BIAS_LSB) & SYNTH_SYNTH6_SPARE_BIAS_MASK)
+
+#define SYNTH_SYNTH7_ADDRESS                     0x00000018
+#define SYNTH_SYNTH7_OFFSET                      0x00000018
+#define SYNTH_SYNTH7_SYNTH_ON_MSB                31
+#define SYNTH_SYNTH7_SYNTH_ON_LSB                31
+#define SYNTH_SYNTH7_SYNTH_ON_MASK               0x80000000
+#define SYNTH_SYNTH7_SYNTH_ON_GET(x)             (((x) & SYNTH_SYNTH7_SYNTH_ON_MASK) >> SYNTH_SYNTH7_SYNTH_ON_LSB)
+#define SYNTH_SYNTH7_SYNTH_ON_SET(x)             (((x) << SYNTH_SYNTH7_SYNTH_ON_LSB) & SYNTH_SYNTH7_SYNTH_ON_MASK)
+#define SYNTH_SYNTH7_SYNTH_SM_STATE_MSB          30
+#define SYNTH_SYNTH7_SYNTH_SM_STATE_LSB          27
+#define SYNTH_SYNTH7_SYNTH_SM_STATE_MASK         0x78000000
+#define SYNTH_SYNTH7_SYNTH_SM_STATE_GET(x)       (((x) & SYNTH_SYNTH7_SYNTH_SM_STATE_MASK) >> SYNTH_SYNTH7_SYNTH_SM_STATE_LSB)
+#define SYNTH_SYNTH7_SYNTH_SM_STATE_SET(x)       (((x) << SYNTH_SYNTH7_SYNTH_SM_STATE_LSB) & SYNTH_SYNTH7_SYNTH_SM_STATE_MASK)
+#define SYNTH_SYNTH7_CAP_SEARCH_MSB              26
+#define SYNTH_SYNTH7_CAP_SEARCH_LSB              26
+#define SYNTH_SYNTH7_CAP_SEARCH_MASK             0x04000000
+#define SYNTH_SYNTH7_CAP_SEARCH_GET(x)           (((x) & SYNTH_SYNTH7_CAP_SEARCH_MASK) >> SYNTH_SYNTH7_CAP_SEARCH_LSB)
+#define SYNTH_SYNTH7_CAP_SEARCH_SET(x)           (((x) << SYNTH_SYNTH7_CAP_SEARCH_LSB) & SYNTH_SYNTH7_CAP_SEARCH_MASK)
+#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MSB        25
+#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB        25
+#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK       0x02000000
+#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_GET(x)     (((x) & SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK) >> SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB)
+#define SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_SET(x)     (((x) << SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_LSB) & SYNTH_SYNTH7_SYNTH_LOCK_VC_OK_MASK)
+#define SYNTH_SYNTH7_PIN_VC_MSB                  24
+#define SYNTH_SYNTH7_PIN_VC_LSB                  24
+#define SYNTH_SYNTH7_PIN_VC_MASK                 0x01000000
+#define SYNTH_SYNTH7_PIN_VC_GET(x)               (((x) & SYNTH_SYNTH7_PIN_VC_MASK) >> SYNTH_SYNTH7_PIN_VC_LSB)
+#define SYNTH_SYNTH7_PIN_VC_SET(x)               (((x) << SYNTH_SYNTH7_PIN_VC_LSB) & SYNTH_SYNTH7_PIN_VC_MASK)
+#define SYNTH_SYNTH7_VCO_CAP_ST_MSB              23
+#define SYNTH_SYNTH7_VCO_CAP_ST_LSB              16
+#define SYNTH_SYNTH7_VCO_CAP_ST_MASK             0x00ff0000
+#define SYNTH_SYNTH7_VCO_CAP_ST_GET(x)           (((x) & SYNTH_SYNTH7_VCO_CAP_ST_MASK) >> SYNTH_SYNTH7_VCO_CAP_ST_LSB)
+#define SYNTH_SYNTH7_VCO_CAP_ST_SET(x)           (((x) << SYNTH_SYNTH7_VCO_CAP_ST_LSB) & SYNTH_SYNTH7_VCO_CAP_ST_MASK)
+#define SYNTH_SYNTH7_SHORT_R_MSB                 15
+#define SYNTH_SYNTH7_SHORT_R_LSB                 15
+#define SYNTH_SYNTH7_SHORT_R_MASK                0x00008000
+#define SYNTH_SYNTH7_SHORT_R_GET(x)              (((x) & SYNTH_SYNTH7_SHORT_R_MASK) >> SYNTH_SYNTH7_SHORT_R_LSB)
+#define SYNTH_SYNTH7_SHORT_R_SET(x)              (((x) << SYNTH_SYNTH7_SHORT_R_LSB) & SYNTH_SYNTH7_SHORT_R_MASK)
+#define SYNTH_SYNTH7_RESET_RFD_MSB               14
+#define SYNTH_SYNTH7_RESET_RFD_LSB               14
+#define SYNTH_SYNTH7_RESET_RFD_MASK              0x00004000
+#define SYNTH_SYNTH7_RESET_RFD_GET(x)            (((x) & SYNTH_SYNTH7_RESET_RFD_MASK) >> SYNTH_SYNTH7_RESET_RFD_LSB)
+#define SYNTH_SYNTH7_RESET_RFD_SET(x)            (((x) << SYNTH_SYNTH7_RESET_RFD_LSB) & SYNTH_SYNTH7_RESET_RFD_MASK)
+#define SYNTH_SYNTH7_RESET_PFD_MSB               13
+#define SYNTH_SYNTH7_RESET_PFD_LSB               13
+#define SYNTH_SYNTH7_RESET_PFD_MASK              0x00002000
+#define SYNTH_SYNTH7_RESET_PFD_GET(x)            (((x) & SYNTH_SYNTH7_RESET_PFD_MASK) >> SYNTH_SYNTH7_RESET_PFD_LSB)
+#define SYNTH_SYNTH7_RESET_PFD_SET(x)            (((x) << SYNTH_SYNTH7_RESET_PFD_LSB) & SYNTH_SYNTH7_RESET_PFD_MASK)
+#define SYNTH_SYNTH7_RESET_PSCOUNTERS_MSB        12
+#define SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB        12
+#define SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK       0x00001000
+#define SYNTH_SYNTH7_RESET_PSCOUNTERS_GET(x)     (((x) & SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK) >> SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB)
+#define SYNTH_SYNTH7_RESET_PSCOUNTERS_SET(x)     (((x) << SYNTH_SYNTH7_RESET_PSCOUNTERS_LSB) & SYNTH_SYNTH7_RESET_PSCOUNTERS_MASK)
+#define SYNTH_SYNTH7_RESET_SDM_B_MSB             11
+#define SYNTH_SYNTH7_RESET_SDM_B_LSB             11
+#define SYNTH_SYNTH7_RESET_SDM_B_MASK            0x00000800
+#define SYNTH_SYNTH7_RESET_SDM_B_GET(x)          (((x) & SYNTH_SYNTH7_RESET_SDM_B_MASK) >> SYNTH_SYNTH7_RESET_SDM_B_LSB)
+#define SYNTH_SYNTH7_RESET_SDM_B_SET(x)          (((x) << SYNTH_SYNTH7_RESET_SDM_B_LSB) & SYNTH_SYNTH7_RESET_SDM_B_MASK)
+#define SYNTH_SYNTH7_VC2HIGH_MSB                 10
+#define SYNTH_SYNTH7_VC2HIGH_LSB                 10
+#define SYNTH_SYNTH7_VC2HIGH_MASK                0x00000400
+#define SYNTH_SYNTH7_VC2HIGH_GET(x)              (((x) & SYNTH_SYNTH7_VC2HIGH_MASK) >> SYNTH_SYNTH7_VC2HIGH_LSB)
+#define SYNTH_SYNTH7_VC2HIGH_SET(x)              (((x) << SYNTH_SYNTH7_VC2HIGH_LSB) & SYNTH_SYNTH7_VC2HIGH_MASK)
+#define SYNTH_SYNTH7_VC2LOW_MSB                  9
+#define SYNTH_SYNTH7_VC2LOW_LSB                  9
+#define SYNTH_SYNTH7_VC2LOW_MASK                 0x00000200
+#define SYNTH_SYNTH7_VC2LOW_GET(x)               (((x) & SYNTH_SYNTH7_VC2LOW_MASK) >> SYNTH_SYNTH7_VC2LOW_LSB)
+#define SYNTH_SYNTH7_VC2LOW_SET(x)               (((x) << SYNTH_SYNTH7_VC2LOW_LSB) & SYNTH_SYNTH7_VC2LOW_MASK)
+#define SYNTH_SYNTH7_LOOP_IP_MSB                 8
+#define SYNTH_SYNTH7_LOOP_IP_LSB                 5
+#define SYNTH_SYNTH7_LOOP_IP_MASK                0x000001e0
+#define SYNTH_SYNTH7_LOOP_IP_GET(x)              (((x) & SYNTH_SYNTH7_LOOP_IP_MASK) >> SYNTH_SYNTH7_LOOP_IP_LSB)
+#define SYNTH_SYNTH7_LOOP_IP_SET(x)              (((x) << SYNTH_SYNTH7_LOOP_IP_LSB) & SYNTH_SYNTH7_LOOP_IP_MASK)
+#define SYNTH_SYNTH7_LOBUF5GTUNE_MSB             4
+#define SYNTH_SYNTH7_LOBUF5GTUNE_LSB             3
+#define SYNTH_SYNTH7_LOBUF5GTUNE_MASK            0x00000018
+#define SYNTH_SYNTH7_LOBUF5GTUNE_GET(x)          (((x) & SYNTH_SYNTH7_LOBUF5GTUNE_MASK) >> SYNTH_SYNTH7_LOBUF5GTUNE_LSB)
+#define SYNTH_SYNTH7_LOBUF5GTUNE_SET(x)          (((x) << SYNTH_SYNTH7_LOBUF5GTUNE_LSB) & SYNTH_SYNTH7_LOBUF5GTUNE_MASK)
+#define SYNTH_SYNTH7_SPARE_READ_MSB              2
+#define SYNTH_SYNTH7_SPARE_READ_LSB              0
+#define SYNTH_SYNTH7_SPARE_READ_MASK             0x00000007
+#define SYNTH_SYNTH7_SPARE_READ_GET(x)           (((x) & SYNTH_SYNTH7_SPARE_READ_MASK) >> SYNTH_SYNTH7_SPARE_READ_LSB)
+#define SYNTH_SYNTH7_SPARE_READ_SET(x)           (((x) << SYNTH_SYNTH7_SPARE_READ_LSB) & SYNTH_SYNTH7_SPARE_READ_MASK)
+
+#define SYNTH_SYNTH8_ADDRESS                     0x0000001c
+#define SYNTH_SYNTH8_OFFSET                      0x0000001c
+#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_MSB        31
+#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB        31
+#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK       0x80000000
+#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_GET(x)     (((x) & SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK) >> SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB)
+#define SYNTH_SYNTH8_LOADSYNTHCHANNEL_SET(x)     (((x) << SYNTH_SYNTH8_LOADSYNTHCHANNEL_LSB) & SYNTH_SYNTH8_LOADSYNTHCHANNEL_MASK)
+#define SYNTH_SYNTH8_FRACMODE_MSB                30
+#define SYNTH_SYNTH8_FRACMODE_LSB                30
+#define SYNTH_SYNTH8_FRACMODE_MASK               0x40000000
+#define SYNTH_SYNTH8_FRACMODE_GET(x)             (((x) & SYNTH_SYNTH8_FRACMODE_MASK) >> SYNTH_SYNTH8_FRACMODE_LSB)
+#define SYNTH_SYNTH8_FRACMODE_SET(x)             (((x) << SYNTH_SYNTH8_FRACMODE_LSB) & SYNTH_SYNTH8_FRACMODE_MASK)
+#define SYNTH_SYNTH8_AMODEREFSEL_MSB             29
+#define SYNTH_SYNTH8_AMODEREFSEL_LSB             28
+#define SYNTH_SYNTH8_AMODEREFSEL_MASK            0x30000000
+#define SYNTH_SYNTH8_AMODEREFSEL_GET(x)          (((x) & SYNTH_SYNTH8_AMODEREFSEL_MASK) >> SYNTH_SYNTH8_AMODEREFSEL_LSB)
+#define SYNTH_SYNTH8_AMODEREFSEL_SET(x)          (((x) << SYNTH_SYNTH8_AMODEREFSEL_LSB) & SYNTH_SYNTH8_AMODEREFSEL_MASK)
+#define SYNTH_SYNTH8_SPARE_MSB                   27
+#define SYNTH_SYNTH8_SPARE_LSB                   27
+#define SYNTH_SYNTH8_SPARE_MASK                  0x08000000
+#define SYNTH_SYNTH8_SPARE_GET(x)                (((x) & SYNTH_SYNTH8_SPARE_MASK) >> SYNTH_SYNTH8_SPARE_LSB)
+#define SYNTH_SYNTH8_SPARE_SET(x)                (((x) << SYNTH_SYNTH8_SPARE_LSB) & SYNTH_SYNTH8_SPARE_MASK)
+#define SYNTH_SYNTH8_CHANSEL_MSB                 26
+#define SYNTH_SYNTH8_CHANSEL_LSB                 18
+#define SYNTH_SYNTH8_CHANSEL_MASK                0x07fc0000
+#define SYNTH_SYNTH8_CHANSEL_GET(x)              (((x) & SYNTH_SYNTH8_CHANSEL_MASK) >> SYNTH_SYNTH8_CHANSEL_LSB)
+#define SYNTH_SYNTH8_CHANSEL_SET(x)              (((x) << SYNTH_SYNTH8_CHANSEL_LSB) & SYNTH_SYNTH8_CHANSEL_MASK)
+#define SYNTH_SYNTH8_CHANFRAC_MSB                17
+#define SYNTH_SYNTH8_CHANFRAC_LSB                1
+#define SYNTH_SYNTH8_CHANFRAC_MASK               0x0003fffe
+#define SYNTH_SYNTH8_CHANFRAC_GET(x)             (((x) & SYNTH_SYNTH8_CHANFRAC_MASK) >> SYNTH_SYNTH8_CHANFRAC_LSB)
+#define SYNTH_SYNTH8_CHANFRAC_SET(x)             (((x) << SYNTH_SYNTH8_CHANFRAC_LSB) & SYNTH_SYNTH8_CHANFRAC_MASK)
+#define SYNTH_SYNTH8_FORCE_FRACLSB_MSB           0
+#define SYNTH_SYNTH8_FORCE_FRACLSB_LSB           0
+#define SYNTH_SYNTH8_FORCE_FRACLSB_MASK          0x00000001
+#define SYNTH_SYNTH8_FORCE_FRACLSB_GET(x)        (((x) & SYNTH_SYNTH8_FORCE_FRACLSB_MASK) >> SYNTH_SYNTH8_FORCE_FRACLSB_LSB)
+#define SYNTH_SYNTH8_FORCE_FRACLSB_SET(x)        (((x) << SYNTH_SYNTH8_FORCE_FRACLSB_LSB) & SYNTH_SYNTH8_FORCE_FRACLSB_MASK)
+
+#define RF5G_RF5G1_ADDRESS                       0x00000020
+#define RF5G_RF5G1_OFFSET                        0x00000020
+#define RF5G_RF5G1_PDTXLO5_MSB                   31
+#define RF5G_RF5G1_PDTXLO5_LSB                   31
+#define RF5G_RF5G1_PDTXLO5_MASK                  0x80000000
+#define RF5G_RF5G1_PDTXLO5_GET(x)                (((x) & RF5G_RF5G1_PDTXLO5_MASK) >> RF5G_RF5G1_PDTXLO5_LSB)
+#define RF5G_RF5G1_PDTXLO5_SET(x)                (((x) << RF5G_RF5G1_PDTXLO5_LSB) & RF5G_RF5G1_PDTXLO5_MASK)
+#define RF5G_RF5G1_PDTXMIX5_MSB                  30
+#define RF5G_RF5G1_PDTXMIX5_LSB                  30
+#define RF5G_RF5G1_PDTXMIX5_MASK                 0x40000000
+#define RF5G_RF5G1_PDTXMIX5_GET(x)               (((x) & RF5G_RF5G1_PDTXMIX5_MASK) >> RF5G_RF5G1_PDTXMIX5_LSB)
+#define RF5G_RF5G1_PDTXMIX5_SET(x)               (((x) << RF5G_RF5G1_PDTXMIX5_LSB) & RF5G_RF5G1_PDTXMIX5_MASK)
+#define RF5G_RF5G1_PDTXBUF5_MSB                  29
+#define RF5G_RF5G1_PDTXBUF5_LSB                  29
+#define RF5G_RF5G1_PDTXBUF5_MASK                 0x20000000
+#define RF5G_RF5G1_PDTXBUF5_GET(x)               (((x) & RF5G_RF5G1_PDTXBUF5_MASK) >> RF5G_RF5G1_PDTXBUF5_LSB)
+#define RF5G_RF5G1_PDTXBUF5_SET(x)               (((x) << RF5G_RF5G1_PDTXBUF5_LSB) & RF5G_RF5G1_PDTXBUF5_MASK)
+#define RF5G_RF5G1_PDPADRV5_MSB                  28
+#define RF5G_RF5G1_PDPADRV5_LSB                  28
+#define RF5G_RF5G1_PDPADRV5_MASK                 0x10000000
+#define RF5G_RF5G1_PDPADRV5_GET(x)               (((x) & RF5G_RF5G1_PDPADRV5_MASK) >> RF5G_RF5G1_PDPADRV5_LSB)
+#define RF5G_RF5G1_PDPADRV5_SET(x)               (((x) << RF5G_RF5G1_PDPADRV5_LSB) & RF5G_RF5G1_PDPADRV5_MASK)
+#define RF5G_RF5G1_PDPAOUT5_MSB                  27
+#define RF5G_RF5G1_PDPAOUT5_LSB                  27
+#define RF5G_RF5G1_PDPAOUT5_MASK                 0x08000000
+#define RF5G_RF5G1_PDPAOUT5_GET(x)               (((x) & RF5G_RF5G1_PDPAOUT5_MASK) >> RF5G_RF5G1_PDPAOUT5_LSB)
+#define RF5G_RF5G1_PDPAOUT5_SET(x)               (((x) << RF5G_RF5G1_PDPAOUT5_LSB) & RF5G_RF5G1_PDPAOUT5_MASK)
+#define RF5G_RF5G1_TUNE_PADRV5_MSB               26
+#define RF5G_RF5G1_TUNE_PADRV5_LSB               24
+#define RF5G_RF5G1_TUNE_PADRV5_MASK              0x07000000
+#define RF5G_RF5G1_TUNE_PADRV5_GET(x)            (((x) & RF5G_RF5G1_TUNE_PADRV5_MASK) >> RF5G_RF5G1_TUNE_PADRV5_LSB)
+#define RF5G_RF5G1_TUNE_PADRV5_SET(x)            (((x) << RF5G_RF5G1_TUNE_PADRV5_LSB) & RF5G_RF5G1_TUNE_PADRV5_MASK)
+#define RF5G_RF5G1_PWDTXPKD_MSB                  23
+#define RF5G_RF5G1_PWDTXPKD_LSB                  21
+#define RF5G_RF5G1_PWDTXPKD_MASK                 0x00e00000
+#define RF5G_RF5G1_PWDTXPKD_GET(x)               (((x) & RF5G_RF5G1_PWDTXPKD_MASK) >> RF5G_RF5G1_PWDTXPKD_LSB)
+#define RF5G_RF5G1_PWDTXPKD_SET(x)               (((x) << RF5G_RF5G1_PWDTXPKD_LSB) & RF5G_RF5G1_PWDTXPKD_MASK)
+#define RF5G_RF5G1_DB5_MSB                       20
+#define RF5G_RF5G1_DB5_LSB                       18
+#define RF5G_RF5G1_DB5_MASK                      0x001c0000
+#define RF5G_RF5G1_DB5_GET(x)                    (((x) & RF5G_RF5G1_DB5_MASK) >> RF5G_RF5G1_DB5_LSB)
+#define RF5G_RF5G1_DB5_SET(x)                    (((x) << RF5G_RF5G1_DB5_LSB) & RF5G_RF5G1_DB5_MASK)
+#define RF5G_RF5G1_OB5_MSB                       17
+#define RF5G_RF5G1_OB5_LSB                       15
+#define RF5G_RF5G1_OB5_MASK                      0x00038000
+#define RF5G_RF5G1_OB5_GET(x)                    (((x) & RF5G_RF5G1_OB5_MASK) >> RF5G_RF5G1_OB5_LSB)
+#define RF5G_RF5G1_OB5_SET(x)                    (((x) << RF5G_RF5G1_OB5_LSB) & RF5G_RF5G1_OB5_MASK)
+#define RF5G_RF5G1_TX5_ATB_SEL_MSB               14
+#define RF5G_RF5G1_TX5_ATB_SEL_LSB               12
+#define RF5G_RF5G1_TX5_ATB_SEL_MASK              0x00007000
+#define RF5G_RF5G1_TX5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G1_TX5_ATB_SEL_MASK) >> RF5G_RF5G1_TX5_ATB_SEL_LSB)
+#define RF5G_RF5G1_TX5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G1_TX5_ATB_SEL_LSB) & RF5G_RF5G1_TX5_ATB_SEL_MASK)
+#define RF5G_RF5G1_PDLO5DIV_MSB                  11
+#define RF5G_RF5G1_PDLO5DIV_LSB                  11
+#define RF5G_RF5G1_PDLO5DIV_MASK                 0x00000800
+#define RF5G_RF5G1_PDLO5DIV_GET(x)               (((x) & RF5G_RF5G1_PDLO5DIV_MASK) >> RF5G_RF5G1_PDLO5DIV_LSB)
+#define RF5G_RF5G1_PDLO5DIV_SET(x)               (((x) << RF5G_RF5G1_PDLO5DIV_LSB) & RF5G_RF5G1_PDLO5DIV_MASK)
+#define RF5G_RF5G1_PDLO5MIX_MSB                  10
+#define RF5G_RF5G1_PDLO5MIX_LSB                  10
+#define RF5G_RF5G1_PDLO5MIX_MASK                 0x00000400
+#define RF5G_RF5G1_PDLO5MIX_GET(x)               (((x) & RF5G_RF5G1_PDLO5MIX_MASK) >> RF5G_RF5G1_PDLO5MIX_LSB)
+#define RF5G_RF5G1_PDLO5MIX_SET(x)               (((x) << RF5G_RF5G1_PDLO5MIX_LSB) & RF5G_RF5G1_PDLO5MIX_MASK)
+#define RF5G_RF5G1_PDQBUF5_MSB                   9
+#define RF5G_RF5G1_PDQBUF5_LSB                   9
+#define RF5G_RF5G1_PDQBUF5_MASK                  0x00000200
+#define RF5G_RF5G1_PDQBUF5_GET(x)                (((x) & RF5G_RF5G1_PDQBUF5_MASK) >> RF5G_RF5G1_PDQBUF5_LSB)
+#define RF5G_RF5G1_PDQBUF5_SET(x)                (((x) << RF5G_RF5G1_PDQBUF5_LSB) & RF5G_RF5G1_PDQBUF5_MASK)
+#define RF5G_RF5G1_PDLO5AGC_MSB                  8
+#define RF5G_RF5G1_PDLO5AGC_LSB                  8
+#define RF5G_RF5G1_PDLO5AGC_MASK                 0x00000100
+#define RF5G_RF5G1_PDLO5AGC_GET(x)               (((x) & RF5G_RF5G1_PDLO5AGC_MASK) >> RF5G_RF5G1_PDLO5AGC_LSB)
+#define RF5G_RF5G1_PDLO5AGC_SET(x)               (((x) << RF5G_RF5G1_PDLO5AGC_LSB) & RF5G_RF5G1_PDLO5AGC_MASK)
+#define RF5G_RF5G1_PDREGLO5_MSB                  7
+#define RF5G_RF5G1_PDREGLO5_LSB                  7
+#define RF5G_RF5G1_PDREGLO5_MASK                 0x00000080
+#define RF5G_RF5G1_PDREGLO5_GET(x)               (((x) & RF5G_RF5G1_PDREGLO5_MASK) >> RF5G_RF5G1_PDREGLO5_LSB)
+#define RF5G_RF5G1_PDREGLO5_SET(x)               (((x) << RF5G_RF5G1_PDREGLO5_LSB) & RF5G_RF5G1_PDREGLO5_MASK)
+#define RF5G_RF5G1_LO5_ATB_SEL_MSB               6
+#define RF5G_RF5G1_LO5_ATB_SEL_LSB               4
+#define RF5G_RF5G1_LO5_ATB_SEL_MASK              0x00000070
+#define RF5G_RF5G1_LO5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G1_LO5_ATB_SEL_MASK) >> RF5G_RF5G1_LO5_ATB_SEL_LSB)
+#define RF5G_RF5G1_LO5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G1_LO5_ATB_SEL_LSB) & RF5G_RF5G1_LO5_ATB_SEL_MASK)
+#define RF5G_RF5G1_LO5CONTROL_MSB                3
+#define RF5G_RF5G1_LO5CONTROL_LSB                3
+#define RF5G_RF5G1_LO5CONTROL_MASK               0x00000008
+#define RF5G_RF5G1_LO5CONTROL_GET(x)             (((x) & RF5G_RF5G1_LO5CONTROL_MASK) >> RF5G_RF5G1_LO5CONTROL_LSB)
+#define RF5G_RF5G1_LO5CONTROL_SET(x)             (((x) << RF5G_RF5G1_LO5CONTROL_LSB) & RF5G_RF5G1_LO5CONTROL_MASK)
+#define RF5G_RF5G1_REGLO_BYPASS5_MSB             2
+#define RF5G_RF5G1_REGLO_BYPASS5_LSB             2
+#define RF5G_RF5G1_REGLO_BYPASS5_MASK            0x00000004
+#define RF5G_RF5G1_REGLO_BYPASS5_GET(x)          (((x) & RF5G_RF5G1_REGLO_BYPASS5_MASK) >> RF5G_RF5G1_REGLO_BYPASS5_LSB)
+#define RF5G_RF5G1_REGLO_BYPASS5_SET(x)          (((x) << RF5G_RF5G1_REGLO_BYPASS5_LSB) & RF5G_RF5G1_REGLO_BYPASS5_MASK)
+#define RF5G_RF5G1_SPARE_MSB                     1
+#define RF5G_RF5G1_SPARE_LSB                     0
+#define RF5G_RF5G1_SPARE_MASK                    0x00000003
+#define RF5G_RF5G1_SPARE_GET(x)                  (((x) & RF5G_RF5G1_SPARE_MASK) >> RF5G_RF5G1_SPARE_LSB)
+#define RF5G_RF5G1_SPARE_SET(x)                  (((x) << RF5G_RF5G1_SPARE_LSB) & RF5G_RF5G1_SPARE_MASK)
+
+#define RF5G_RF5G2_ADDRESS                       0x00000024
+#define RF5G_RF5G2_OFFSET                        0x00000024
+#define RF5G_RF5G2_AGCLO_B_MSB                   31
+#define RF5G_RF5G2_AGCLO_B_LSB                   29
+#define RF5G_RF5G2_AGCLO_B_MASK                  0xe0000000
+#define RF5G_RF5G2_AGCLO_B_GET(x)                (((x) & RF5G_RF5G2_AGCLO_B_MASK) >> RF5G_RF5G2_AGCLO_B_LSB)
+#define RF5G_RF5G2_AGCLO_B_SET(x)                (((x) << RF5G_RF5G2_AGCLO_B_LSB) & RF5G_RF5G2_AGCLO_B_MASK)
+#define RF5G_RF5G2_RX5_ATB_SEL_MSB               28
+#define RF5G_RF5G2_RX5_ATB_SEL_LSB               26
+#define RF5G_RF5G2_RX5_ATB_SEL_MASK              0x1c000000
+#define RF5G_RF5G2_RX5_ATB_SEL_GET(x)            (((x) & RF5G_RF5G2_RX5_ATB_SEL_MASK) >> RF5G_RF5G2_RX5_ATB_SEL_LSB)
+#define RF5G_RF5G2_RX5_ATB_SEL_SET(x)            (((x) << RF5G_RF5G2_RX5_ATB_SEL_LSB) & RF5G_RF5G2_RX5_ATB_SEL_MASK)
+#define RF5G_RF5G2_PDCMOSLO5_MSB                 25
+#define RF5G_RF5G2_PDCMOSLO5_LSB                 25
+#define RF5G_RF5G2_PDCMOSLO5_MASK                0x02000000
+#define RF5G_RF5G2_PDCMOSLO5_GET(x)              (((x) & RF5G_RF5G2_PDCMOSLO5_MASK) >> RF5G_RF5G2_PDCMOSLO5_LSB)
+#define RF5G_RF5G2_PDCMOSLO5_SET(x)              (((x) << RF5G_RF5G2_PDCMOSLO5_LSB) & RF5G_RF5G2_PDCMOSLO5_MASK)
+#define RF5G_RF5G2_PDVGM5_MSB                    24
+#define RF5G_RF5G2_PDVGM5_LSB                    24
+#define RF5G_RF5G2_PDVGM5_MASK                   0x01000000
+#define RF5G_RF5G2_PDVGM5_GET(x)                 (((x) & RF5G_RF5G2_PDVGM5_MASK) >> RF5G_RF5G2_PDVGM5_LSB)
+#define RF5G_RF5G2_PDVGM5_SET(x)                 (((x) << RF5G_RF5G2_PDVGM5_LSB) & RF5G_RF5G2_PDVGM5_MASK)
+#define RF5G_RF5G2_PDCSLNA5_MSB                  23
+#define RF5G_RF5G2_PDCSLNA5_LSB                  23
+#define RF5G_RF5G2_PDCSLNA5_MASK                 0x00800000
+#define RF5G_RF5G2_PDCSLNA5_GET(x)               (((x) & RF5G_RF5G2_PDCSLNA5_MASK) >> RF5G_RF5G2_PDCSLNA5_LSB)
+#define RF5G_RF5G2_PDCSLNA5_SET(x)               (((x) << RF5G_RF5G2_PDCSLNA5_LSB) & RF5G_RF5G2_PDCSLNA5_MASK)
+#define RF5G_RF5G2_PDRFVGA5_MSB                  22
+#define RF5G_RF5G2_PDRFVGA5_LSB                  22
+#define RF5G_RF5G2_PDRFVGA5_MASK                 0x00400000
+#define RF5G_RF5G2_PDRFVGA5_GET(x)               (((x) & RF5G_RF5G2_PDRFVGA5_MASK) >> RF5G_RF5G2_PDRFVGA5_LSB)
+#define RF5G_RF5G2_PDRFVGA5_SET(x)               (((x) << RF5G_RF5G2_PDRFVGA5_LSB) & RF5G_RF5G2_PDRFVGA5_MASK)
+#define RF5G_RF5G2_PDREGFE5_MSB                  21
+#define RF5G_RF5G2_PDREGFE5_LSB                  21
+#define RF5G_RF5G2_PDREGFE5_MASK                 0x00200000
+#define RF5G_RF5G2_PDREGFE5_GET(x)               (((x) & RF5G_RF5G2_PDREGFE5_MASK) >> RF5G_RF5G2_PDREGFE5_LSB)
+#define RF5G_RF5G2_PDREGFE5_SET(x)               (((x) << RF5G_RF5G2_PDREGFE5_LSB) & RF5G_RF5G2_PDREGFE5_MASK)
+#define RF5G_RF5G2_TUNE_RFVGA5_MSB               20
+#define RF5G_RF5G2_TUNE_RFVGA5_LSB               18
+#define RF5G_RF5G2_TUNE_RFVGA5_MASK              0x001c0000
+#define RF5G_RF5G2_TUNE_RFVGA5_GET(x)            (((x) & RF5G_RF5G2_TUNE_RFVGA5_MASK) >> RF5G_RF5G2_TUNE_RFVGA5_LSB)
+#define RF5G_RF5G2_TUNE_RFVGA5_SET(x)            (((x) << RF5G_RF5G2_TUNE_RFVGA5_LSB) & RF5G_RF5G2_TUNE_RFVGA5_MASK)
+#define RF5G_RF5G2_BRFVGA5_MSB                   17
+#define RF5G_RF5G2_BRFVGA5_LSB                   15
+#define RF5G_RF5G2_BRFVGA5_MASK                  0x00038000
+#define RF5G_RF5G2_BRFVGA5_GET(x)                (((x) & RF5G_RF5G2_BRFVGA5_MASK) >> RF5G_RF5G2_BRFVGA5_LSB)
+#define RF5G_RF5G2_BRFVGA5_SET(x)                (((x) << RF5G_RF5G2_BRFVGA5_LSB) & RF5G_RF5G2_BRFVGA5_MASK)
+#define RF5G_RF5G2_BCSLNA5_MSB                   14
+#define RF5G_RF5G2_BCSLNA5_LSB                   12
+#define RF5G_RF5G2_BCSLNA5_MASK                  0x00007000
+#define RF5G_RF5G2_BCSLNA5_GET(x)                (((x) & RF5G_RF5G2_BCSLNA5_MASK) >> RF5G_RF5G2_BCSLNA5_LSB)
+#define RF5G_RF5G2_BCSLNA5_SET(x)                (((x) << RF5G_RF5G2_BCSLNA5_LSB) & RF5G_RF5G2_BCSLNA5_MASK)
+#define RF5G_RF5G2_BVGM5_MSB                     11
+#define RF5G_RF5G2_BVGM5_LSB                     9
+#define RF5G_RF5G2_BVGM5_MASK                    0x00000e00
+#define RF5G_RF5G2_BVGM5_GET(x)                  (((x) & RF5G_RF5G2_BVGM5_MASK) >> RF5G_RF5G2_BVGM5_LSB)
+#define RF5G_RF5G2_BVGM5_SET(x)                  (((x) << RF5G_RF5G2_BVGM5_LSB) & RF5G_RF5G2_BVGM5_MASK)
+#define RF5G_RF5G2_REGFE_BYPASS5_MSB             8
+#define RF5G_RF5G2_REGFE_BYPASS5_LSB             8
+#define RF5G_RF5G2_REGFE_BYPASS5_MASK            0x00000100
+#define RF5G_RF5G2_REGFE_BYPASS5_GET(x)          (((x) & RF5G_RF5G2_REGFE_BYPASS5_MASK) >> RF5G_RF5G2_REGFE_BYPASS5_LSB)
+#define RF5G_RF5G2_REGFE_BYPASS5_SET(x)          (((x) << RF5G_RF5G2_REGFE_BYPASS5_LSB) & RF5G_RF5G2_REGFE_BYPASS5_MASK)
+#define RF5G_RF5G2_LNA5_ATTENMODE_MSB            7
+#define RF5G_RF5G2_LNA5_ATTENMODE_LSB            6
+#define RF5G_RF5G2_LNA5_ATTENMODE_MASK           0x000000c0
+#define RF5G_RF5G2_LNA5_ATTENMODE_GET(x)         (((x) & RF5G_RF5G2_LNA5_ATTENMODE_MASK) >> RF5G_RF5G2_LNA5_ATTENMODE_LSB)
+#define RF5G_RF5G2_LNA5_ATTENMODE_SET(x)         (((x) << RF5G_RF5G2_LNA5_ATTENMODE_LSB) & RF5G_RF5G2_LNA5_ATTENMODE_MASK)
+#define RF5G_RF5G2_ENABLE_PCA_MSB                5
+#define RF5G_RF5G2_ENABLE_PCA_LSB                5
+#define RF5G_RF5G2_ENABLE_PCA_MASK               0x00000020
+#define RF5G_RF5G2_ENABLE_PCA_GET(x)             (((x) & RF5G_RF5G2_ENABLE_PCA_MASK) >> RF5G_RF5G2_ENABLE_PCA_LSB)
+#define RF5G_RF5G2_ENABLE_PCA_SET(x)             (((x) << RF5G_RF5G2_ENABLE_PCA_LSB) & RF5G_RF5G2_ENABLE_PCA_MASK)
+#define RF5G_RF5G2_TUNE_LO_MSB                   4
+#define RF5G_RF5G2_TUNE_LO_LSB                   2
+#define RF5G_RF5G2_TUNE_LO_MASK                  0x0000001c
+#define RF5G_RF5G2_TUNE_LO_GET(x)                (((x) & RF5G_RF5G2_TUNE_LO_MASK) >> RF5G_RF5G2_TUNE_LO_LSB)
+#define RF5G_RF5G2_TUNE_LO_SET(x)                (((x) << RF5G_RF5G2_TUNE_LO_LSB) & RF5G_RF5G2_TUNE_LO_MASK)
+#define RF5G_RF5G2_SPARE_MSB                     1
+#define RF5G_RF5G2_SPARE_LSB                     0
+#define RF5G_RF5G2_SPARE_MASK                    0x00000003
+#define RF5G_RF5G2_SPARE_GET(x)                  (((x) & RF5G_RF5G2_SPARE_MASK) >> RF5G_RF5G2_SPARE_LSB)
+#define RF5G_RF5G2_SPARE_SET(x)                  (((x) << RF5G_RF5G2_SPARE_LSB) & RF5G_RF5G2_SPARE_MASK)
+
+#define RF2G_RF2G1_ADDRESS                       0x00000028
+#define RF2G_RF2G1_OFFSET                        0x00000028
+#define RF2G_RF2G1_BLNA1_MSB                     31
+#define RF2G_RF2G1_BLNA1_LSB                     29
+#define RF2G_RF2G1_BLNA1_MASK                    0xe0000000
+#define RF2G_RF2G1_BLNA1_GET(x)                  (((x) & RF2G_RF2G1_BLNA1_MASK) >> RF2G_RF2G1_BLNA1_LSB)
+#define RF2G_RF2G1_BLNA1_SET(x)                  (((x) << RF2G_RF2G1_BLNA1_LSB) & RF2G_RF2G1_BLNA1_MASK)
+#define RF2G_RF2G1_BLNA1F_MSB                    28
+#define RF2G_RF2G1_BLNA1F_LSB                    26
+#define RF2G_RF2G1_BLNA1F_MASK                   0x1c000000
+#define RF2G_RF2G1_BLNA1F_GET(x)                 (((x) & RF2G_RF2G1_BLNA1F_MASK) >> RF2G_RF2G1_BLNA1F_LSB)
+#define RF2G_RF2G1_BLNA1F_SET(x)                 (((x) << RF2G_RF2G1_BLNA1F_LSB) & RF2G_RF2G1_BLNA1F_MASK)
+#define RF2G_RF2G1_BLNA1BUF_MSB                  25
+#define RF2G_RF2G1_BLNA1BUF_LSB                  23
+#define RF2G_RF2G1_BLNA1BUF_MASK                 0x03800000
+#define RF2G_RF2G1_BLNA1BUF_GET(x)               (((x) & RF2G_RF2G1_BLNA1BUF_MASK) >> RF2G_RF2G1_BLNA1BUF_LSB)
+#define RF2G_RF2G1_BLNA1BUF_SET(x)               (((x) << RF2G_RF2G1_BLNA1BUF_LSB) & RF2G_RF2G1_BLNA1BUF_MASK)
+#define RF2G_RF2G1_BLNA2_MSB                     22
+#define RF2G_RF2G1_BLNA2_LSB                     20
+#define RF2G_RF2G1_BLNA2_MASK                    0x00700000
+#define RF2G_RF2G1_BLNA2_GET(x)                  (((x) & RF2G_RF2G1_BLNA2_MASK) >> RF2G_RF2G1_BLNA2_LSB)
+#define RF2G_RF2G1_BLNA2_SET(x)                  (((x) << RF2G_RF2G1_BLNA2_LSB) & RF2G_RF2G1_BLNA2_MASK)
+#define RF2G_RF2G1_DB_MSB                        19
+#define RF2G_RF2G1_DB_LSB                        17
+#define RF2G_RF2G1_DB_MASK                       0x000e0000
+#define RF2G_RF2G1_DB_GET(x)                     (((x) & RF2G_RF2G1_DB_MASK) >> RF2G_RF2G1_DB_LSB)
+#define RF2G_RF2G1_DB_SET(x)                     (((x) << RF2G_RF2G1_DB_LSB) & RF2G_RF2G1_DB_MASK)
+#define RF2G_RF2G1_OB_MSB                        16
+#define RF2G_RF2G1_OB_LSB                        14
+#define RF2G_RF2G1_OB_MASK                       0x0001c000
+#define RF2G_RF2G1_OB_GET(x)                     (((x) & RF2G_RF2G1_OB_MASK) >> RF2G_RF2G1_OB_LSB)
+#define RF2G_RF2G1_OB_SET(x)                     (((x) << RF2G_RF2G1_OB_LSB) & RF2G_RF2G1_OB_MASK)
+#define RF2G_RF2G1_FE_ATB_SEL_MSB                13
+#define RF2G_RF2G1_FE_ATB_SEL_LSB                11
+#define RF2G_RF2G1_FE_ATB_SEL_MASK               0x00003800
+#define RF2G_RF2G1_FE_ATB_SEL_GET(x)             (((x) & RF2G_RF2G1_FE_ATB_SEL_MASK) >> RF2G_RF2G1_FE_ATB_SEL_LSB)
+#define RF2G_RF2G1_FE_ATB_SEL_SET(x)             (((x) << RF2G_RF2G1_FE_ATB_SEL_LSB) & RF2G_RF2G1_FE_ATB_SEL_MASK)
+#define RF2G_RF2G1_RF_ATB_SEL_MSB                10
+#define RF2G_RF2G1_RF_ATB_SEL_LSB                8
+#define RF2G_RF2G1_RF_ATB_SEL_MASK               0x00000700
+#define RF2G_RF2G1_RF_ATB_SEL_GET(x)             (((x) & RF2G_RF2G1_RF_ATB_SEL_MASK) >> RF2G_RF2G1_RF_ATB_SEL_LSB)
+#define RF2G_RF2G1_RF_ATB_SEL_SET(x)             (((x) << RF2G_RF2G1_RF_ATB_SEL_LSB) & RF2G_RF2G1_RF_ATB_SEL_MASK)
+#define RF2G_RF2G1_SELLNA_MSB                    7
+#define RF2G_RF2G1_SELLNA_LSB                    7
+#define RF2G_RF2G1_SELLNA_MASK                   0x00000080
+#define RF2G_RF2G1_SELLNA_GET(x)                 (((x) & RF2G_RF2G1_SELLNA_MASK) >> RF2G_RF2G1_SELLNA_LSB)
+#define RF2G_RF2G1_SELLNA_SET(x)                 (((x) << RF2G_RF2G1_SELLNA_LSB) & RF2G_RF2G1_SELLNA_MASK)
+#define RF2G_RF2G1_LOCONTROL_MSB                 6
+#define RF2G_RF2G1_LOCONTROL_LSB                 6
+#define RF2G_RF2G1_LOCONTROL_MASK                0x00000040
+#define RF2G_RF2G1_LOCONTROL_GET(x)              (((x) & RF2G_RF2G1_LOCONTROL_MASK) >> RF2G_RF2G1_LOCONTROL_LSB)
+#define RF2G_RF2G1_LOCONTROL_SET(x)              (((x) << RF2G_RF2G1_LOCONTROL_LSB) & RF2G_RF2G1_LOCONTROL_MASK)
+#define RF2G_RF2G1_SHORTLNA2_MSB                 5
+#define RF2G_RF2G1_SHORTLNA2_LSB                 5
+#define RF2G_RF2G1_SHORTLNA2_MASK                0x00000020
+#define RF2G_RF2G1_SHORTLNA2_GET(x)              (((x) & RF2G_RF2G1_SHORTLNA2_MASK) >> RF2G_RF2G1_SHORTLNA2_LSB)
+#define RF2G_RF2G1_SHORTLNA2_SET(x)              (((x) << RF2G_RF2G1_SHORTLNA2_LSB) & RF2G_RF2G1_SHORTLNA2_MASK)
+#define RF2G_RF2G1_SPARE_MSB                     4
+#define RF2G_RF2G1_SPARE_LSB                     0
+#define RF2G_RF2G1_SPARE_MASK                    0x0000001f
+#define RF2G_RF2G1_SPARE_GET(x)                  (((x) & RF2G_RF2G1_SPARE_MASK) >> RF2G_RF2G1_SPARE_LSB)
+#define RF2G_RF2G1_SPARE_SET(x)                  (((x) << RF2G_RF2G1_SPARE_LSB) & RF2G_RF2G1_SPARE_MASK)
+
+#define RF2G_RF2G2_ADDRESS                       0x0000002c
+#define RF2G_RF2G2_OFFSET                        0x0000002c
+#define RF2G_RF2G2_PDCGLNA_MSB                   31
+#define RF2G_RF2G2_PDCGLNA_LSB                   31
+#define RF2G_RF2G2_PDCGLNA_MASK                  0x80000000
+#define RF2G_RF2G2_PDCGLNA_GET(x)                (((x) & RF2G_RF2G2_PDCGLNA_MASK) >> RF2G_RF2G2_PDCGLNA_LSB)
+#define RF2G_RF2G2_PDCGLNA_SET(x)                (((x) << RF2G_RF2G2_PDCGLNA_LSB) & RF2G_RF2G2_PDCGLNA_MASK)
+#define RF2G_RF2G2_PDCGLNABUF_MSB                30
+#define RF2G_RF2G2_PDCGLNABUF_LSB                30
+#define RF2G_RF2G2_PDCGLNABUF_MASK               0x40000000
+#define RF2G_RF2G2_PDCGLNABUF_GET(x)             (((x) & RF2G_RF2G2_PDCGLNABUF_MASK) >> RF2G_RF2G2_PDCGLNABUF_LSB)
+#define RF2G_RF2G2_PDCGLNABUF_SET(x)             (((x) << RF2G_RF2G2_PDCGLNABUF_LSB) & RF2G_RF2G2_PDCGLNABUF_MASK)
+#define RF2G_RF2G2_PDCSLNA_MSB                   29
+#define RF2G_RF2G2_PDCSLNA_LSB                   29
+#define RF2G_RF2G2_PDCSLNA_MASK                  0x20000000
+#define RF2G_RF2G2_PDCSLNA_GET(x)                (((x) & RF2G_RF2G2_PDCSLNA_MASK) >> RF2G_RF2G2_PDCSLNA_LSB)
+#define RF2G_RF2G2_PDCSLNA_SET(x)                (((x) << RF2G_RF2G2_PDCSLNA_LSB) & RF2G_RF2G2_PDCSLNA_MASK)
+#define RF2G_RF2G2_PDDIV_MSB                     28
+#define RF2G_RF2G2_PDDIV_LSB                     28
+#define RF2G_RF2G2_PDDIV_MASK                    0x10000000
+#define RF2G_RF2G2_PDDIV_GET(x)                  (((x) & RF2G_RF2G2_PDDIV_MASK) >> RF2G_RF2G2_PDDIV_LSB)
+#define RF2G_RF2G2_PDDIV_SET(x)                  (((x) << RF2G_RF2G2_PDDIV_LSB) & RF2G_RF2G2_PDDIV_MASK)
+#define RF2G_RF2G2_PDPADRV_MSB                   27
+#define RF2G_RF2G2_PDPADRV_LSB                   27
+#define RF2G_RF2G2_PDPADRV_MASK                  0x08000000
+#define RF2G_RF2G2_PDPADRV_GET(x)                (((x) & RF2G_RF2G2_PDPADRV_MASK) >> RF2G_RF2G2_PDPADRV_LSB)
+#define RF2G_RF2G2_PDPADRV_SET(x)                (((x) << RF2G_RF2G2_PDPADRV_LSB) & RF2G_RF2G2_PDPADRV_MASK)
+#define RF2G_RF2G2_PDPAOUT_MSB                   26
+#define RF2G_RF2G2_PDPAOUT_LSB                   26
+#define RF2G_RF2G2_PDPAOUT_MASK                  0x04000000
+#define RF2G_RF2G2_PDPAOUT_GET(x)                (((x) & RF2G_RF2G2_PDPAOUT_MASK) >> RF2G_RF2G2_PDPAOUT_LSB)
+#define RF2G_RF2G2_PDPAOUT_SET(x)                (((x) << RF2G_RF2G2_PDPAOUT_LSB) & RF2G_RF2G2_PDPAOUT_MASK)
+#define RF2G_RF2G2_PDREGLNA_MSB                  25
+#define RF2G_RF2G2_PDREGLNA_LSB                  25
+#define RF2G_RF2G2_PDREGLNA_MASK                 0x02000000
+#define RF2G_RF2G2_PDREGLNA_GET(x)               (((x) & RF2G_RF2G2_PDREGLNA_MASK) >> RF2G_RF2G2_PDREGLNA_LSB)
+#define RF2G_RF2G2_PDREGLNA_SET(x)               (((x) << RF2G_RF2G2_PDREGLNA_LSB) & RF2G_RF2G2_PDREGLNA_MASK)
+#define RF2G_RF2G2_PDREGLO_MSB                   24
+#define RF2G_RF2G2_PDREGLO_LSB                   24
+#define RF2G_RF2G2_PDREGLO_MASK                  0x01000000
+#define RF2G_RF2G2_PDREGLO_GET(x)                (((x) & RF2G_RF2G2_PDREGLO_MASK) >> RF2G_RF2G2_PDREGLO_LSB)
+#define RF2G_RF2G2_PDREGLO_SET(x)                (((x) << RF2G_RF2G2_PDREGLO_LSB) & RF2G_RF2G2_PDREGLO_MASK)
+#define RF2G_RF2G2_PDRFGM_MSB                    23
+#define RF2G_RF2G2_PDRFGM_LSB                    23
+#define RF2G_RF2G2_PDRFGM_MASK                   0x00800000
+#define RF2G_RF2G2_PDRFGM_GET(x)                 (((x) & RF2G_RF2G2_PDRFGM_MASK) >> RF2G_RF2G2_PDRFGM_LSB)
+#define RF2G_RF2G2_PDRFGM_SET(x)                 (((x) << RF2G_RF2G2_PDRFGM_LSB) & RF2G_RF2G2_PDRFGM_MASK)
+#define RF2G_RF2G2_PDRXLO_MSB                    22
+#define RF2G_RF2G2_PDRXLO_LSB                    22
+#define RF2G_RF2G2_PDRXLO_MASK                   0x00400000
+#define RF2G_RF2G2_PDRXLO_GET(x)                 (((x) & RF2G_RF2G2_PDRXLO_MASK) >> RF2G_RF2G2_PDRXLO_LSB)
+#define RF2G_RF2G2_PDRXLO_SET(x)                 (((x) << RF2G_RF2G2_PDRXLO_LSB) & RF2G_RF2G2_PDRXLO_MASK)
+#define RF2G_RF2G2_PDTXLO_MSB                    21
+#define RF2G_RF2G2_PDTXLO_LSB                    21
+#define RF2G_RF2G2_PDTXLO_MASK                   0x00200000
+#define RF2G_RF2G2_PDTXLO_GET(x)                 (((x) & RF2G_RF2G2_PDTXLO_MASK) >> RF2G_RF2G2_PDTXLO_LSB)
+#define RF2G_RF2G2_PDTXLO_SET(x)                 (((x) << RF2G_RF2G2_PDTXLO_LSB) & RF2G_RF2G2_PDTXLO_MASK)
+#define RF2G_RF2G2_PDTXMIX_MSB                   20
+#define RF2G_RF2G2_PDTXMIX_LSB                   20
+#define RF2G_RF2G2_PDTXMIX_MASK                  0x00100000
+#define RF2G_RF2G2_PDTXMIX_GET(x)                (((x) & RF2G_RF2G2_PDTXMIX_MASK) >> RF2G_RF2G2_PDTXMIX_LSB)
+#define RF2G_RF2G2_PDTXMIX_SET(x)                (((x) << RF2G_RF2G2_PDTXMIX_LSB) & RF2G_RF2G2_PDTXMIX_MASK)
+#define RF2G_RF2G2_REGLNA_BYPASS_MSB             19
+#define RF2G_RF2G2_REGLNA_BYPASS_LSB             19
+#define RF2G_RF2G2_REGLNA_BYPASS_MASK            0x00080000
+#define RF2G_RF2G2_REGLNA_BYPASS_GET(x)          (((x) & RF2G_RF2G2_REGLNA_BYPASS_MASK) >> RF2G_RF2G2_REGLNA_BYPASS_LSB)
+#define RF2G_RF2G2_REGLNA_BYPASS_SET(x)          (((x) << RF2G_RF2G2_REGLNA_BYPASS_LSB) & RF2G_RF2G2_REGLNA_BYPASS_MASK)
+#define RF2G_RF2G2_REGLO_BYPASS_MSB              18
+#define RF2G_RF2G2_REGLO_BYPASS_LSB              18
+#define RF2G_RF2G2_REGLO_BYPASS_MASK             0x00040000
+#define RF2G_RF2G2_REGLO_BYPASS_GET(x)           (((x) & RF2G_RF2G2_REGLO_BYPASS_MASK) >> RF2G_RF2G2_REGLO_BYPASS_LSB)
+#define RF2G_RF2G2_REGLO_BYPASS_SET(x)           (((x) << RF2G_RF2G2_REGLO_BYPASS_LSB) & RF2G_RF2G2_REGLO_BYPASS_MASK)
+#define RF2G_RF2G2_ENABLE_PCB_MSB                17
+#define RF2G_RF2G2_ENABLE_PCB_LSB                17
+#define RF2G_RF2G2_ENABLE_PCB_MASK               0x00020000
+#define RF2G_RF2G2_ENABLE_PCB_GET(x)             (((x) & RF2G_RF2G2_ENABLE_PCB_MASK) >> RF2G_RF2G2_ENABLE_PCB_LSB)
+#define RF2G_RF2G2_ENABLE_PCB_SET(x)             (((x) << RF2G_RF2G2_ENABLE_PCB_LSB) & RF2G_RF2G2_ENABLE_PCB_MASK)
+#define RF2G_RF2G2_SPARE_MSB                     16
+#define RF2G_RF2G2_SPARE_LSB                     0
+#define RF2G_RF2G2_SPARE_MASK                    0x0001ffff
+#define RF2G_RF2G2_SPARE_GET(x)                  (((x) & RF2G_RF2G2_SPARE_MASK) >> RF2G_RF2G2_SPARE_LSB)
+#define RF2G_RF2G2_SPARE_SET(x)                  (((x) << RF2G_RF2G2_SPARE_LSB) & RF2G_RF2G2_SPARE_MASK)
+
+#define TOP_GAIN_ADDRESS                         0x00000030
+#define TOP_GAIN_OFFSET                          0x00000030
+#define TOP_GAIN_TX6DBLOQGAIN_MSB                31
+#define TOP_GAIN_TX6DBLOQGAIN_LSB                30
+#define TOP_GAIN_TX6DBLOQGAIN_MASK               0xc0000000
+#define TOP_GAIN_TX6DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_TX6DBLOQGAIN_MASK) >> TOP_GAIN_TX6DBLOQGAIN_LSB)
+#define TOP_GAIN_TX6DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_TX6DBLOQGAIN_LSB) & TOP_GAIN_TX6DBLOQGAIN_MASK)
+#define TOP_GAIN_TX1DBLOQGAIN_MSB                29
+#define TOP_GAIN_TX1DBLOQGAIN_LSB                27
+#define TOP_GAIN_TX1DBLOQGAIN_MASK               0x38000000
+#define TOP_GAIN_TX1DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_TX1DBLOQGAIN_MASK) >> TOP_GAIN_TX1DBLOQGAIN_LSB)
+#define TOP_GAIN_TX1DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_TX1DBLOQGAIN_LSB) & TOP_GAIN_TX1DBLOQGAIN_MASK)
+#define TOP_GAIN_TXV2IGAIN_MSB                   26
+#define TOP_GAIN_TXV2IGAIN_LSB                   25
+#define TOP_GAIN_TXV2IGAIN_MASK                  0x06000000
+#define TOP_GAIN_TXV2IGAIN_GET(x)                (((x) & TOP_GAIN_TXV2IGAIN_MASK) >> TOP_GAIN_TXV2IGAIN_LSB)
+#define TOP_GAIN_TXV2IGAIN_SET(x)                (((x) << TOP_GAIN_TXV2IGAIN_LSB) & TOP_GAIN_TXV2IGAIN_MASK)
+#define TOP_GAIN_PABUF5GN_MSB                    24
+#define TOP_GAIN_PABUF5GN_LSB                    24
+#define TOP_GAIN_PABUF5GN_MASK                   0x01000000
+#define TOP_GAIN_PABUF5GN_GET(x)                 (((x) & TOP_GAIN_PABUF5GN_MASK) >> TOP_GAIN_PABUF5GN_LSB)
+#define TOP_GAIN_PABUF5GN_SET(x)                 (((x) << TOP_GAIN_PABUF5GN_LSB) & TOP_GAIN_PABUF5GN_MASK)
+#define TOP_GAIN_PADRVGN_MSB                     23
+#define TOP_GAIN_PADRVGN_LSB                     21
+#define TOP_GAIN_PADRVGN_MASK                    0x00e00000
+#define TOP_GAIN_PADRVGN_GET(x)                  (((x) & TOP_GAIN_PADRVGN_MASK) >> TOP_GAIN_PADRVGN_LSB)
+#define TOP_GAIN_PADRVGN_SET(x)                  (((x) << TOP_GAIN_PADRVGN_LSB) & TOP_GAIN_PADRVGN_MASK)
+#define TOP_GAIN_PAOUT2GN_MSB                    20
+#define TOP_GAIN_PAOUT2GN_LSB                    18
+#define TOP_GAIN_PAOUT2GN_MASK                   0x001c0000
+#define TOP_GAIN_PAOUT2GN_GET(x)                 (((x) & TOP_GAIN_PAOUT2GN_MASK) >> TOP_GAIN_PAOUT2GN_LSB)
+#define TOP_GAIN_PAOUT2GN_SET(x)                 (((x) << TOP_GAIN_PAOUT2GN_LSB) & TOP_GAIN_PAOUT2GN_MASK)
+#define TOP_GAIN_LNAON_MSB                       17
+#define TOP_GAIN_LNAON_LSB                       17
+#define TOP_GAIN_LNAON_MASK                      0x00020000
+#define TOP_GAIN_LNAON_GET(x)                    (((x) & TOP_GAIN_LNAON_MASK) >> TOP_GAIN_LNAON_LSB)
+#define TOP_GAIN_LNAON_SET(x)                    (((x) << TOP_GAIN_LNAON_LSB) & TOP_GAIN_LNAON_MASK)
+#define TOP_GAIN_LNAGAIN_MSB                     16
+#define TOP_GAIN_LNAGAIN_LSB                     13
+#define TOP_GAIN_LNAGAIN_MASK                    0x0001e000
+#define TOP_GAIN_LNAGAIN_GET(x)                  (((x) & TOP_GAIN_LNAGAIN_MASK) >> TOP_GAIN_LNAGAIN_LSB)
+#define TOP_GAIN_LNAGAIN_SET(x)                  (((x) << TOP_GAIN_LNAGAIN_LSB) & TOP_GAIN_LNAGAIN_MASK)
+#define TOP_GAIN_RFVGA5GAIN_MSB                  12
+#define TOP_GAIN_RFVGA5GAIN_LSB                  11
+#define TOP_GAIN_RFVGA5GAIN_MASK                 0x00001800
+#define TOP_GAIN_RFVGA5GAIN_GET(x)               (((x) & TOP_GAIN_RFVGA5GAIN_MASK) >> TOP_GAIN_RFVGA5GAIN_LSB)
+#define TOP_GAIN_RFVGA5GAIN_SET(x)               (((x) << TOP_GAIN_RFVGA5GAIN_LSB) & TOP_GAIN_RFVGA5GAIN_MASK)
+#define TOP_GAIN_RFGMGN_MSB                      10
+#define TOP_GAIN_RFGMGN_LSB                      8
+#define TOP_GAIN_RFGMGN_MASK                     0x00000700
+#define TOP_GAIN_RFGMGN_GET(x)                   (((x) & TOP_GAIN_RFGMGN_MASK) >> TOP_GAIN_RFGMGN_LSB)
+#define TOP_GAIN_RFGMGN_SET(x)                   (((x) << TOP_GAIN_RFGMGN_LSB) & TOP_GAIN_RFGMGN_MASK)
+#define TOP_GAIN_RX6DBLOQGAIN_MSB                7
+#define TOP_GAIN_RX6DBLOQGAIN_LSB                6
+#define TOP_GAIN_RX6DBLOQGAIN_MASK               0x000000c0
+#define TOP_GAIN_RX6DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_RX6DBLOQGAIN_MASK) >> TOP_GAIN_RX6DBLOQGAIN_LSB)
+#define TOP_GAIN_RX6DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_RX6DBLOQGAIN_LSB) & TOP_GAIN_RX6DBLOQGAIN_MASK)
+#define TOP_GAIN_RX1DBLOQGAIN_MSB                5
+#define TOP_GAIN_RX1DBLOQGAIN_LSB                3
+#define TOP_GAIN_RX1DBLOQGAIN_MASK               0x00000038
+#define TOP_GAIN_RX1DBLOQGAIN_GET(x)             (((x) & TOP_GAIN_RX1DBLOQGAIN_MASK) >> TOP_GAIN_RX1DBLOQGAIN_LSB)
+#define TOP_GAIN_RX1DBLOQGAIN_SET(x)             (((x) << TOP_GAIN_RX1DBLOQGAIN_LSB) & TOP_GAIN_RX1DBLOQGAIN_MASK)
+#define TOP_GAIN_RX6DBHIQGAIN_MSB                2
+#define TOP_GAIN_RX6DBHIQGAIN_LSB                1
+#define TOP_GAIN_RX6DBHIQGAIN_MASK               0x00000006
+#define TOP_GAIN_RX6DBHIQGAIN_GET(x)             (((x) & TOP_GAIN_RX6DBHIQGAIN_MASK) >> TOP_GAIN_RX6DBHIQGAIN_LSB)
+#define TOP_GAIN_RX6DBHIQGAIN_SET(x)             (((x) << TOP_GAIN_RX6DBHIQGAIN_LSB) & TOP_GAIN_RX6DBHIQGAIN_MASK)
+#define TOP_GAIN_SPARE_MSB                       0
+#define TOP_GAIN_SPARE_LSB                       0
+#define TOP_GAIN_SPARE_MASK                      0x00000001
+#define TOP_GAIN_SPARE_GET(x)                    (((x) & TOP_GAIN_SPARE_MASK) >> TOP_GAIN_SPARE_LSB)
+#define TOP_GAIN_SPARE_SET(x)                    (((x) << TOP_GAIN_SPARE_LSB) & TOP_GAIN_SPARE_MASK)
+
+#define TOP_TOP_ADDRESS                          0x00000034
+#define TOP_TOP_OFFSET                           0x00000034
+#define TOP_TOP_LOCALTXGAIN_MSB                  31
+#define TOP_TOP_LOCALTXGAIN_LSB                  31
+#define TOP_TOP_LOCALTXGAIN_MASK                 0x80000000
+#define TOP_TOP_LOCALTXGAIN_GET(x)               (((x) & TOP_TOP_LOCALTXGAIN_MASK) >> TOP_TOP_LOCALTXGAIN_LSB)
+#define TOP_TOP_LOCALTXGAIN_SET(x)               (((x) << TOP_TOP_LOCALTXGAIN_LSB) & TOP_TOP_LOCALTXGAIN_MASK)
+#define TOP_TOP_LOCALRXGAIN_MSB                  30
+#define TOP_TOP_LOCALRXGAIN_LSB                  30
+#define TOP_TOP_LOCALRXGAIN_MASK                 0x40000000
+#define TOP_TOP_LOCALRXGAIN_GET(x)               (((x) & TOP_TOP_LOCALRXGAIN_MASK) >> TOP_TOP_LOCALRXGAIN_LSB)
+#define TOP_TOP_LOCALRXGAIN_SET(x)               (((x) << TOP_TOP_LOCALRXGAIN_LSB) & TOP_TOP_LOCALRXGAIN_MASK)
+#define TOP_TOP_LOCALMODE_MSB                    29
+#define TOP_TOP_LOCALMODE_LSB                    29
+#define TOP_TOP_LOCALMODE_MASK                   0x20000000
+#define TOP_TOP_LOCALMODE_GET(x)                 (((x) & TOP_TOP_LOCALMODE_MASK) >> TOP_TOP_LOCALMODE_LSB)
+#define TOP_TOP_LOCALMODE_SET(x)                 (((x) << TOP_TOP_LOCALMODE_LSB) & TOP_TOP_LOCALMODE_MASK)
+#define TOP_TOP_CALFC_MSB                        28
+#define TOP_TOP_CALFC_LSB                        28
+#define TOP_TOP_CALFC_MASK                       0x10000000
+#define TOP_TOP_CALFC_GET(x)                     (((x) & TOP_TOP_CALFC_MASK) >> TOP_TOP_CALFC_LSB)
+#define TOP_TOP_CALFC_SET(x)                     (((x) << TOP_TOP_CALFC_LSB) & TOP_TOP_CALFC_MASK)
+#define TOP_TOP_CALDC_MSB                        27
+#define TOP_TOP_CALDC_LSB                        27
+#define TOP_TOP_CALDC_MASK                       0x08000000
+#define TOP_TOP_CALDC_GET(x)                     (((x) & TOP_TOP_CALDC_MASK) >> TOP_TOP_CALDC_LSB)
+#define TOP_TOP_CALDC_SET(x)                     (((x) << TOP_TOP_CALDC_LSB) & TOP_TOP_CALDC_MASK)
+#define TOP_TOP_CAL_RESIDUE_MSB                  26
+#define TOP_TOP_CAL_RESIDUE_LSB                  26
+#define TOP_TOP_CAL_RESIDUE_MASK                 0x04000000
+#define TOP_TOP_CAL_RESIDUE_GET(x)               (((x) & TOP_TOP_CAL_RESIDUE_MASK) >> TOP_TOP_CAL_RESIDUE_LSB)
+#define TOP_TOP_CAL_RESIDUE_SET(x)               (((x) << TOP_TOP_CAL_RESIDUE_LSB) & TOP_TOP_CAL_RESIDUE_MASK)
+#define TOP_TOP_BMODE_MSB                        25
+#define TOP_TOP_BMODE_LSB                        25
+#define TOP_TOP_BMODE_MASK                       0x02000000
+#define TOP_TOP_BMODE_GET(x)                     (((x) & TOP_TOP_BMODE_MASK) >> TOP_TOP_BMODE_LSB)
+#define TOP_TOP_BMODE_SET(x)                     (((x) << TOP_TOP_BMODE_LSB) & TOP_TOP_BMODE_MASK)
+#define TOP_TOP_SYNTHON_MSB                      24
+#define TOP_TOP_SYNTHON_LSB                      24
+#define TOP_TOP_SYNTHON_MASK                     0x01000000
+#define TOP_TOP_SYNTHON_GET(x)                   (((x) & TOP_TOP_SYNTHON_MASK) >> TOP_TOP_SYNTHON_LSB)
+#define TOP_TOP_SYNTHON_SET(x)                   (((x) << TOP_TOP_SYNTHON_LSB) & TOP_TOP_SYNTHON_MASK)
+#define TOP_TOP_RXON_MSB                         23
+#define TOP_TOP_RXON_LSB                         23
+#define TOP_TOP_RXON_MASK                        0x00800000
+#define TOP_TOP_RXON_GET(x)                      (((x) & TOP_TOP_RXON_MASK) >> TOP_TOP_RXON_LSB)
+#define TOP_TOP_RXON_SET(x)                      (((x) << TOP_TOP_RXON_LSB) & TOP_TOP_RXON_MASK)
+#define TOP_TOP_TXON_MSB                         22
+#define TOP_TOP_TXON_LSB                         22
+#define TOP_TOP_TXON_MASK                        0x00400000
+#define TOP_TOP_TXON_GET(x)                      (((x) & TOP_TOP_TXON_MASK) >> TOP_TOP_TXON_LSB)
+#define TOP_TOP_TXON_SET(x)                      (((x) << TOP_TOP_TXON_LSB) & TOP_TOP_TXON_MASK)
+#define TOP_TOP_PAON_MSB                         21
+#define TOP_TOP_PAON_LSB                         21
+#define TOP_TOP_PAON_MASK                        0x00200000
+#define TOP_TOP_PAON_GET(x)                      (((x) & TOP_TOP_PAON_MASK) >> TOP_TOP_PAON_LSB)
+#define TOP_TOP_PAON_SET(x)                      (((x) << TOP_TOP_PAON_LSB) & TOP_TOP_PAON_MASK)
+#define TOP_TOP_CALTX_MSB                        20
+#define TOP_TOP_CALTX_LSB                        20
+#define TOP_TOP_CALTX_MASK                       0x00100000
+#define TOP_TOP_CALTX_GET(x)                     (((x) & TOP_TOP_CALTX_MASK) >> TOP_TOP_CALTX_LSB)
+#define TOP_TOP_CALTX_SET(x)                     (((x) << TOP_TOP_CALTX_LSB) & TOP_TOP_CALTX_MASK)
+#define TOP_TOP_LOCALADDAC_MSB                   19
+#define TOP_TOP_LOCALADDAC_LSB                   19
+#define TOP_TOP_LOCALADDAC_MASK                  0x00080000
+#define TOP_TOP_LOCALADDAC_GET(x)                (((x) & TOP_TOP_LOCALADDAC_MASK) >> TOP_TOP_LOCALADDAC_LSB)
+#define TOP_TOP_LOCALADDAC_SET(x)                (((x) << TOP_TOP_LOCALADDAC_LSB) & TOP_TOP_LOCALADDAC_MASK)
+#define TOP_TOP_PWDPLL_MSB                       18
+#define TOP_TOP_PWDPLL_LSB                       18
+#define TOP_TOP_PWDPLL_MASK                      0x00040000
+#define TOP_TOP_PWDPLL_GET(x)                    (((x) & TOP_TOP_PWDPLL_MASK) >> TOP_TOP_PWDPLL_LSB)
+#define TOP_TOP_PWDPLL_SET(x)                    (((x) << TOP_TOP_PWDPLL_LSB) & TOP_TOP_PWDPLL_MASK)
+#define TOP_TOP_PWDADC_MSB                       17
+#define TOP_TOP_PWDADC_LSB                       17
+#define TOP_TOP_PWDADC_MASK                      0x00020000
+#define TOP_TOP_PWDADC_GET(x)                    (((x) & TOP_TOP_PWDADC_MASK) >> TOP_TOP_PWDADC_LSB)
+#define TOP_TOP_PWDADC_SET(x)                    (((x) << TOP_TOP_PWDADC_LSB) & TOP_TOP_PWDADC_MASK)
+#define TOP_TOP_PWDDAC_MSB                       16
+#define TOP_TOP_PWDDAC_LSB                       16
+#define TOP_TOP_PWDDAC_MASK                      0x00010000
+#define TOP_TOP_PWDDAC_GET(x)                    (((x) & TOP_TOP_PWDDAC_MASK) >> TOP_TOP_PWDDAC_LSB)
+#define TOP_TOP_PWDDAC_SET(x)                    (((x) << TOP_TOP_PWDDAC_LSB) & TOP_TOP_PWDDAC_MASK)
+#define TOP_TOP_LOCALXTAL_MSB                    15
+#define TOP_TOP_LOCALXTAL_LSB                    15
+#define TOP_TOP_LOCALXTAL_MASK                   0x00008000
+#define TOP_TOP_LOCALXTAL_GET(x)                 (((x) & TOP_TOP_LOCALXTAL_MASK) >> TOP_TOP_LOCALXTAL_LSB)
+#define TOP_TOP_LOCALXTAL_SET(x)                 (((x) << TOP_TOP_LOCALXTAL_LSB) & TOP_TOP_LOCALXTAL_MASK)
+#define TOP_TOP_PWDCLKIN_MSB                     14
+#define TOP_TOP_PWDCLKIN_LSB                     14
+#define TOP_TOP_PWDCLKIN_MASK                    0x00004000
+#define TOP_TOP_PWDCLKIN_GET(x)                  (((x) & TOP_TOP_PWDCLKIN_MASK) >> TOP_TOP_PWDCLKIN_LSB)
+#define TOP_TOP_PWDCLKIN_SET(x)                  (((x) << TOP_TOP_PWDCLKIN_LSB) & TOP_TOP_PWDCLKIN_MASK)
+#define TOP_TOP_OSCON_MSB                        13
+#define TOP_TOP_OSCON_LSB                        13
+#define TOP_TOP_OSCON_MASK                       0x00002000
+#define TOP_TOP_OSCON_GET(x)                     (((x) & TOP_TOP_OSCON_MASK) >> TOP_TOP_OSCON_LSB)
+#define TOP_TOP_OSCON_SET(x)                     (((x) << TOP_TOP_OSCON_LSB) & TOP_TOP_OSCON_MASK)
+#define TOP_TOP_SCLKEN_FORCE_MSB                 12
+#define TOP_TOP_SCLKEN_FORCE_LSB                 12
+#define TOP_TOP_SCLKEN_FORCE_MASK                0x00001000
+#define TOP_TOP_SCLKEN_FORCE_GET(x)              (((x) & TOP_TOP_SCLKEN_FORCE_MASK) >> TOP_TOP_SCLKEN_FORCE_LSB)
+#define TOP_TOP_SCLKEN_FORCE_SET(x)              (((x) << TOP_TOP_SCLKEN_FORCE_LSB) & TOP_TOP_SCLKEN_FORCE_MASK)
+#define TOP_TOP_SYNTHON_FORCE_MSB                11
+#define TOP_TOP_SYNTHON_FORCE_LSB                11
+#define TOP_TOP_SYNTHON_FORCE_MASK               0x00000800
+#define TOP_TOP_SYNTHON_FORCE_GET(x)             (((x) & TOP_TOP_SYNTHON_FORCE_MASK) >> TOP_TOP_SYNTHON_FORCE_LSB)
+#define TOP_TOP_SYNTHON_FORCE_SET(x)             (((x) << TOP_TOP_SYNTHON_FORCE_LSB) & TOP_TOP_SYNTHON_FORCE_MASK)
+#define TOP_TOP_PDBIAS_MSB                       10
+#define TOP_TOP_PDBIAS_LSB                       10
+#define TOP_TOP_PDBIAS_MASK                      0x00000400
+#define TOP_TOP_PDBIAS_GET(x)                    (((x) & TOP_TOP_PDBIAS_MASK) >> TOP_TOP_PDBIAS_LSB)
+#define TOP_TOP_PDBIAS_SET(x)                    (((x) << TOP_TOP_PDBIAS_LSB) & TOP_TOP_PDBIAS_MASK)
+#define TOP_TOP_DATAOUTSEL_MSB                   9
+#define TOP_TOP_DATAOUTSEL_LSB                   8
+#define TOP_TOP_DATAOUTSEL_MASK                  0x00000300
+#define TOP_TOP_DATAOUTSEL_GET(x)                (((x) & TOP_TOP_DATAOUTSEL_MASK) >> TOP_TOP_DATAOUTSEL_LSB)
+#define TOP_TOP_DATAOUTSEL_SET(x)                (((x) << TOP_TOP_DATAOUTSEL_LSB) & TOP_TOP_DATAOUTSEL_MASK)
+#define TOP_TOP_REVID_MSB                        7
+#define TOP_TOP_REVID_LSB                        5
+#define TOP_TOP_REVID_MASK                       0x000000e0
+#define TOP_TOP_REVID_GET(x)                     (((x) & TOP_TOP_REVID_MASK) >> TOP_TOP_REVID_LSB)
+#define TOP_TOP_REVID_SET(x)                     (((x) << TOP_TOP_REVID_LSB) & TOP_TOP_REVID_MASK)
+#define TOP_TOP_INT2PAD_MSB                      4
+#define TOP_TOP_INT2PAD_LSB                      4
+#define TOP_TOP_INT2PAD_MASK                     0x00000010
+#define TOP_TOP_INT2PAD_GET(x)                   (((x) & TOP_TOP_INT2PAD_MASK) >> TOP_TOP_INT2PAD_LSB)
+#define TOP_TOP_INT2PAD_SET(x)                   (((x) << TOP_TOP_INT2PAD_LSB) & TOP_TOP_INT2PAD_MASK)
+#define TOP_TOP_INTH2PAD_MSB                     3
+#define TOP_TOP_INTH2PAD_LSB                     3
+#define TOP_TOP_INTH2PAD_MASK                    0x00000008
+#define TOP_TOP_INTH2PAD_GET(x)                  (((x) & TOP_TOP_INTH2PAD_MASK) >> TOP_TOP_INTH2PAD_LSB)
+#define TOP_TOP_INTH2PAD_SET(x)                  (((x) << TOP_TOP_INTH2PAD_LSB) & TOP_TOP_INTH2PAD_MASK)
+#define TOP_TOP_PAD2GND_MSB                      2
+#define TOP_TOP_PAD2GND_LSB                      2
+#define TOP_TOP_PAD2GND_MASK                     0x00000004
+#define TOP_TOP_PAD2GND_GET(x)                   (((x) & TOP_TOP_PAD2GND_MASK) >> TOP_TOP_PAD2GND_LSB)
+#define TOP_TOP_PAD2GND_SET(x)                   (((x) << TOP_TOP_PAD2GND_LSB) & TOP_TOP_PAD2GND_MASK)
+#define TOP_TOP_INT2GND_MSB                      1
+#define TOP_TOP_INT2GND_LSB                      1
+#define TOP_TOP_INT2GND_MASK                     0x00000002
+#define TOP_TOP_INT2GND_GET(x)                   (((x) & TOP_TOP_INT2GND_MASK) >> TOP_TOP_INT2GND_LSB)
+#define TOP_TOP_INT2GND_SET(x)                   (((x) << TOP_TOP_INT2GND_LSB) & TOP_TOP_INT2GND_MASK)
+#define TOP_TOP_FORCE_XPAON_MSB                  0
+#define TOP_TOP_FORCE_XPAON_LSB                  0
+#define TOP_TOP_FORCE_XPAON_MASK                 0x00000001
+#define TOP_TOP_FORCE_XPAON_GET(x)               (((x) & TOP_TOP_FORCE_XPAON_MASK) >> TOP_TOP_FORCE_XPAON_LSB)
+#define TOP_TOP_FORCE_XPAON_SET(x)               (((x) << TOP_TOP_FORCE_XPAON_LSB) & TOP_TOP_FORCE_XPAON_MASK)
+
+#define BIAS_BIAS_SEL_ADDRESS                    0x00000038
+#define BIAS_BIAS_SEL_OFFSET                     0x00000038
+#define BIAS_BIAS_SEL_PADON_MSB                  31
+#define BIAS_BIAS_SEL_PADON_LSB                  31
+#define BIAS_BIAS_SEL_PADON_MASK                 0x80000000
+#define BIAS_BIAS_SEL_PADON_GET(x)               (((x) & BIAS_BIAS_SEL_PADON_MASK) >> BIAS_BIAS_SEL_PADON_LSB)
+#define BIAS_BIAS_SEL_PADON_SET(x)               (((x) << BIAS_BIAS_SEL_PADON_LSB) & BIAS_BIAS_SEL_PADON_MASK)
+#define BIAS_BIAS_SEL_SEL_BIAS_MSB               30
+#define BIAS_BIAS_SEL_SEL_BIAS_LSB               25
+#define BIAS_BIAS_SEL_SEL_BIAS_MASK              0x7e000000
+#define BIAS_BIAS_SEL_SEL_BIAS_GET(x)            (((x) & BIAS_BIAS_SEL_SEL_BIAS_MASK) >> BIAS_BIAS_SEL_SEL_BIAS_LSB)
+#define BIAS_BIAS_SEL_SEL_BIAS_SET(x)            (((x) << BIAS_BIAS_SEL_SEL_BIAS_LSB) & BIAS_BIAS_SEL_SEL_BIAS_MASK)
+#define BIAS_BIAS_SEL_SEL_SPARE_MSB              24
+#define BIAS_BIAS_SEL_SEL_SPARE_LSB              21
+#define BIAS_BIAS_SEL_SEL_SPARE_MASK             0x01e00000
+#define BIAS_BIAS_SEL_SEL_SPARE_GET(x)           (((x) & BIAS_BIAS_SEL_SEL_SPARE_MASK) >> BIAS_BIAS_SEL_SEL_SPARE_LSB)
+#define BIAS_BIAS_SEL_SEL_SPARE_SET(x)           (((x) << BIAS_BIAS_SEL_SEL_SPARE_LSB) & BIAS_BIAS_SEL_SEL_SPARE_MASK)
+#define BIAS_BIAS_SEL_SPARE_MSB                  20
+#define BIAS_BIAS_SEL_SPARE_LSB                  20
+#define BIAS_BIAS_SEL_SPARE_MASK                 0x00100000
+#define BIAS_BIAS_SEL_SPARE_GET(x)               (((x) & BIAS_BIAS_SEL_SPARE_MASK) >> BIAS_BIAS_SEL_SPARE_LSB)
+#define BIAS_BIAS_SEL_SPARE_SET(x)               (((x) << BIAS_BIAS_SEL_SPARE_LSB) & BIAS_BIAS_SEL_SPARE_MASK)
+#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MSB   19
+#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB   17
+#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK  0x000e0000
+#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK) >> BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB)
+#define BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_LSB) & BIAS_BIAS_SEL_PWD_ICREFBUFBIAS12P5_MASK)
+#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MSB    16
+#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB    16
+#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK   0x00010000
+#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK) >> BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB)
+#define BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_LSB) & BIAS_BIAS_SEL_PWD_IRDACREGREF12P5_MASK)
+#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MSB 15
+#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB 15
+#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK 0x00008000
+#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_GET(x) (((x) & BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK) >> BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB)
+#define BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_SET(x) (((x) << BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_LSB) & BIAS_BIAS_SEL_PWD_IRREFMASTERBIAS12P5_MASK)
+#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MSB   14
+#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB   14
+#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK  0x00004000
+#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_GET(x) (((x) & BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK) >> BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_SET(x) (((x) << BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_LSB) & BIAS_BIAS_SEL_PWD_ICREFOPAMPBIAS25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICCPLL25_MSB           13
+#define BIAS_BIAS_SEL_PWD_ICCPLL25_LSB           13
+#define BIAS_BIAS_SEL_PWD_ICCPLL25_MASK          0x00002000
+#define BIAS_BIAS_SEL_PWD_ICCPLL25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICCPLL25_MASK) >> BIAS_BIAS_SEL_PWD_ICCPLL25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICCPLL25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICCPLL25_LSB) & BIAS_BIAS_SEL_PWD_ICCPLL25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MSB       12
+#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB       10
+#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK      0x00001c00
+#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_GET(x)    (((x) & BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK) >> BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_SET(x)    (((x) << BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_LSB) & BIAS_BIAS_SEL_PWD_ICCOMPBIAS25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICXTAL25_MSB           9
+#define BIAS_BIAS_SEL_PWD_ICXTAL25_LSB           7
+#define BIAS_BIAS_SEL_PWD_ICXTAL25_MASK          0x00000380
+#define BIAS_BIAS_SEL_PWD_ICXTAL25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICXTAL25_MASK) >> BIAS_BIAS_SEL_PWD_ICXTAL25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICXTAL25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICXTAL25_LSB) & BIAS_BIAS_SEL_PWD_ICXTAL25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICTSENS25_MSB          6
+#define BIAS_BIAS_SEL_PWD_ICTSENS25_LSB          4
+#define BIAS_BIAS_SEL_PWD_ICTSENS25_MASK         0x00000070
+#define BIAS_BIAS_SEL_PWD_ICTSENS25_GET(x)       (((x) & BIAS_BIAS_SEL_PWD_ICTSENS25_MASK) >> BIAS_BIAS_SEL_PWD_ICTSENS25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICTSENS25_SET(x)       (((x) << BIAS_BIAS_SEL_PWD_ICTSENS25_LSB) & BIAS_BIAS_SEL_PWD_ICTSENS25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICTXPC25_MSB           3
+#define BIAS_BIAS_SEL_PWD_ICTXPC25_LSB           1
+#define BIAS_BIAS_SEL_PWD_ICTXPC25_MASK          0x0000000e
+#define BIAS_BIAS_SEL_PWD_ICTXPC25_GET(x)        (((x) & BIAS_BIAS_SEL_PWD_ICTXPC25_MASK) >> BIAS_BIAS_SEL_PWD_ICTXPC25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICTXPC25_SET(x)        (((x) << BIAS_BIAS_SEL_PWD_ICTXPC25_LSB) & BIAS_BIAS_SEL_PWD_ICTXPC25_MASK)
+#define BIAS_BIAS_SEL_PWD_ICLDO25_MSB            0
+#define BIAS_BIAS_SEL_PWD_ICLDO25_LSB            0
+#define BIAS_BIAS_SEL_PWD_ICLDO25_MASK           0x00000001
+#define BIAS_BIAS_SEL_PWD_ICLDO25_GET(x)         (((x) & BIAS_BIAS_SEL_PWD_ICLDO25_MASK) >> BIAS_BIAS_SEL_PWD_ICLDO25_LSB)
+#define BIAS_BIAS_SEL_PWD_ICLDO25_SET(x)         (((x) << BIAS_BIAS_SEL_PWD_ICLDO25_LSB) & BIAS_BIAS_SEL_PWD_ICLDO25_MASK)
+
+#define BIAS_BIAS1_ADDRESS                       0x0000003c
+#define BIAS_BIAS1_OFFSET                        0x0000003c
+#define BIAS_BIAS1_PWD_ICDAC2BB25_MSB            31
+#define BIAS_BIAS1_PWD_ICDAC2BB25_LSB            29
+#define BIAS_BIAS1_PWD_ICDAC2BB25_MASK           0xe0000000
+#define BIAS_BIAS1_PWD_ICDAC2BB25_GET(x)         (((x) & BIAS_BIAS1_PWD_ICDAC2BB25_MASK) >> BIAS_BIAS1_PWD_ICDAC2BB25_LSB)
+#define BIAS_BIAS1_PWD_ICDAC2BB25_SET(x)         (((x) << BIAS_BIAS1_PWD_ICDAC2BB25_LSB) & BIAS_BIAS1_PWD_ICDAC2BB25_MASK)
+#define BIAS_BIAS1_PWD_IC2GVGM25_MSB             28
+#define BIAS_BIAS1_PWD_IC2GVGM25_LSB             26
+#define BIAS_BIAS1_PWD_IC2GVGM25_MASK            0x1c000000
+#define BIAS_BIAS1_PWD_IC2GVGM25_GET(x)          (((x) & BIAS_BIAS1_PWD_IC2GVGM25_MASK) >> BIAS_BIAS1_PWD_IC2GVGM25_LSB)
+#define BIAS_BIAS1_PWD_IC2GVGM25_SET(x)          (((x) << BIAS_BIAS1_PWD_IC2GVGM25_LSB) & BIAS_BIAS1_PWD_IC2GVGM25_MASK)
+#define BIAS_BIAS1_PWD_IC2GRFFE25_MSB            25
+#define BIAS_BIAS1_PWD_IC2GRFFE25_LSB            23
+#define BIAS_BIAS1_PWD_IC2GRFFE25_MASK           0x03800000
+#define BIAS_BIAS1_PWD_IC2GRFFE25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC2GRFFE25_MASK) >> BIAS_BIAS1_PWD_IC2GRFFE25_LSB)
+#define BIAS_BIAS1_PWD_IC2GRFFE25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC2GRFFE25_LSB) & BIAS_BIAS1_PWD_IC2GRFFE25_MASK)
+#define BIAS_BIAS1_PWD_IC2GLOREG25_MSB           22
+#define BIAS_BIAS1_PWD_IC2GLOREG25_LSB           20
+#define BIAS_BIAS1_PWD_IC2GLOREG25_MASK          0x00700000
+#define BIAS_BIAS1_PWD_IC2GLOREG25_GET(x)        (((x) & BIAS_BIAS1_PWD_IC2GLOREG25_MASK) >> BIAS_BIAS1_PWD_IC2GLOREG25_LSB)
+#define BIAS_BIAS1_PWD_IC2GLOREG25_SET(x)        (((x) << BIAS_BIAS1_PWD_IC2GLOREG25_LSB) & BIAS_BIAS1_PWD_IC2GLOREG25_MASK)
+#define BIAS_BIAS1_PWD_IC2GLNAREG25_MSB          19
+#define BIAS_BIAS1_PWD_IC2GLNAREG25_LSB          17
+#define BIAS_BIAS1_PWD_IC2GLNAREG25_MASK         0x000e0000
+#define BIAS_BIAS1_PWD_IC2GLNAREG25_GET(x)       (((x) & BIAS_BIAS1_PWD_IC2GLNAREG25_MASK) >> BIAS_BIAS1_PWD_IC2GLNAREG25_LSB)
+#define BIAS_BIAS1_PWD_IC2GLNAREG25_SET(x)       (((x) << BIAS_BIAS1_PWD_IC2GLNAREG25_LSB) & BIAS_BIAS1_PWD_IC2GLNAREG25_MASK)
+#define BIAS_BIAS1_PWD_ICDETECTORB25_MSB         16
+#define BIAS_BIAS1_PWD_ICDETECTORB25_LSB         16
+#define BIAS_BIAS1_PWD_ICDETECTORB25_MASK        0x00010000
+#define BIAS_BIAS1_PWD_ICDETECTORB25_GET(x)      (((x) & BIAS_BIAS1_PWD_ICDETECTORB25_MASK) >> BIAS_BIAS1_PWD_ICDETECTORB25_LSB)
+#define BIAS_BIAS1_PWD_ICDETECTORB25_SET(x)      (((x) << BIAS_BIAS1_PWD_ICDETECTORB25_LSB) & BIAS_BIAS1_PWD_ICDETECTORB25_MASK)
+#define BIAS_BIAS1_PWD_ICDETECTORA25_MSB         15
+#define BIAS_BIAS1_PWD_ICDETECTORA25_LSB         15
+#define BIAS_BIAS1_PWD_ICDETECTORA25_MASK        0x00008000
+#define BIAS_BIAS1_PWD_ICDETECTORA25_GET(x)      (((x) & BIAS_BIAS1_PWD_ICDETECTORA25_MASK) >> BIAS_BIAS1_PWD_ICDETECTORA25_LSB)
+#define BIAS_BIAS1_PWD_ICDETECTORA25_SET(x)      (((x) << BIAS_BIAS1_PWD_ICDETECTORA25_LSB) & BIAS_BIAS1_PWD_ICDETECTORA25_MASK)
+#define BIAS_BIAS1_PWD_IC5GRXRF25_MSB            14
+#define BIAS_BIAS1_PWD_IC5GRXRF25_LSB            14
+#define BIAS_BIAS1_PWD_IC5GRXRF25_MASK           0x00004000
+#define BIAS_BIAS1_PWD_IC5GRXRF25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GRXRF25_MASK) >> BIAS_BIAS1_PWD_IC5GRXRF25_LSB)
+#define BIAS_BIAS1_PWD_IC5GRXRF25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GRXRF25_LSB) & BIAS_BIAS1_PWD_IC5GRXRF25_MASK)
+#define BIAS_BIAS1_PWD_IC5GTXPA25_MSB            13
+#define BIAS_BIAS1_PWD_IC5GTXPA25_LSB            11
+#define BIAS_BIAS1_PWD_IC5GTXPA25_MASK           0x00003800
+#define BIAS_BIAS1_PWD_IC5GTXPA25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GTXPA25_MASK) >> BIAS_BIAS1_PWD_IC5GTXPA25_LSB)
+#define BIAS_BIAS1_PWD_IC5GTXPA25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GTXPA25_LSB) & BIAS_BIAS1_PWD_IC5GTXPA25_MASK)
+#define BIAS_BIAS1_PWD_IC5GTXBUF25_MSB           10
+#define BIAS_BIAS1_PWD_IC5GTXBUF25_LSB           8
+#define BIAS_BIAS1_PWD_IC5GTXBUF25_MASK          0x00000700
+#define BIAS_BIAS1_PWD_IC5GTXBUF25_GET(x)        (((x) & BIAS_BIAS1_PWD_IC5GTXBUF25_MASK) >> BIAS_BIAS1_PWD_IC5GTXBUF25_LSB)
+#define BIAS_BIAS1_PWD_IC5GTXBUF25_SET(x)        (((x) << BIAS_BIAS1_PWD_IC5GTXBUF25_LSB) & BIAS_BIAS1_PWD_IC5GTXBUF25_MASK)
+#define BIAS_BIAS1_PWD_IC5GQB25_MSB              7
+#define BIAS_BIAS1_PWD_IC5GQB25_LSB              5
+#define BIAS_BIAS1_PWD_IC5GQB25_MASK             0x000000e0
+#define BIAS_BIAS1_PWD_IC5GQB25_GET(x)           (((x) & BIAS_BIAS1_PWD_IC5GQB25_MASK) >> BIAS_BIAS1_PWD_IC5GQB25_LSB)
+#define BIAS_BIAS1_PWD_IC5GQB25_SET(x)           (((x) << BIAS_BIAS1_PWD_IC5GQB25_LSB) & BIAS_BIAS1_PWD_IC5GQB25_MASK)
+#define BIAS_BIAS1_PWD_IC5GMIXQ25_MSB            4
+#define BIAS_BIAS1_PWD_IC5GMIXQ25_LSB            2
+#define BIAS_BIAS1_PWD_IC5GMIXQ25_MASK           0x0000001c
+#define BIAS_BIAS1_PWD_IC5GMIXQ25_GET(x)         (((x) & BIAS_BIAS1_PWD_IC5GMIXQ25_MASK) >> BIAS_BIAS1_PWD_IC5GMIXQ25_LSB)
+#define BIAS_BIAS1_PWD_IC5GMIXQ25_SET(x)         (((x) << BIAS_BIAS1_PWD_IC5GMIXQ25_LSB) & BIAS_BIAS1_PWD_IC5GMIXQ25_MASK)
+#define BIAS_BIAS1_SPARE_MSB                     1
+#define BIAS_BIAS1_SPARE_LSB                     0
+#define BIAS_BIAS1_SPARE_MASK                    0x00000003
+#define BIAS_BIAS1_SPARE_GET(x)                  (((x) & BIAS_BIAS1_SPARE_MASK) >> BIAS_BIAS1_SPARE_LSB)
+#define BIAS_BIAS1_SPARE_SET(x)                  (((x) << BIAS_BIAS1_SPARE_LSB) & BIAS_BIAS1_SPARE_MASK)
+
+#define BIAS_BIAS2_ADDRESS                       0x00000040
+#define BIAS_BIAS2_OFFSET                        0x00000040
+#define BIAS_BIAS2_PWD_IC5GMIXI25_MSB            31
+#define BIAS_BIAS2_PWD_IC5GMIXI25_LSB            29
+#define BIAS_BIAS2_PWD_IC5GMIXI25_MASK           0xe0000000
+#define BIAS_BIAS2_PWD_IC5GMIXI25_GET(x)         (((x) & BIAS_BIAS2_PWD_IC5GMIXI25_MASK) >> BIAS_BIAS2_PWD_IC5GMIXI25_LSB)
+#define BIAS_BIAS2_PWD_IC5GMIXI25_SET(x)         (((x) << BIAS_BIAS2_PWD_IC5GMIXI25_LSB) & BIAS_BIAS2_PWD_IC5GMIXI25_MASK)
+#define BIAS_BIAS2_PWD_IC5GDIV25_MSB             28
+#define BIAS_BIAS2_PWD_IC5GDIV25_LSB             26
+#define BIAS_BIAS2_PWD_IC5GDIV25_MASK            0x1c000000
+#define BIAS_BIAS2_PWD_IC5GDIV25_GET(x)          (((x) & BIAS_BIAS2_PWD_IC5GDIV25_MASK) >> BIAS_BIAS2_PWD_IC5GDIV25_LSB)
+#define BIAS_BIAS2_PWD_IC5GDIV25_SET(x)          (((x) << BIAS_BIAS2_PWD_IC5GDIV25_LSB) & BIAS_BIAS2_PWD_IC5GDIV25_MASK)
+#define BIAS_BIAS2_PWD_IC5GLOREG25_MSB           25
+#define BIAS_BIAS2_PWD_IC5GLOREG25_LSB           23
+#define BIAS_BIAS2_PWD_IC5GLOREG25_MASK          0x03800000
+#define BIAS_BIAS2_PWD_IC5GLOREG25_GET(x)        (((x) & BIAS_BIAS2_PWD_IC5GLOREG25_MASK) >> BIAS_BIAS2_PWD_IC5GLOREG25_LSB)
+#define BIAS_BIAS2_PWD_IC5GLOREG25_SET(x)        (((x) << BIAS_BIAS2_PWD_IC5GLOREG25_LSB) & BIAS_BIAS2_PWD_IC5GLOREG25_MASK)
+#define BIAS_BIAS2_PWD_IRPLL25_MSB               22
+#define BIAS_BIAS2_PWD_IRPLL25_LSB               22
+#define BIAS_BIAS2_PWD_IRPLL25_MASK              0x00400000
+#define BIAS_BIAS2_PWD_IRPLL25_GET(x)            (((x) & BIAS_BIAS2_PWD_IRPLL25_MASK) >> BIAS_BIAS2_PWD_IRPLL25_LSB)
+#define BIAS_BIAS2_PWD_IRPLL25_SET(x)            (((x) << BIAS_BIAS2_PWD_IRPLL25_LSB) & BIAS_BIAS2_PWD_IRPLL25_MASK)
+#define BIAS_BIAS2_PWD_IRXTAL25_MSB              21
+#define BIAS_BIAS2_PWD_IRXTAL25_LSB              19
+#define BIAS_BIAS2_PWD_IRXTAL25_MASK             0x00380000
+#define BIAS_BIAS2_PWD_IRXTAL25_GET(x)           (((x) & BIAS_BIAS2_PWD_IRXTAL25_MASK) >> BIAS_BIAS2_PWD_IRXTAL25_LSB)
+#define BIAS_BIAS2_PWD_IRXTAL25_SET(x)           (((x) << BIAS_BIAS2_PWD_IRXTAL25_LSB) & BIAS_BIAS2_PWD_IRXTAL25_MASK)
+#define BIAS_BIAS2_PWD_IRTSENS25_MSB             18
+#define BIAS_BIAS2_PWD_IRTSENS25_LSB             16
+#define BIAS_BIAS2_PWD_IRTSENS25_MASK            0x00070000
+#define BIAS_BIAS2_PWD_IRTSENS25_GET(x)          (((x) & BIAS_BIAS2_PWD_IRTSENS25_MASK) >> BIAS_BIAS2_PWD_IRTSENS25_LSB)
+#define BIAS_BIAS2_PWD_IRTSENS25_SET(x)          (((x) << BIAS_BIAS2_PWD_IRTSENS25_LSB) & BIAS_BIAS2_PWD_IRTSENS25_MASK)
+#define BIAS_BIAS2_PWD_IRTXPC25_MSB              15
+#define BIAS_BIAS2_PWD_IRTXPC25_LSB              13
+#define BIAS_BIAS2_PWD_IRTXPC25_MASK             0x0000e000
+#define BIAS_BIAS2_PWD_IRTXPC25_GET(x)           (((x) & BIAS_BIAS2_PWD_IRTXPC25_MASK) >> BIAS_BIAS2_PWD_IRTXPC25_LSB)
+#define BIAS_BIAS2_PWD_IRTXPC25_SET(x)           (((x) << BIAS_BIAS2_PWD_IRTXPC25_LSB) & BIAS_BIAS2_PWD_IRTXPC25_MASK)
+#define BIAS_BIAS2_PWD_IRLDO25_MSB               12
+#define BIAS_BIAS2_PWD_IRLDO25_LSB               12
+#define BIAS_BIAS2_PWD_IRLDO25_MASK              0x00001000
+#define BIAS_BIAS2_PWD_IRLDO25_GET(x)            (((x) & BIAS_BIAS2_PWD_IRLDO25_MASK) >> BIAS_BIAS2_PWD_IRLDO25_LSB)
+#define BIAS_BIAS2_PWD_IRLDO25_SET(x)            (((x) << BIAS_BIAS2_PWD_IRLDO25_LSB) & BIAS_BIAS2_PWD_IRLDO25_MASK)
+#define BIAS_BIAS2_PWD_IR2GTXMIX25_MSB           11
+#define BIAS_BIAS2_PWD_IR2GTXMIX25_LSB           9
+#define BIAS_BIAS2_PWD_IR2GTXMIX25_MASK          0x00000e00
+#define BIAS_BIAS2_PWD_IR2GTXMIX25_GET(x)        (((x) & BIAS_BIAS2_PWD_IR2GTXMIX25_MASK) >> BIAS_BIAS2_PWD_IR2GTXMIX25_LSB)
+#define BIAS_BIAS2_PWD_IR2GTXMIX25_SET(x)        (((x) << BIAS_BIAS2_PWD_IR2GTXMIX25_LSB) & BIAS_BIAS2_PWD_IR2GTXMIX25_MASK)
+#define BIAS_BIAS2_PWD_IR2GLOREG25_MSB           8
+#define BIAS_BIAS2_PWD_IR2GLOREG25_LSB           6
+#define BIAS_BIAS2_PWD_IR2GLOREG25_MASK          0x000001c0
+#define BIAS_BIAS2_PWD_IR2GLOREG25_GET(x)        (((x) & BIAS_BIAS2_PWD_IR2GLOREG25_MASK) >> BIAS_BIAS2_PWD_IR2GLOREG25_LSB)
+#define BIAS_BIAS2_PWD_IR2GLOREG25_SET(x)        (((x) << BIAS_BIAS2_PWD_IR2GLOREG25_LSB) & BIAS_BIAS2_PWD_IR2GLOREG25_MASK)
+#define BIAS_BIAS2_PWD_IR2GLNAREG25_MSB          5
+#define BIAS_BIAS2_PWD_IR2GLNAREG25_LSB          3
+#define BIAS_BIAS2_PWD_IR2GLNAREG25_MASK         0x00000038
+#define BIAS_BIAS2_PWD_IR2GLNAREG25_GET(x)       (((x) & BIAS_BIAS2_PWD_IR2GLNAREG25_MASK) >> BIAS_BIAS2_PWD_IR2GLNAREG25_LSB)
+#define BIAS_BIAS2_PWD_IR2GLNAREG25_SET(x)       (((x) << BIAS_BIAS2_PWD_IR2GLNAREG25_LSB) & BIAS_BIAS2_PWD_IR2GLNAREG25_MASK)
+#define BIAS_BIAS2_PWD_IR5GRFVREF2525_MSB        2
+#define BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB        0
+#define BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK       0x00000007
+#define BIAS_BIAS2_PWD_IR5GRFVREF2525_GET(x)     (((x) & BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK) >> BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB)
+#define BIAS_BIAS2_PWD_IR5GRFVREF2525_SET(x)     (((x) << BIAS_BIAS2_PWD_IR5GRFVREF2525_LSB) & BIAS_BIAS2_PWD_IR5GRFVREF2525_MASK)
+
+#define BIAS_BIAS3_ADDRESS                       0x00000044
+#define BIAS_BIAS3_OFFSET                        0x00000044
+#define BIAS_BIAS3_PWD_IR5GTXMIX25_MSB           31
+#define BIAS_BIAS3_PWD_IR5GTXMIX25_LSB           29
+#define BIAS_BIAS3_PWD_IR5GTXMIX25_MASK          0xe0000000
+#define BIAS_BIAS3_PWD_IR5GTXMIX25_GET(x)        (((x) & BIAS_BIAS3_PWD_IR5GTXMIX25_MASK) >> BIAS_BIAS3_PWD_IR5GTXMIX25_LSB)
+#define BIAS_BIAS3_PWD_IR5GTXMIX25_SET(x)        (((x) << BIAS_BIAS3_PWD_IR5GTXMIX25_LSB) & BIAS_BIAS3_PWD_IR5GTXMIX25_MASK)
+#define BIAS_BIAS3_PWD_IR5GAGC25_MSB             28
+#define BIAS_BIAS3_PWD_IR5GAGC25_LSB             26
+#define BIAS_BIAS3_PWD_IR5GAGC25_MASK            0x1c000000
+#define BIAS_BIAS3_PWD_IR5GAGC25_GET(x)          (((x) & BIAS_BIAS3_PWD_IR5GAGC25_MASK) >> BIAS_BIAS3_PWD_IR5GAGC25_LSB)
+#define BIAS_BIAS3_PWD_IR5GAGC25_SET(x)          (((x) << BIAS_BIAS3_PWD_IR5GAGC25_LSB) & BIAS_BIAS3_PWD_IR5GAGC25_MASK)
+#define BIAS_BIAS3_PWD_ICDAC50_MSB               25
+#define BIAS_BIAS3_PWD_ICDAC50_LSB               23
+#define BIAS_BIAS3_PWD_ICDAC50_MASK              0x03800000
+#define BIAS_BIAS3_PWD_ICDAC50_GET(x)            (((x) & BIAS_BIAS3_PWD_ICDAC50_MASK) >> BIAS_BIAS3_PWD_ICDAC50_LSB)
+#define BIAS_BIAS3_PWD_ICDAC50_SET(x)            (((x) << BIAS_BIAS3_PWD_ICDAC50_LSB) & BIAS_BIAS3_PWD_ICDAC50_MASK)
+#define BIAS_BIAS3_PWD_ICSYNTH50_MSB             22
+#define BIAS_BIAS3_PWD_ICSYNTH50_LSB             22
+#define BIAS_BIAS3_PWD_ICSYNTH50_MASK            0x00400000
+#define BIAS_BIAS3_PWD_ICSYNTH50_GET(x)          (((x) & BIAS_BIAS3_PWD_ICSYNTH50_MASK) >> BIAS_BIAS3_PWD_ICSYNTH50_LSB)
+#define BIAS_BIAS3_PWD_ICSYNTH50_SET(x)          (((x) << BIAS_BIAS3_PWD_ICSYNTH50_LSB) & BIAS_BIAS3_PWD_ICSYNTH50_MASK)
+#define BIAS_BIAS3_PWD_ICBB50_MSB                21
+#define BIAS_BIAS3_PWD_ICBB50_LSB                21
+#define BIAS_BIAS3_PWD_ICBB50_MASK               0x00200000
+#define BIAS_BIAS3_PWD_ICBB50_GET(x)             (((x) & BIAS_BIAS3_PWD_ICBB50_MASK) >> BIAS_BIAS3_PWD_ICBB50_LSB)
+#define BIAS_BIAS3_PWD_ICBB50_SET(x)             (((x) << BIAS_BIAS3_PWD_ICBB50_LSB) & BIAS_BIAS3_PWD_ICBB50_MASK)
+#define BIAS_BIAS3_PWD_IC2GDIV50_MSB             20
+#define BIAS_BIAS3_PWD_IC2GDIV50_LSB             18
+#define BIAS_BIAS3_PWD_IC2GDIV50_MASK            0x001c0000
+#define BIAS_BIAS3_PWD_IC2GDIV50_GET(x)          (((x) & BIAS_BIAS3_PWD_IC2GDIV50_MASK) >> BIAS_BIAS3_PWD_IC2GDIV50_LSB)
+#define BIAS_BIAS3_PWD_IC2GDIV50_SET(x)          (((x) << BIAS_BIAS3_PWD_IC2GDIV50_LSB) & BIAS_BIAS3_PWD_IC2GDIV50_MASK)
+#define BIAS_BIAS3_PWD_IRSYNTH50_MSB             17
+#define BIAS_BIAS3_PWD_IRSYNTH50_LSB             17
+#define BIAS_BIAS3_PWD_IRSYNTH50_MASK            0x00020000
+#define BIAS_BIAS3_PWD_IRSYNTH50_GET(x)          (((x) & BIAS_BIAS3_PWD_IRSYNTH50_MASK) >> BIAS_BIAS3_PWD_IRSYNTH50_LSB)
+#define BIAS_BIAS3_PWD_IRSYNTH50_SET(x)          (((x) << BIAS_BIAS3_PWD_IRSYNTH50_LSB) & BIAS_BIAS3_PWD_IRSYNTH50_MASK)
+#define BIAS_BIAS3_PWD_IRBB50_MSB                16
+#define BIAS_BIAS3_PWD_IRBB50_LSB                16
+#define BIAS_BIAS3_PWD_IRBB50_MASK               0x00010000
+#define BIAS_BIAS3_PWD_IRBB50_GET(x)             (((x) & BIAS_BIAS3_PWD_IRBB50_MASK) >> BIAS_BIAS3_PWD_IRBB50_LSB)
+#define BIAS_BIAS3_PWD_IRBB50_SET(x)             (((x) << BIAS_BIAS3_PWD_IRBB50_LSB) & BIAS_BIAS3_PWD_IRBB50_MASK)
+#define BIAS_BIAS3_PWD_IC25SPARE1_MSB            15
+#define BIAS_BIAS3_PWD_IC25SPARE1_LSB            13
+#define BIAS_BIAS3_PWD_IC25SPARE1_MASK           0x0000e000
+#define BIAS_BIAS3_PWD_IC25SPARE1_GET(x)         (((x) & BIAS_BIAS3_PWD_IC25SPARE1_MASK) >> BIAS_BIAS3_PWD_IC25SPARE1_LSB)
+#define BIAS_BIAS3_PWD_IC25SPARE1_SET(x)         (((x) << BIAS_BIAS3_PWD_IC25SPARE1_LSB) & BIAS_BIAS3_PWD_IC25SPARE1_MASK)
+#define BIAS_BIAS3_PWD_IC25SPARE2_MSB            12
+#define BIAS_BIAS3_PWD_IC25SPARE2_LSB            10
+#define BIAS_BIAS3_PWD_IC25SPARE2_MASK           0x00001c00
+#define BIAS_BIAS3_PWD_IC25SPARE2_GET(x)         (((x) & BIAS_BIAS3_PWD_IC25SPARE2_MASK) >> BIAS_BIAS3_PWD_IC25SPARE2_LSB)
+#define BIAS_BIAS3_PWD_IC25SPARE2_SET(x)         (((x) << BIAS_BIAS3_PWD_IC25SPARE2_LSB) & BIAS_BIAS3_PWD_IC25SPARE2_MASK)
+#define BIAS_BIAS3_PWD_IR25SPARE1_MSB            9
+#define BIAS_BIAS3_PWD_IR25SPARE1_LSB            7
+#define BIAS_BIAS3_PWD_IR25SPARE1_MASK           0x00000380
+#define BIAS_BIAS3_PWD_IR25SPARE1_GET(x)         (((x) & BIAS_BIAS3_PWD_IR25SPARE1_MASK) >> BIAS_BIAS3_PWD_IR25SPARE1_LSB)
+#define BIAS_BIAS3_PWD_IR25SPARE1_SET(x)         (((x) << BIAS_BIAS3_PWD_IR25SPARE1_LSB) & BIAS_BIAS3_PWD_IR25SPARE1_MASK)
+#define BIAS_BIAS3_PWD_IR25SPARE2_MSB            6
+#define BIAS_BIAS3_PWD_IR25SPARE2_LSB            4
+#define BIAS_BIAS3_PWD_IR25SPARE2_MASK           0x00000070
+#define BIAS_BIAS3_PWD_IR25SPARE2_GET(x)         (((x) & BIAS_BIAS3_PWD_IR25SPARE2_MASK) >> BIAS_BIAS3_PWD_IR25SPARE2_LSB)
+#define BIAS_BIAS3_PWD_IR25SPARE2_SET(x)         (((x) << BIAS_BIAS3_PWD_IR25SPARE2_LSB) & BIAS_BIAS3_PWD_IR25SPARE2_MASK)
+#define BIAS_BIAS3_PWD_ICDACREG12P5_MSB          3
+#define BIAS_BIAS3_PWD_ICDACREG12P5_LSB          1
+#define BIAS_BIAS3_PWD_ICDACREG12P5_MASK         0x0000000e
+#define BIAS_BIAS3_PWD_ICDACREG12P5_GET(x)       (((x) & BIAS_BIAS3_PWD_ICDACREG12P5_MASK) >> BIAS_BIAS3_PWD_ICDACREG12P5_LSB)
+#define BIAS_BIAS3_PWD_ICDACREG12P5_SET(x)       (((x) << BIAS_BIAS3_PWD_ICDACREG12P5_LSB) & BIAS_BIAS3_PWD_ICDACREG12P5_MASK)
+#define BIAS_BIAS3_SPARE_MSB                     0
+#define BIAS_BIAS3_SPARE_LSB                     0
+#define BIAS_BIAS3_SPARE_MASK                    0x00000001
+#define BIAS_BIAS3_SPARE_GET(x)                  (((x) & BIAS_BIAS3_SPARE_MASK) >> BIAS_BIAS3_SPARE_LSB)
+#define BIAS_BIAS3_SPARE_SET(x)                  (((x) << BIAS_BIAS3_SPARE_LSB) & BIAS_BIAS3_SPARE_MASK)
+
+#define TXPC_TXPC_ADDRESS                        0x00000048
+#define TXPC_TXPC_OFFSET                         0x00000048
+#define TXPC_TXPC_SELINTPD_MSB                   31
+#define TXPC_TXPC_SELINTPD_LSB                   31
+#define TXPC_TXPC_SELINTPD_MASK                  0x80000000
+#define TXPC_TXPC_SELINTPD_GET(x)                (((x) & TXPC_TXPC_SELINTPD_MASK) >> TXPC_TXPC_SELINTPD_LSB)
+#define TXPC_TXPC_SELINTPD_SET(x)                (((x) << TXPC_TXPC_SELINTPD_LSB) & TXPC_TXPC_SELINTPD_MASK)
+#define TXPC_TXPC_TEST_MSB                       30
+#define TXPC_TXPC_TEST_LSB                       30
+#define TXPC_TXPC_TEST_MASK                      0x40000000
+#define TXPC_TXPC_TEST_GET(x)                    (((x) & TXPC_TXPC_TEST_MASK) >> TXPC_TXPC_TEST_LSB)
+#define TXPC_TXPC_TEST_SET(x)                    (((x) << TXPC_TXPC_TEST_LSB) & TXPC_TXPC_TEST_MASK)
+#define TXPC_TXPC_TESTGAIN_MSB                   29
+#define TXPC_TXPC_TESTGAIN_LSB                   28
+#define TXPC_TXPC_TESTGAIN_MASK                  0x30000000
+#define TXPC_TXPC_TESTGAIN_GET(x)                (((x) & TXPC_TXPC_TESTGAIN_MASK) >> TXPC_TXPC_TESTGAIN_LSB)
+#define TXPC_TXPC_TESTGAIN_SET(x)                (((x) << TXPC_TXPC_TESTGAIN_LSB) & TXPC_TXPC_TESTGAIN_MASK)
+#define TXPC_TXPC_TESTDAC_MSB                    27
+#define TXPC_TXPC_TESTDAC_LSB                    22
+#define TXPC_TXPC_TESTDAC_MASK                   0x0fc00000
+#define TXPC_TXPC_TESTDAC_GET(x)                 (((x) & TXPC_TXPC_TESTDAC_MASK) >> TXPC_TXPC_TESTDAC_LSB)
+#define TXPC_TXPC_TESTDAC_SET(x)                 (((x) << TXPC_TXPC_TESTDAC_LSB) & TXPC_TXPC_TESTDAC_MASK)
+#define TXPC_TXPC_TESTPWDPC_MSB                  21
+#define TXPC_TXPC_TESTPWDPC_LSB                  21
+#define TXPC_TXPC_TESTPWDPC_MASK                 0x00200000
+#define TXPC_TXPC_TESTPWDPC_GET(x)               (((x) & TXPC_TXPC_TESTPWDPC_MASK) >> TXPC_TXPC_TESTPWDPC_LSB)
+#define TXPC_TXPC_TESTPWDPC_SET(x)               (((x) << TXPC_TXPC_TESTPWDPC_LSB) & TXPC_TXPC_TESTPWDPC_MASK)
+#define TXPC_TXPC_CURHALF_MSB                    20
+#define TXPC_TXPC_CURHALF_LSB                    20
+#define TXPC_TXPC_CURHALF_MASK                   0x00100000
+#define TXPC_TXPC_CURHALF_GET(x)                 (((x) & TXPC_TXPC_CURHALF_MASK) >> TXPC_TXPC_CURHALF_LSB)
+#define TXPC_TXPC_CURHALF_SET(x)                 (((x) << TXPC_TXPC_CURHALF_LSB) & TXPC_TXPC_CURHALF_MASK)
+#define TXPC_TXPC_NEGOUT_MSB                     19
+#define TXPC_TXPC_NEGOUT_LSB                     19
+#define TXPC_TXPC_NEGOUT_MASK                    0x00080000
+#define TXPC_TXPC_NEGOUT_GET(x)                  (((x) & TXPC_TXPC_NEGOUT_MASK) >> TXPC_TXPC_NEGOUT_LSB)
+#define TXPC_TXPC_NEGOUT_SET(x)                  (((x) << TXPC_TXPC_NEGOUT_LSB) & TXPC_TXPC_NEGOUT_MASK)
+#define TXPC_TXPC_CLKDELAY_MSB                   18
+#define TXPC_TXPC_CLKDELAY_LSB                   18
+#define TXPC_TXPC_CLKDELAY_MASK                  0x00040000
+#define TXPC_TXPC_CLKDELAY_GET(x)                (((x) & TXPC_TXPC_CLKDELAY_MASK) >> TXPC_TXPC_CLKDELAY_LSB)
+#define TXPC_TXPC_CLKDELAY_SET(x)                (((x) << TXPC_TXPC_CLKDELAY_LSB) & TXPC_TXPC_CLKDELAY_MASK)
+#define TXPC_TXPC_SELMODREF_MSB                  17
+#define TXPC_TXPC_SELMODREF_LSB                  17
+#define TXPC_TXPC_SELMODREF_MASK                 0x00020000
+#define TXPC_TXPC_SELMODREF_GET(x)               (((x) & TXPC_TXPC_SELMODREF_MASK) >> TXPC_TXPC_SELMODREF_LSB)
+#define TXPC_TXPC_SELMODREF_SET(x)               (((x) << TXPC_TXPC_SELMODREF_LSB) & TXPC_TXPC_SELMODREF_MASK)
+#define TXPC_TXPC_SELCMOUT_MSB                   16
+#define TXPC_TXPC_SELCMOUT_LSB                   16
+#define TXPC_TXPC_SELCMOUT_MASK                  0x00010000
+#define TXPC_TXPC_SELCMOUT_GET(x)                (((x) & TXPC_TXPC_SELCMOUT_MASK) >> TXPC_TXPC_SELCMOUT_LSB)
+#define TXPC_TXPC_SELCMOUT_SET(x)                (((x) << TXPC_TXPC_SELCMOUT_LSB) & TXPC_TXPC_SELCMOUT_MASK)
+#define TXPC_TXPC_TSMODE_MSB                     15
+#define TXPC_TXPC_TSMODE_LSB                     14
+#define TXPC_TXPC_TSMODE_MASK                    0x0000c000
+#define TXPC_TXPC_TSMODE_GET(x)                  (((x) & TXPC_TXPC_TSMODE_MASK) >> TXPC_TXPC_TSMODE_LSB)
+#define TXPC_TXPC_TSMODE_SET(x)                  (((x) << TXPC_TXPC_TSMODE_LSB) & TXPC_TXPC_TSMODE_MASK)
+#define TXPC_TXPC_N_MSB                          13
+#define TXPC_TXPC_N_LSB                          6
+#define TXPC_TXPC_N_MASK                         0x00003fc0
+#define TXPC_TXPC_N_GET(x)                       (((x) & TXPC_TXPC_N_MASK) >> TXPC_TXPC_N_LSB)
+#define TXPC_TXPC_N_SET(x)                       (((x) << TXPC_TXPC_N_LSB) & TXPC_TXPC_N_MASK)
+#define TXPC_TXPC_ON1STSYNTHON_MSB               5
+#define TXPC_TXPC_ON1STSYNTHON_LSB               5
+#define TXPC_TXPC_ON1STSYNTHON_MASK              0x00000020
+#define TXPC_TXPC_ON1STSYNTHON_GET(x)            (((x) & TXPC_TXPC_ON1STSYNTHON_MASK) >> TXPC_TXPC_ON1STSYNTHON_LSB)
+#define TXPC_TXPC_ON1STSYNTHON_SET(x)            (((x) << TXPC_TXPC_ON1STSYNTHON_LSB) & TXPC_TXPC_ON1STSYNTHON_MASK)
+#define TXPC_TXPC_SELINIT_MSB                    4
+#define TXPC_TXPC_SELINIT_LSB                    3
+#define TXPC_TXPC_SELINIT_MASK                   0x00000018
+#define TXPC_TXPC_SELINIT_GET(x)                 (((x) & TXPC_TXPC_SELINIT_MASK) >> TXPC_TXPC_SELINIT_LSB)
+#define TXPC_TXPC_SELINIT_SET(x)                 (((x) << TXPC_TXPC_SELINIT_LSB) & TXPC_TXPC_SELINIT_MASK)
+#define TXPC_TXPC_SELCOUNT_MSB                   2
+#define TXPC_TXPC_SELCOUNT_LSB                   2
+#define TXPC_TXPC_SELCOUNT_MASK                  0x00000004
+#define TXPC_TXPC_SELCOUNT_GET(x)                (((x) & TXPC_TXPC_SELCOUNT_MASK) >> TXPC_TXPC_SELCOUNT_LSB)
+#define TXPC_TXPC_SELCOUNT_SET(x)                (((x) << TXPC_TXPC_SELCOUNT_LSB) & TXPC_TXPC_SELCOUNT_MASK)
+#define TXPC_TXPC_ATBSEL_MSB                     1
+#define TXPC_TXPC_ATBSEL_LSB                     0
+#define TXPC_TXPC_ATBSEL_MASK                    0x00000003
+#define TXPC_TXPC_ATBSEL_GET(x)                  (((x) & TXPC_TXPC_ATBSEL_MASK) >> TXPC_TXPC_ATBSEL_LSB)
+#define TXPC_TXPC_ATBSEL_SET(x)                  (((x) << TXPC_TXPC_ATBSEL_LSB) & TXPC_TXPC_ATBSEL_MASK)
+
+#define TXPC_MISC_ADDRESS                        0x0000004c
+#define TXPC_MISC_OFFSET                         0x0000004c
+#define TXPC_MISC_FLIPBMODE_MSB                  31
+#define TXPC_MISC_FLIPBMODE_LSB                  31
+#define TXPC_MISC_FLIPBMODE_MASK                 0x80000000
+#define TXPC_MISC_FLIPBMODE_GET(x)               (((x) & TXPC_MISC_FLIPBMODE_MASK) >> TXPC_MISC_FLIPBMODE_LSB)
+#define TXPC_MISC_FLIPBMODE_SET(x)               (((x) << TXPC_MISC_FLIPBMODE_LSB) & TXPC_MISC_FLIPBMODE_MASK)
+#define TXPC_MISC_LEVEL_MSB                      30
+#define TXPC_MISC_LEVEL_LSB                      29
+#define TXPC_MISC_LEVEL_MASK                     0x60000000
+#define TXPC_MISC_LEVEL_GET(x)                   (((x) & TXPC_MISC_LEVEL_MASK) >> TXPC_MISC_LEVEL_LSB)
+#define TXPC_MISC_LEVEL_SET(x)                   (((x) << TXPC_MISC_LEVEL_LSB) & TXPC_MISC_LEVEL_MASK)
+#define TXPC_MISC_LDO_TEST_MODE_MSB              28
+#define TXPC_MISC_LDO_TEST_MODE_LSB              28
+#define TXPC_MISC_LDO_TEST_MODE_MASK             0x10000000
+#define TXPC_MISC_LDO_TEST_MODE_GET(x)           (((x) & TXPC_MISC_LDO_TEST_MODE_MASK) >> TXPC_MISC_LDO_TEST_MODE_LSB)
+#define TXPC_MISC_LDO_TEST_MODE_SET(x)           (((x) << TXPC_MISC_LDO_TEST_MODE_LSB) & TXPC_MISC_LDO_TEST_MODE_MASK)
+#define TXPC_MISC_NOTCXODET_MSB                  27
+#define TXPC_MISC_NOTCXODET_LSB                  27
+#define TXPC_MISC_NOTCXODET_MASK                 0x08000000
+#define TXPC_MISC_NOTCXODET_GET(x)               (((x) & TXPC_MISC_NOTCXODET_MASK) >> TXPC_MISC_NOTCXODET_LSB)
+#define TXPC_MISC_NOTCXODET_SET(x)               (((x) << TXPC_MISC_NOTCXODET_LSB) & TXPC_MISC_NOTCXODET_MASK)
+#define TXPC_MISC_PWDCLKIND_MSB                  26
+#define TXPC_MISC_PWDCLKIND_LSB                  26
+#define TXPC_MISC_PWDCLKIND_MASK                 0x04000000
+#define TXPC_MISC_PWDCLKIND_GET(x)               (((x) & TXPC_MISC_PWDCLKIND_MASK) >> TXPC_MISC_PWDCLKIND_LSB)
+#define TXPC_MISC_PWDCLKIND_SET(x)               (((x) << TXPC_MISC_PWDCLKIND_LSB) & TXPC_MISC_PWDCLKIND_MASK)
+#define TXPC_MISC_PWDXINPAD_MSB                  25
+#define TXPC_MISC_PWDXINPAD_LSB                  25
+#define TXPC_MISC_PWDXINPAD_MASK                 0x02000000
+#define TXPC_MISC_PWDXINPAD_GET(x)               (((x) & TXPC_MISC_PWDXINPAD_MASK) >> TXPC_MISC_PWDXINPAD_LSB)
+#define TXPC_MISC_PWDXINPAD_SET(x)               (((x) << TXPC_MISC_PWDXINPAD_LSB) & TXPC_MISC_PWDXINPAD_MASK)
+#define TXPC_MISC_LOCALBIAS_MSB                  24
+#define TXPC_MISC_LOCALBIAS_LSB                  24
+#define TXPC_MISC_LOCALBIAS_MASK                 0x01000000
+#define TXPC_MISC_LOCALBIAS_GET(x)               (((x) & TXPC_MISC_LOCALBIAS_MASK) >> TXPC_MISC_LOCALBIAS_LSB)
+#define TXPC_MISC_LOCALBIAS_SET(x)               (((x) << TXPC_MISC_LOCALBIAS_LSB) & TXPC_MISC_LOCALBIAS_MASK)
+#define TXPC_MISC_LOCALBIAS2X_MSB                23
+#define TXPC_MISC_LOCALBIAS2X_LSB                23
+#define TXPC_MISC_LOCALBIAS2X_MASK               0x00800000
+#define TXPC_MISC_LOCALBIAS2X_GET(x)             (((x) & TXPC_MISC_LOCALBIAS2X_MASK) >> TXPC_MISC_LOCALBIAS2X_LSB)
+#define TXPC_MISC_LOCALBIAS2X_SET(x)             (((x) << TXPC_MISC_LOCALBIAS2X_LSB) & TXPC_MISC_LOCALBIAS2X_MASK)
+#define TXPC_MISC_SELTSP_MSB                     22
+#define TXPC_MISC_SELTSP_LSB                     22
+#define TXPC_MISC_SELTSP_MASK                    0x00400000
+#define TXPC_MISC_SELTSP_GET(x)                  (((x) & TXPC_MISC_SELTSP_MASK) >> TXPC_MISC_SELTSP_LSB)
+#define TXPC_MISC_SELTSP_SET(x)                  (((x) << TXPC_MISC_SELTSP_LSB) & TXPC_MISC_SELTSP_MASK)
+#define TXPC_MISC_SELTSN_MSB                     21
+#define TXPC_MISC_SELTSN_LSB                     21
+#define TXPC_MISC_SELTSN_MASK                    0x00200000
+#define TXPC_MISC_SELTSN_GET(x)                  (((x) & TXPC_MISC_SELTSN_MASK) >> TXPC_MISC_SELTSN_LSB)
+#define TXPC_MISC_SELTSN_SET(x)                  (((x) << TXPC_MISC_SELTSN_LSB) & TXPC_MISC_SELTSN_MASK)
+#define TXPC_MISC_SPARE_A_MSB                    20
+#define TXPC_MISC_SPARE_A_LSB                    18
+#define TXPC_MISC_SPARE_A_MASK                   0x001c0000
+#define TXPC_MISC_SPARE_A_GET(x)                 (((x) & TXPC_MISC_SPARE_A_MASK) >> TXPC_MISC_SPARE_A_LSB)
+#define TXPC_MISC_SPARE_A_SET(x)                 (((x) << TXPC_MISC_SPARE_A_LSB) & TXPC_MISC_SPARE_A_MASK)
+#define TXPC_MISC_DECOUT_MSB                     17
+#define TXPC_MISC_DECOUT_LSB                     8
+#define TXPC_MISC_DECOUT_MASK                    0x0003ff00
+#define TXPC_MISC_DECOUT_GET(x)                  (((x) & TXPC_MISC_DECOUT_MASK) >> TXPC_MISC_DECOUT_LSB)
+#define TXPC_MISC_DECOUT_SET(x)                  (((x) << TXPC_MISC_DECOUT_LSB) & TXPC_MISC_DECOUT_MASK)
+#define TXPC_MISC_XTALDIV_MSB                    7
+#define TXPC_MISC_XTALDIV_LSB                    6
+#define TXPC_MISC_XTALDIV_MASK                   0x000000c0
+#define TXPC_MISC_XTALDIV_GET(x)                 (((x) & TXPC_MISC_XTALDIV_MASK) >> TXPC_MISC_XTALDIV_LSB)
+#define TXPC_MISC_XTALDIV_SET(x)                 (((x) << TXPC_MISC_XTALDIV_LSB) & TXPC_MISC_XTALDIV_MASK)
+#define TXPC_MISC_SPARE_MSB                      5
+#define TXPC_MISC_SPARE_LSB                      0
+#define TXPC_MISC_SPARE_MASK                     0x0000003f
+#define TXPC_MISC_SPARE_GET(x)                   (((x) & TXPC_MISC_SPARE_MASK) >> TXPC_MISC_SPARE_LSB)
+#define TXPC_MISC_SPARE_SET(x)                   (((x) << TXPC_MISC_SPARE_LSB) & TXPC_MISC_SPARE_MASK)
+
+#define RXTXBB_RXTXBB1_ADDRESS                   0x00000050
+#define RXTXBB_RXTXBB1_OFFSET                    0x00000050
+#define RXTXBB_RXTXBB1_SPARE_MSB                 31
+#define RXTXBB_RXTXBB1_SPARE_LSB                 19
+#define RXTXBB_RXTXBB1_SPARE_MASK                0xfff80000
+#define RXTXBB_RXTXBB1_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB1_SPARE_MASK) >> RXTXBB_RXTXBB1_SPARE_LSB)
+#define RXTXBB_RXTXBB1_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB1_SPARE_LSB) & RXTXBB_RXTXBB1_SPARE_MASK)
+#define RXTXBB_RXTXBB1_FNOTCH_MSB                18
+#define RXTXBB_RXTXBB1_FNOTCH_LSB                17
+#define RXTXBB_RXTXBB1_FNOTCH_MASK               0x00060000
+#define RXTXBB_RXTXBB1_FNOTCH_GET(x)             (((x) & RXTXBB_RXTXBB1_FNOTCH_MASK) >> RXTXBB_RXTXBB1_FNOTCH_LSB)
+#define RXTXBB_RXTXBB1_FNOTCH_SET(x)             (((x) << RXTXBB_RXTXBB1_FNOTCH_LSB) & RXTXBB_RXTXBB1_FNOTCH_MASK)
+#define RXTXBB_RXTXBB1_SEL_ATB_MSB               16
+#define RXTXBB_RXTXBB1_SEL_ATB_LSB               9
+#define RXTXBB_RXTXBB1_SEL_ATB_MASK              0x0001fe00
+#define RXTXBB_RXTXBB1_SEL_ATB_GET(x)            (((x) & RXTXBB_RXTXBB1_SEL_ATB_MASK) >> RXTXBB_RXTXBB1_SEL_ATB_LSB)
+#define RXTXBB_RXTXBB1_SEL_ATB_SET(x)            (((x) << RXTXBB_RXTXBB1_SEL_ATB_LSB) & RXTXBB_RXTXBB1_SEL_ATB_MASK)
+#define RXTXBB_RXTXBB1_PDDACINTERFACE_MSB        8
+#define RXTXBB_RXTXBB1_PDDACINTERFACE_LSB        8
+#define RXTXBB_RXTXBB1_PDDACINTERFACE_MASK       0x00000100
+#define RXTXBB_RXTXBB1_PDDACINTERFACE_GET(x)     (((x) & RXTXBB_RXTXBB1_PDDACINTERFACE_MASK) >> RXTXBB_RXTXBB1_PDDACINTERFACE_LSB)
+#define RXTXBB_RXTXBB1_PDDACINTERFACE_SET(x)     (((x) << RXTXBB_RXTXBB1_PDDACINTERFACE_LSB) & RXTXBB_RXTXBB1_PDDACINTERFACE_MASK)
+#define RXTXBB_RXTXBB1_PDV2I_MSB                 7
+#define RXTXBB_RXTXBB1_PDV2I_LSB                 7
+#define RXTXBB_RXTXBB1_PDV2I_MASK                0x00000080
+#define RXTXBB_RXTXBB1_PDV2I_GET(x)              (((x) & RXTXBB_RXTXBB1_PDV2I_MASK) >> RXTXBB_RXTXBB1_PDV2I_LSB)
+#define RXTXBB_RXTXBB1_PDV2I_SET(x)              (((x) << RXTXBB_RXTXBB1_PDV2I_LSB) & RXTXBB_RXTXBB1_PDV2I_MASK)
+#define RXTXBB_RXTXBB1_PDI2V_MSB                 6
+#define RXTXBB_RXTXBB1_PDI2V_LSB                 6
+#define RXTXBB_RXTXBB1_PDI2V_MASK                0x00000040
+#define RXTXBB_RXTXBB1_PDI2V_GET(x)              (((x) & RXTXBB_RXTXBB1_PDI2V_MASK) >> RXTXBB_RXTXBB1_PDI2V_LSB)
+#define RXTXBB_RXTXBB1_PDI2V_SET(x)              (((x) << RXTXBB_RXTXBB1_PDI2V_LSB) & RXTXBB_RXTXBB1_PDI2V_MASK)
+#define RXTXBB_RXTXBB1_PDRXTXBB_MSB              5
+#define RXTXBB_RXTXBB1_PDRXTXBB_LSB              5
+#define RXTXBB_RXTXBB1_PDRXTXBB_MASK             0x00000020
+#define RXTXBB_RXTXBB1_PDRXTXBB_GET(x)           (((x) & RXTXBB_RXTXBB1_PDRXTXBB_MASK) >> RXTXBB_RXTXBB1_PDRXTXBB_LSB)
+#define RXTXBB_RXTXBB1_PDRXTXBB_SET(x)           (((x) << RXTXBB_RXTXBB1_PDRXTXBB_LSB) & RXTXBB_RXTXBB1_PDRXTXBB_MASK)
+#define RXTXBB_RXTXBB1_PDOFFSETLOQ_MSB           4
+#define RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB           4
+#define RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK          0x00000010
+#define RXTXBB_RXTXBB1_PDOFFSETLOQ_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK) >> RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB)
+#define RXTXBB_RXTXBB1_PDOFFSETLOQ_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETLOQ_LSB) & RXTXBB_RXTXBB1_PDOFFSETLOQ_MASK)
+#define RXTXBB_RXTXBB1_PDOFFSETHIQ_MSB           3
+#define RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB           3
+#define RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK          0x00000008
+#define RXTXBB_RXTXBB1_PDOFFSETHIQ_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK) >> RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB)
+#define RXTXBB_RXTXBB1_PDOFFSETHIQ_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETHIQ_LSB) & RXTXBB_RXTXBB1_PDOFFSETHIQ_MASK)
+#define RXTXBB_RXTXBB1_PDOFFSETI2V_MSB           2
+#define RXTXBB_RXTXBB1_PDOFFSETI2V_LSB           2
+#define RXTXBB_RXTXBB1_PDOFFSETI2V_MASK          0x00000004
+#define RXTXBB_RXTXBB1_PDOFFSETI2V_GET(x)        (((x) & RXTXBB_RXTXBB1_PDOFFSETI2V_MASK) >> RXTXBB_RXTXBB1_PDOFFSETI2V_LSB)
+#define RXTXBB_RXTXBB1_PDOFFSETI2V_SET(x)        (((x) << RXTXBB_RXTXBB1_PDOFFSETI2V_LSB) & RXTXBB_RXTXBB1_PDOFFSETI2V_MASK)
+#define RXTXBB_RXTXBB1_PDLOQ_MSB                 1
+#define RXTXBB_RXTXBB1_PDLOQ_LSB                 1
+#define RXTXBB_RXTXBB1_PDLOQ_MASK                0x00000002
+#define RXTXBB_RXTXBB1_PDLOQ_GET(x)              (((x) & RXTXBB_RXTXBB1_PDLOQ_MASK) >> RXTXBB_RXTXBB1_PDLOQ_LSB)
+#define RXTXBB_RXTXBB1_PDLOQ_SET(x)              (((x) << RXTXBB_RXTXBB1_PDLOQ_LSB) & RXTXBB_RXTXBB1_PDLOQ_MASK)
+#define RXTXBB_RXTXBB1_PDHIQ_MSB                 0
+#define RXTXBB_RXTXBB1_PDHIQ_LSB                 0
+#define RXTXBB_RXTXBB1_PDHIQ_MASK                0x00000001
+#define RXTXBB_RXTXBB1_PDHIQ_GET(x)              (((x) & RXTXBB_RXTXBB1_PDHIQ_MASK) >> RXTXBB_RXTXBB1_PDHIQ_LSB)
+#define RXTXBB_RXTXBB1_PDHIQ_SET(x)              (((x) << RXTXBB_RXTXBB1_PDHIQ_LSB) & RXTXBB_RXTXBB1_PDHIQ_MASK)
+
+#define RXTXBB_RXTXBB2_ADDRESS                   0x00000054
+#define RXTXBB_RXTXBB2_OFFSET                    0x00000054
+#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MSB    31
+#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB    29
+#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK   0xe0000000
+#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB)
+#define RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSHI_CTRL_MASK)
+#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MSB    28
+#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB    26
+#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK   0x1c000000
+#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB)
+#define RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSLO_CTRL_MASK)
+#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MSB   25
+#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB   23
+#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK  0x03800000
+#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_GET(x) (((x) & RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK) >> RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB)
+#define RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_SET(x) (((x) << RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_LSB) & RXTXBB_RXTXBB2_IBN_37P5_OSI2V_CTRL_MASK)
+#define RXTXBB_RXTXBB2_SPARE_MSB                 22
+#define RXTXBB_RXTXBB2_SPARE_LSB                 21
+#define RXTXBB_RXTXBB2_SPARE_MASK                0x00600000
+#define RXTXBB_RXTXBB2_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB2_SPARE_MASK) >> RXTXBB_RXTXBB2_SPARE_LSB)
+#define RXTXBB_RXTXBB2_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB2_SPARE_LSB) & RXTXBB_RXTXBB2_SPARE_MASK)
+#define RXTXBB_RXTXBB2_SHORTBUFFER_MSB           20
+#define RXTXBB_RXTXBB2_SHORTBUFFER_LSB           20
+#define RXTXBB_RXTXBB2_SHORTBUFFER_MASK          0x00100000
+#define RXTXBB_RXTXBB2_SHORTBUFFER_GET(x)        (((x) & RXTXBB_RXTXBB2_SHORTBUFFER_MASK) >> RXTXBB_RXTXBB2_SHORTBUFFER_LSB)
+#define RXTXBB_RXTXBB2_SHORTBUFFER_SET(x)        (((x) << RXTXBB_RXTXBB2_SHORTBUFFER_LSB) & RXTXBB_RXTXBB2_SHORTBUFFER_MASK)
+#define RXTXBB_RXTXBB2_SELBUFFER_MSB             19
+#define RXTXBB_RXTXBB2_SELBUFFER_LSB             19
+#define RXTXBB_RXTXBB2_SELBUFFER_MASK            0x00080000
+#define RXTXBB_RXTXBB2_SELBUFFER_GET(x)          (((x) & RXTXBB_RXTXBB2_SELBUFFER_MASK) >> RXTXBB_RXTXBB2_SELBUFFER_LSB)
+#define RXTXBB_RXTXBB2_SELBUFFER_SET(x)          (((x) << RXTXBB_RXTXBB2_SELBUFFER_LSB) & RXTXBB_RXTXBB2_SELBUFFER_MASK)
+#define RXTXBB_RXTXBB2_SEL_DAC_TEST_MSB          18
+#define RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB          18
+#define RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK         0x00040000
+#define RXTXBB_RXTXBB2_SEL_DAC_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB)
+#define RXTXBB_RXTXBB2_SEL_DAC_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_DAC_TEST_LSB) & RXTXBB_RXTXBB2_SEL_DAC_TEST_MASK)
+#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_MSB          17
+#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB          17
+#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK         0x00020000
+#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB)
+#define RXTXBB_RXTXBB2_SEL_LOQ_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_LOQ_TEST_LSB) & RXTXBB_RXTXBB2_SEL_LOQ_TEST_MASK)
+#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_MSB          16
+#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB          16
+#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK         0x00010000
+#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB)
+#define RXTXBB_RXTXBB2_SEL_HIQ_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_HIQ_TEST_LSB) & RXTXBB_RXTXBB2_SEL_HIQ_TEST_MASK)
+#define RXTXBB_RXTXBB2_SEL_I2V_TEST_MSB          15
+#define RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB          15
+#define RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK         0x00008000
+#define RXTXBB_RXTXBB2_SEL_I2V_TEST_GET(x)       (((x) & RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK) >> RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB)
+#define RXTXBB_RXTXBB2_SEL_I2V_TEST_SET(x)       (((x) << RXTXBB_RXTXBB2_SEL_I2V_TEST_LSB) & RXTXBB_RXTXBB2_SEL_I2V_TEST_MASK)
+#define RXTXBB_RXTXBB2_CMSEL_MSB                 14
+#define RXTXBB_RXTXBB2_CMSEL_LSB                 13
+#define RXTXBB_RXTXBB2_CMSEL_MASK                0x00006000
+#define RXTXBB_RXTXBB2_CMSEL_GET(x)              (((x) & RXTXBB_RXTXBB2_CMSEL_MASK) >> RXTXBB_RXTXBB2_CMSEL_LSB)
+#define RXTXBB_RXTXBB2_CMSEL_SET(x)              (((x) << RXTXBB_RXTXBB2_CMSEL_LSB) & RXTXBB_RXTXBB2_CMSEL_MASK)
+#define RXTXBB_RXTXBB2_FILTERFC_MSB              12
+#define RXTXBB_RXTXBB2_FILTERFC_LSB              8
+#define RXTXBB_RXTXBB2_FILTERFC_MASK             0x00001f00
+#define RXTXBB_RXTXBB2_FILTERFC_GET(x)           (((x) & RXTXBB_RXTXBB2_FILTERFC_MASK) >> RXTXBB_RXTXBB2_FILTERFC_LSB)
+#define RXTXBB_RXTXBB2_FILTERFC_SET(x)           (((x) << RXTXBB_RXTXBB2_FILTERFC_LSB) & RXTXBB_RXTXBB2_FILTERFC_MASK)
+#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_MSB     7
+#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB     7
+#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK    0x00000080
+#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_GET(x)  (((x) & RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK) >> RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB)
+#define RXTXBB_RXTXBB2_LOCALFILTERTUNING_SET(x)  (((x) << RXTXBB_RXTXBB2_LOCALFILTERTUNING_LSB) & RXTXBB_RXTXBB2_LOCALFILTERTUNING_MASK)
+#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_MSB        6
+#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB        6
+#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK       0x00000040
+#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_GET(x)     (((x) & RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK) >> RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB)
+#define RXTXBB_RXTXBB2_FILTERDOUBLEBW_SET(x)     (((x) << RXTXBB_RXTXBB2_FILTERDOUBLEBW_LSB) & RXTXBB_RXTXBB2_FILTERDOUBLEBW_MASK)
+#define RXTXBB_RXTXBB2_PATH2HIQ_EN_MSB           5
+#define RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB           5
+#define RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK          0x00000020
+#define RXTXBB_RXTXBB2_PATH2HIQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB)
+#define RXTXBB_RXTXBB2_PATH2HIQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH2HIQ_EN_LSB) & RXTXBB_RXTXBB2_PATH2HIQ_EN_MASK)
+#define RXTXBB_RXTXBB2_PATH1HIQ_EN_MSB           4
+#define RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB           4
+#define RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK          0x00000010
+#define RXTXBB_RXTXBB2_PATH1HIQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB)
+#define RXTXBB_RXTXBB2_PATH1HIQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH1HIQ_EN_LSB) & RXTXBB_RXTXBB2_PATH1HIQ_EN_MASK)
+#define RXTXBB_RXTXBB2_PATH3LOQ_EN_MSB           3
+#define RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB           3
+#define RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK          0x00000008
+#define RXTXBB_RXTXBB2_PATH3LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB)
+#define RXTXBB_RXTXBB2_PATH3LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH3LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH3LOQ_EN_MASK)
+#define RXTXBB_RXTXBB2_PATH2LOQ_EN_MSB           2
+#define RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB           2
+#define RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK          0x00000004
+#define RXTXBB_RXTXBB2_PATH2LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB)
+#define RXTXBB_RXTXBB2_PATH2LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH2LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH2LOQ_EN_MASK)
+#define RXTXBB_RXTXBB2_PATH1LOQ_EN_MSB           1
+#define RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB           1
+#define RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK          0x00000002
+#define RXTXBB_RXTXBB2_PATH1LOQ_EN_GET(x)        (((x) & RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK) >> RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB)
+#define RXTXBB_RXTXBB2_PATH1LOQ_EN_SET(x)        (((x) << RXTXBB_RXTXBB2_PATH1LOQ_EN_LSB) & RXTXBB_RXTXBB2_PATH1LOQ_EN_MASK)
+#define RXTXBB_RXTXBB2_PATH_OVERRIDE_MSB         0
+#define RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB         0
+#define RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK        0x00000001
+#define RXTXBB_RXTXBB2_PATH_OVERRIDE_GET(x)      (((x) & RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK) >> RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB)
+#define RXTXBB_RXTXBB2_PATH_OVERRIDE_SET(x)      (((x) << RXTXBB_RXTXBB2_PATH_OVERRIDE_LSB) & RXTXBB_RXTXBB2_PATH_OVERRIDE_MASK)
+
+#define RXTXBB_RXTXBB3_ADDRESS                   0x00000058
+#define RXTXBB_RXTXBB3_OFFSET                    0x00000058
+#define RXTXBB_RXTXBB3_SPARE_MSB                 31
+#define RXTXBB_RXTXBB3_SPARE_LSB                 27
+#define RXTXBB_RXTXBB3_SPARE_MASK                0xf8000000
+#define RXTXBB_RXTXBB3_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB3_SPARE_MASK) >> RXTXBB_RXTXBB3_SPARE_LSB)
+#define RXTXBB_RXTXBB3_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB3_SPARE_LSB) & RXTXBB_RXTXBB3_SPARE_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MSB 26
+#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB 24
+#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK 0x07000000
+#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_CM_BUFAMP_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MSB    23
+#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB    21
+#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK   0x00e00000
+#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_BKV2I_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MSB      20
+#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB      18
+#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK     0x001c0000
+#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_I2V_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MSB      17
+#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB      15
+#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK     0x00038000
+#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_HI1_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MSB      14
+#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB      12
+#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK     0x00007000
+#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_HI2_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MSB      11
+#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB      9
+#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK     0x00000e00
+#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_LO1_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MSB      8
+#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB      6
+#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK     0x000001c0
+#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_GET(x)   (((x) & RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_SET(x)   (((x) << RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_25U_LO2_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MSB     5
+#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB     3
+#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK    0x00000038
+#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_GET(x)  (((x) & RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK) >> RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_SET(x)  (((x) << RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_LSB) & RXTXBB_RXTXBB3_IBRN_12P5_CM_CTRL_MASK)
+#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MSB    2
+#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB    0
+#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK   0x00000007
+#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_GET(x) (((x) & RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK) >> RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB)
+#define RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_SET(x) (((x) << RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_LSB) & RXTXBB_RXTXBB3_IBN_100U_TEST_CTRL_MASK)
+
+#define RXTXBB_RXTXBB4_ADDRESS                   0x0000005c
+#define RXTXBB_RXTXBB4_OFFSET                    0x0000005c
+#define RXTXBB_RXTXBB4_SPARE_MSB                 31
+#define RXTXBB_RXTXBB4_SPARE_LSB                 31
+#define RXTXBB_RXTXBB4_SPARE_MASK                0x80000000
+#define RXTXBB_RXTXBB4_SPARE_GET(x)              (((x) & RXTXBB_RXTXBB4_SPARE_MASK) >> RXTXBB_RXTXBB4_SPARE_LSB)
+#define RXTXBB_RXTXBB4_SPARE_SET(x)              (((x) << RXTXBB_RXTXBB4_SPARE_LSB) & RXTXBB_RXTXBB4_SPARE_MASK)
+#define RXTXBB_RXTXBB4_LOCALOFFSET_MSB           30
+#define RXTXBB_RXTXBB4_LOCALOFFSET_LSB           30
+#define RXTXBB_RXTXBB4_LOCALOFFSET_MASK          0x40000000
+#define RXTXBB_RXTXBB4_LOCALOFFSET_GET(x)        (((x) & RXTXBB_RXTXBB4_LOCALOFFSET_MASK) >> RXTXBB_RXTXBB4_LOCALOFFSET_LSB)
+#define RXTXBB_RXTXBB4_LOCALOFFSET_SET(x)        (((x) << RXTXBB_RXTXBB4_LOCALOFFSET_LSB) & RXTXBB_RXTXBB4_LOCALOFFSET_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRHII_MSB           29
+#define RXTXBB_RXTXBB4_OFSTCORRHII_LSB           25
+#define RXTXBB_RXTXBB4_OFSTCORRHII_MASK          0x3e000000
+#define RXTXBB_RXTXBB4_OFSTCORRHII_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRHII_MASK) >> RXTXBB_RXTXBB4_OFSTCORRHII_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRHII_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRHII_LSB) & RXTXBB_RXTXBB4_OFSTCORRHII_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRHIQ_MSB           24
+#define RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB           20
+#define RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK          0x01f00000
+#define RXTXBB_RXTXBB4_OFSTCORRHIQ_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRHIQ_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRHIQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRHIQ_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRLOI_MSB           19
+#define RXTXBB_RXTXBB4_OFSTCORRLOI_LSB           15
+#define RXTXBB_RXTXBB4_OFSTCORRLOI_MASK          0x000f8000
+#define RXTXBB_RXTXBB4_OFSTCORRLOI_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRLOI_MASK) >> RXTXBB_RXTXBB4_OFSTCORRLOI_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRLOI_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRLOI_LSB) & RXTXBB_RXTXBB4_OFSTCORRLOI_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRLOQ_MSB           14
+#define RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB           10
+#define RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK          0x00007c00
+#define RXTXBB_RXTXBB4_OFSTCORRLOQ_GET(x)        (((x) & RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRLOQ_SET(x)        (((x) << RXTXBB_RXTXBB4_OFSTCORRLOQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRLOQ_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRI2VI_MSB          9
+#define RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB          5
+#define RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK         0x000003e0
+#define RXTXBB_RXTXBB4_OFSTCORRI2VI_GET(x)       (((x) & RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK) >> RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRI2VI_SET(x)       (((x) << RXTXBB_RXTXBB4_OFSTCORRI2VI_LSB) & RXTXBB_RXTXBB4_OFSTCORRI2VI_MASK)
+#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_MSB          4
+#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB          0
+#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK         0x0000001f
+#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_GET(x)       (((x) & RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK) >> RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB)
+#define RXTXBB_RXTXBB4_OFSTCORRI2VQ_SET(x)       (((x) << RXTXBB_RXTXBB4_OFSTCORRI2VQ_LSB) & RXTXBB_RXTXBB4_OFSTCORRI2VQ_MASK)
+
+#define ADDAC_ADDAC1_ADDRESS                     0x00000060
+#define ADDAC_ADDAC1_OFFSET                      0x00000060
+#define ADDAC_ADDAC1_PLL_SVREG_MSB               31
+#define ADDAC_ADDAC1_PLL_SVREG_LSB               31
+#define ADDAC_ADDAC1_PLL_SVREG_MASK              0x80000000
+#define ADDAC_ADDAC1_PLL_SVREG_GET(x)            (((x) & ADDAC_ADDAC1_PLL_SVREG_MASK) >> ADDAC_ADDAC1_PLL_SVREG_LSB)
+#define ADDAC_ADDAC1_PLL_SVREG_SET(x)            (((x) << ADDAC_ADDAC1_PLL_SVREG_LSB) & ADDAC_ADDAC1_PLL_SVREG_MASK)
+#define ADDAC_ADDAC1_PLL_SCLAMP_MSB              30
+#define ADDAC_ADDAC1_PLL_SCLAMP_LSB              28
+#define ADDAC_ADDAC1_PLL_SCLAMP_MASK             0x70000000
+#define ADDAC_ADDAC1_PLL_SCLAMP_GET(x)           (((x) & ADDAC_ADDAC1_PLL_SCLAMP_MASK) >> ADDAC_ADDAC1_PLL_SCLAMP_LSB)
+#define ADDAC_ADDAC1_PLL_SCLAMP_SET(x)           (((x) << ADDAC_ADDAC1_PLL_SCLAMP_LSB) & ADDAC_ADDAC1_PLL_SCLAMP_MASK)
+#define ADDAC_ADDAC1_PLL_ATB_MSB                 27
+#define ADDAC_ADDAC1_PLL_ATB_LSB                 26
+#define ADDAC_ADDAC1_PLL_ATB_MASK                0x0c000000
+#define ADDAC_ADDAC1_PLL_ATB_GET(x)              (((x) & ADDAC_ADDAC1_PLL_ATB_MASK) >> ADDAC_ADDAC1_PLL_ATB_LSB)
+#define ADDAC_ADDAC1_PLL_ATB_SET(x)              (((x) << ADDAC_ADDAC1_PLL_ATB_LSB) & ADDAC_ADDAC1_PLL_ATB_MASK)
+#define ADDAC_ADDAC1_PLL_ICP_MSB                 25
+#define ADDAC_ADDAC1_PLL_ICP_LSB                 23
+#define ADDAC_ADDAC1_PLL_ICP_MASK                0x03800000
+#define ADDAC_ADDAC1_PLL_ICP_GET(x)              (((x) & ADDAC_ADDAC1_PLL_ICP_MASK) >> ADDAC_ADDAC1_PLL_ICP_LSB)
+#define ADDAC_ADDAC1_PLL_ICP_SET(x)              (((x) << ADDAC_ADDAC1_PLL_ICP_LSB) & ADDAC_ADDAC1_PLL_ICP_MASK)
+#define ADDAC_ADDAC1_PLL_FILTER_MSB              22
+#define ADDAC_ADDAC1_PLL_FILTER_LSB              15
+#define ADDAC_ADDAC1_PLL_FILTER_MASK             0x007f8000
+#define ADDAC_ADDAC1_PLL_FILTER_GET(x)           (((x) & ADDAC_ADDAC1_PLL_FILTER_MASK) >> ADDAC_ADDAC1_PLL_FILTER_LSB)
+#define ADDAC_ADDAC1_PLL_FILTER_SET(x)           (((x) << ADDAC_ADDAC1_PLL_FILTER_LSB) & ADDAC_ADDAC1_PLL_FILTER_MASK)
+#define ADDAC_ADDAC1_PWDPLL_MSB                  14
+#define ADDAC_ADDAC1_PWDPLL_LSB                  14
+#define ADDAC_ADDAC1_PWDPLL_MASK                 0x00004000
+#define ADDAC_ADDAC1_PWDPLL_GET(x)               (((x) & ADDAC_ADDAC1_PWDPLL_MASK) >> ADDAC_ADDAC1_PWDPLL_LSB)
+#define ADDAC_ADDAC1_PWDPLL_SET(x)               (((x) << ADDAC_ADDAC1_PWDPLL_LSB) & ADDAC_ADDAC1_PWDPLL_MASK)
+#define ADDAC_ADDAC1_PWDADC_MSB                  13
+#define ADDAC_ADDAC1_PWDADC_LSB                  13
+#define ADDAC_ADDAC1_PWDADC_MASK                 0x00002000
+#define ADDAC_ADDAC1_PWDADC_GET(x)               (((x) & ADDAC_ADDAC1_PWDADC_MASK) >> ADDAC_ADDAC1_PWDADC_LSB)
+#define ADDAC_ADDAC1_PWDADC_SET(x)               (((x) << ADDAC_ADDAC1_PWDADC_LSB) & ADDAC_ADDAC1_PWDADC_MASK)
+#define ADDAC_ADDAC1_PWDDAC_MSB                  12
+#define ADDAC_ADDAC1_PWDDAC_LSB                  12
+#define ADDAC_ADDAC1_PWDDAC_MASK                 0x00001000
+#define ADDAC_ADDAC1_PWDDAC_GET(x)               (((x) & ADDAC_ADDAC1_PWDDAC_MASK) >> ADDAC_ADDAC1_PWDDAC_LSB)
+#define ADDAC_ADDAC1_PWDDAC_SET(x)               (((x) << ADDAC_ADDAC1_PWDDAC_LSB) & ADDAC_ADDAC1_PWDDAC_MASK)
+#define ADDAC_ADDAC1_FORCEMSBLOW_MSB             11
+#define ADDAC_ADDAC1_FORCEMSBLOW_LSB             11
+#define ADDAC_ADDAC1_FORCEMSBLOW_MASK            0x00000800
+#define ADDAC_ADDAC1_FORCEMSBLOW_GET(x)          (((x) & ADDAC_ADDAC1_FORCEMSBLOW_MASK) >> ADDAC_ADDAC1_FORCEMSBLOW_LSB)
+#define ADDAC_ADDAC1_FORCEMSBLOW_SET(x)          (((x) << ADDAC_ADDAC1_FORCEMSBLOW_LSB) & ADDAC_ADDAC1_FORCEMSBLOW_MASK)
+#define ADDAC_ADDAC1_SELMANPWDS_MSB              10
+#define ADDAC_ADDAC1_SELMANPWDS_LSB              10
+#define ADDAC_ADDAC1_SELMANPWDS_MASK             0x00000400
+#define ADDAC_ADDAC1_SELMANPWDS_GET(x)           (((x) & ADDAC_ADDAC1_SELMANPWDS_MASK) >> ADDAC_ADDAC1_SELMANPWDS_LSB)
+#define ADDAC_ADDAC1_SELMANPWDS_SET(x)           (((x) << ADDAC_ADDAC1_SELMANPWDS_LSB) & ADDAC_ADDAC1_SELMANPWDS_MASK)
+#define ADDAC_ADDAC1_INV_CLK160_ADC_MSB          9
+#define ADDAC_ADDAC1_INV_CLK160_ADC_LSB          9
+#define ADDAC_ADDAC1_INV_CLK160_ADC_MASK         0x00000200
+#define ADDAC_ADDAC1_INV_CLK160_ADC_GET(x)       (((x) & ADDAC_ADDAC1_INV_CLK160_ADC_MASK) >> ADDAC_ADDAC1_INV_CLK160_ADC_LSB)
+#define ADDAC_ADDAC1_INV_CLK160_ADC_SET(x)       (((x) << ADDAC_ADDAC1_INV_CLK160_ADC_LSB) & ADDAC_ADDAC1_INV_CLK160_ADC_MASK)
+#define ADDAC_ADDAC1_CM_SEL_MSB                  8
+#define ADDAC_ADDAC1_CM_SEL_LSB                  7
+#define ADDAC_ADDAC1_CM_SEL_MASK                 0x00000180
+#define ADDAC_ADDAC1_CM_SEL_GET(x)               (((x) & ADDAC_ADDAC1_CM_SEL_MASK) >> ADDAC_ADDAC1_CM_SEL_LSB)
+#define ADDAC_ADDAC1_CM_SEL_SET(x)               (((x) << ADDAC_ADDAC1_CM_SEL_LSB) & ADDAC_ADDAC1_CM_SEL_MASK)
+#define ADDAC_ADDAC1_DISABLE_DAC_REG_MSB         6
+#define ADDAC_ADDAC1_DISABLE_DAC_REG_LSB         6
+#define ADDAC_ADDAC1_DISABLE_DAC_REG_MASK        0x00000040
+#define ADDAC_ADDAC1_DISABLE_DAC_REG_GET(x)      (((x) & ADDAC_ADDAC1_DISABLE_DAC_REG_MASK) >> ADDAC_ADDAC1_DISABLE_DAC_REG_LSB)
+#define ADDAC_ADDAC1_DISABLE_DAC_REG_SET(x)      (((x) << ADDAC_ADDAC1_DISABLE_DAC_REG_LSB) & ADDAC_ADDAC1_DISABLE_DAC_REG_MASK)
+#define ADDAC_ADDAC1_SPARE_MSB                   5
+#define ADDAC_ADDAC1_SPARE_LSB                   0
+#define ADDAC_ADDAC1_SPARE_MASK                  0x0000003f
+#define ADDAC_ADDAC1_SPARE_GET(x)                (((x) & ADDAC_ADDAC1_SPARE_MASK) >> ADDAC_ADDAC1_SPARE_LSB)
+#define ADDAC_ADDAC1_SPARE_SET(x)                (((x) << ADDAC_ADDAC1_SPARE_LSB) & ADDAC_ADDAC1_SPARE_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct analog_reg_reg_s {
+  volatile unsigned int synth_synth1;
+  volatile unsigned int synth_synth2;
+  volatile unsigned int synth_synth3;
+  volatile unsigned int synth_synth4;
+  volatile unsigned int synth_synth5;
+  volatile unsigned int synth_synth6;
+  volatile unsigned int synth_synth7;
+  volatile unsigned int synth_synth8;
+  volatile unsigned int rf5g_rf5g1;
+  volatile unsigned int rf5g_rf5g2;
+  volatile unsigned int rf2g_rf2g1;
+  volatile unsigned int rf2g_rf2g2;
+  volatile unsigned int top_gain;
+  volatile unsigned int top_top;
+  volatile unsigned int bias_bias_sel;
+  volatile unsigned int bias_bias1;
+  volatile unsigned int bias_bias2;
+  volatile unsigned int bias_bias3;
+  volatile unsigned int txpc_txpc;
+  volatile unsigned int txpc_misc;
+  volatile unsigned int rxtxbb_rxtxbb1;
+  volatile unsigned int rxtxbb_rxtxbb2;
+  volatile unsigned int rxtxbb_rxtxbb3;
+  volatile unsigned int rxtxbb_rxtxbb4;
+  volatile unsigned int addac_addac1;
+} analog_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _ANALOG_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
new file mode 100644
index 0000000..f3bf6d6
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
@@ -0,0 +1,13 @@
+#ifndef _APB_MAP_H_
+#define _APB_MAP_H_
+
+#define RTC_BASE_ADDRESS                         0x00004000
+#define VMC_BASE_ADDRESS                         0x00008000
+#define UART_BASE_ADDRESS                        0x0000c000
+#define SI_BASE_ADDRESS                          0x00010000
+#define GPIO_BASE_ADDRESS                        0x00014000
+#define MBOX_BASE_ADDRESS                        0x00018000
+#define ANALOG_INTF_BASE_ADDRESS                 0x0001c000
+#define MAC_BASE_ADDRESS                         0x00020000
+
+#endif /* _APB_MAP_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
new file mode 100644
index 0000000..4f2b964
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
@@ -0,0 +1,977 @@
+#ifndef _GPIO_REG_REG_H_
+#define _GPIO_REG_REG_H_
+
+#define GPIO_OUT_ADDRESS                         0x00000000
+#define GPIO_OUT_OFFSET                          0x00000000
+#define GPIO_OUT_DATA_MSB                        17
+#define GPIO_OUT_DATA_LSB                        0
+#define GPIO_OUT_DATA_MASK                       0x0003ffff
+#define GPIO_OUT_DATA_GET(x)                     (((x) & GPIO_OUT_DATA_MASK) >> GPIO_OUT_DATA_LSB)
+#define GPIO_OUT_DATA_SET(x)                     (((x) << GPIO_OUT_DATA_LSB) & GPIO_OUT_DATA_MASK)
+
+#define GPIO_OUT_W1TS_ADDRESS                    0x00000004
+#define GPIO_OUT_W1TS_OFFSET                     0x00000004
+#define GPIO_OUT_W1TS_DATA_MSB                   17
+#define GPIO_OUT_W1TS_DATA_LSB                   0
+#define GPIO_OUT_W1TS_DATA_MASK                  0x0003ffff
+#define GPIO_OUT_W1TS_DATA_GET(x)                (((x) & GPIO_OUT_W1TS_DATA_MASK) >> GPIO_OUT_W1TS_DATA_LSB)
+#define GPIO_OUT_W1TS_DATA_SET(x)                (((x) << GPIO_OUT_W1TS_DATA_LSB) & GPIO_OUT_W1TS_DATA_MASK)
+
+#define GPIO_OUT_W1TC_ADDRESS                    0x00000008
+#define GPIO_OUT_W1TC_OFFSET                     0x00000008
+#define GPIO_OUT_W1TC_DATA_MSB                   17
+#define GPIO_OUT_W1TC_DATA_LSB                   0
+#define GPIO_OUT_W1TC_DATA_MASK                  0x0003ffff
+#define GPIO_OUT_W1TC_DATA_GET(x)                (((x) & GPIO_OUT_W1TC_DATA_MASK) >> GPIO_OUT_W1TC_DATA_LSB)
+#define GPIO_OUT_W1TC_DATA_SET(x)                (((x) << GPIO_OUT_W1TC_DATA_LSB) & GPIO_OUT_W1TC_DATA_MASK)
+
+#define GPIO_ENABLE_ADDRESS                      0x0000000c
+#define GPIO_ENABLE_OFFSET                       0x0000000c
+#define GPIO_ENABLE_DATA_MSB                     17
+#define GPIO_ENABLE_DATA_LSB                     0
+#define GPIO_ENABLE_DATA_MASK                    0x0003ffff
+#define GPIO_ENABLE_DATA_GET(x)                  (((x) & GPIO_ENABLE_DATA_MASK) >> GPIO_ENABLE_DATA_LSB)
+#define GPIO_ENABLE_DATA_SET(x)                  (((x) << GPIO_ENABLE_DATA_LSB) & GPIO_ENABLE_DATA_MASK)
+
+#define GPIO_ENABLE_W1TS_ADDRESS                 0x00000010
+#define GPIO_ENABLE_W1TS_OFFSET                  0x00000010
+#define GPIO_ENABLE_W1TS_DATA_MSB                17
+#define GPIO_ENABLE_W1TS_DATA_LSB                0
+#define GPIO_ENABLE_W1TS_DATA_MASK               0x0003ffff
+#define GPIO_ENABLE_W1TS_DATA_GET(x)             (((x) & GPIO_ENABLE_W1TS_DATA_MASK) >> GPIO_ENABLE_W1TS_DATA_LSB)
+#define GPIO_ENABLE_W1TS_DATA_SET(x)             (((x) << GPIO_ENABLE_W1TS_DATA_LSB) & GPIO_ENABLE_W1TS_DATA_MASK)
+
+#define GPIO_ENABLE_W1TC_ADDRESS                 0x00000014
+#define GPIO_ENABLE_W1TC_OFFSET                  0x00000014
+#define GPIO_ENABLE_W1TC_DATA_MSB                17
+#define GPIO_ENABLE_W1TC_DATA_LSB                0
+#define GPIO_ENABLE_W1TC_DATA_MASK               0x0003ffff
+#define GPIO_ENABLE_W1TC_DATA_GET(x)             (((x) & GPIO_ENABLE_W1TC_DATA_MASK) >> GPIO_ENABLE_W1TC_DATA_LSB)
+#define GPIO_ENABLE_W1TC_DATA_SET(x)             (((x) << GPIO_ENABLE_W1TC_DATA_LSB) & GPIO_ENABLE_W1TC_DATA_MASK)
+
+#define GPIO_IN_ADDRESS                          0x00000018
+#define GPIO_IN_OFFSET                           0x00000018
+#define GPIO_IN_DATA_MSB                         17
+#define GPIO_IN_DATA_LSB                         0
+#define GPIO_IN_DATA_MASK                        0x0003ffff
+#define GPIO_IN_DATA_GET(x)                      (((x) & GPIO_IN_DATA_MASK) >> GPIO_IN_DATA_LSB)
+#define GPIO_IN_DATA_SET(x)                      (((x) << GPIO_IN_DATA_LSB) & GPIO_IN_DATA_MASK)
+
+#define GPIO_STATUS_ADDRESS                      0x0000001c
+#define GPIO_STATUS_OFFSET                       0x0000001c
+#define GPIO_STATUS_INTERRUPT_MSB                17
+#define GPIO_STATUS_INTERRUPT_LSB                0
+#define GPIO_STATUS_INTERRUPT_MASK               0x0003ffff
+#define GPIO_STATUS_INTERRUPT_GET(x)             (((x) & GPIO_STATUS_INTERRUPT_MASK) >> GPIO_STATUS_INTERRUPT_LSB)
+#define GPIO_STATUS_INTERRUPT_SET(x)             (((x) << GPIO_STATUS_INTERRUPT_LSB) & GPIO_STATUS_INTERRUPT_MASK)
+
+#define GPIO_STATUS_W1TS_ADDRESS                 0x00000020
+#define GPIO_STATUS_W1TS_OFFSET                  0x00000020
+#define GPIO_STATUS_W1TS_INTERRUPT_MSB           17
+#define GPIO_STATUS_W1TS_INTERRUPT_LSB           0
+#define GPIO_STATUS_W1TS_INTERRUPT_MASK          0x0003ffff
+#define GPIO_STATUS_W1TS_INTERRUPT_GET(x)        (((x) & GPIO_STATUS_W1TS_INTERRUPT_MASK) >> GPIO_STATUS_W1TS_INTERRUPT_LSB)
+#define GPIO_STATUS_W1TS_INTERRUPT_SET(x)        (((x) << GPIO_STATUS_W1TS_INTERRUPT_LSB) & GPIO_STATUS_W1TS_INTERRUPT_MASK)
+
+#define GPIO_STATUS_W1TC_ADDRESS                 0x00000024
+#define GPIO_STATUS_W1TC_OFFSET                  0x00000024
+#define GPIO_STATUS_W1TC_INTERRUPT_MSB           17
+#define GPIO_STATUS_W1TC_INTERRUPT_LSB           0
+#define GPIO_STATUS_W1TC_INTERRUPT_MASK          0x0003ffff
+#define GPIO_STATUS_W1TC_INTERRUPT_GET(x)        (((x) & GPIO_STATUS_W1TC_INTERRUPT_MASK) >> GPIO_STATUS_W1TC_INTERRUPT_LSB)
+#define GPIO_STATUS_W1TC_INTERRUPT_SET(x)        (((x) << GPIO_STATUS_W1TC_INTERRUPT_LSB) & GPIO_STATUS_W1TC_INTERRUPT_MASK)
+
+#define GPIO_PIN0_ADDRESS                        0x00000028
+#define GPIO_PIN0_OFFSET                         0x00000028
+#define GPIO_PIN0_CONFIG_MSB                     12
+#define GPIO_PIN0_CONFIG_LSB                     11
+#define GPIO_PIN0_CONFIG_MASK                    0x00001800
+#define GPIO_PIN0_CONFIG_GET(x)                  (((x) & GPIO_PIN0_CONFIG_MASK) >> GPIO_PIN0_CONFIG_LSB)
+#define GPIO_PIN0_CONFIG_SET(x)                  (((x) << GPIO_PIN0_CONFIG_LSB) & GPIO_PIN0_CONFIG_MASK)
+#define GPIO_PIN0_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN0_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN0_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN0_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN0_WAKEUP_ENABLE_MASK) >> GPIO_PIN0_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN0_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN0_WAKEUP_ENABLE_LSB) & GPIO_PIN0_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN0_INT_TYPE_MSB                   9
+#define GPIO_PIN0_INT_TYPE_LSB                   7
+#define GPIO_PIN0_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN0_INT_TYPE_GET(x)                (((x) & GPIO_PIN0_INT_TYPE_MASK) >> GPIO_PIN0_INT_TYPE_LSB)
+#define GPIO_PIN0_INT_TYPE_SET(x)                (((x) << GPIO_PIN0_INT_TYPE_LSB) & GPIO_PIN0_INT_TYPE_MASK)
+#define GPIO_PIN0_PAD_DRIVER_MSB                 2
+#define GPIO_PIN0_PAD_DRIVER_LSB                 2
+#define GPIO_PIN0_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN0_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN0_PAD_DRIVER_MASK) >> GPIO_PIN0_PAD_DRIVER_LSB)
+#define GPIO_PIN0_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN0_PAD_DRIVER_LSB) & GPIO_PIN0_PAD_DRIVER_MASK)
+#define GPIO_PIN0_SOURCE_MSB                     0
+#define GPIO_PIN0_SOURCE_LSB                     0
+#define GPIO_PIN0_SOURCE_MASK                    0x00000001
+#define GPIO_PIN0_SOURCE_GET(x)                  (((x) & GPIO_PIN0_SOURCE_MASK) >> GPIO_PIN0_SOURCE_LSB)
+#define GPIO_PIN0_SOURCE_SET(x)                  (((x) << GPIO_PIN0_SOURCE_LSB) & GPIO_PIN0_SOURCE_MASK)
+
+#define GPIO_PIN1_ADDRESS                        0x0000002c
+#define GPIO_PIN1_OFFSET                         0x0000002c
+#define GPIO_PIN1_CONFIG_MSB                     12
+#define GPIO_PIN1_CONFIG_LSB                     11
+#define GPIO_PIN1_CONFIG_MASK                    0x00001800
+#define GPIO_PIN1_CONFIG_GET(x)                  (((x) & GPIO_PIN1_CONFIG_MASK) >> GPIO_PIN1_CONFIG_LSB)
+#define GPIO_PIN1_CONFIG_SET(x)                  (((x) << GPIO_PIN1_CONFIG_LSB) & GPIO_PIN1_CONFIG_MASK)
+#define GPIO_PIN1_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN1_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN1_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN1_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN1_WAKEUP_ENABLE_MASK) >> GPIO_PIN1_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN1_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN1_WAKEUP_ENABLE_LSB) & GPIO_PIN1_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN1_INT_TYPE_MSB                   9
+#define GPIO_PIN1_INT_TYPE_LSB                   7
+#define GPIO_PIN1_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN1_INT_TYPE_GET(x)                (((x) & GPIO_PIN1_INT_TYPE_MASK) >> GPIO_PIN1_INT_TYPE_LSB)
+#define GPIO_PIN1_INT_TYPE_SET(x)                (((x) << GPIO_PIN1_INT_TYPE_LSB) & GPIO_PIN1_INT_TYPE_MASK)
+#define GPIO_PIN1_PAD_DRIVER_MSB                 2
+#define GPIO_PIN1_PAD_DRIVER_LSB                 2
+#define GPIO_PIN1_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN1_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN1_PAD_DRIVER_MASK) >> GPIO_PIN1_PAD_DRIVER_LSB)
+#define GPIO_PIN1_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN1_PAD_DRIVER_LSB) & GPIO_PIN1_PAD_DRIVER_MASK)
+#define GPIO_PIN1_SOURCE_MSB                     0
+#define GPIO_PIN1_SOURCE_LSB                     0
+#define GPIO_PIN1_SOURCE_MASK                    0x00000001
+#define GPIO_PIN1_SOURCE_GET(x)                  (((x) & GPIO_PIN1_SOURCE_MASK) >> GPIO_PIN1_SOURCE_LSB)
+#define GPIO_PIN1_SOURCE_SET(x)                  (((x) << GPIO_PIN1_SOURCE_LSB) & GPIO_PIN1_SOURCE_MASK)
+
+#define GPIO_PIN2_ADDRESS                        0x00000030
+#define GPIO_PIN2_OFFSET                         0x00000030
+#define GPIO_PIN2_CONFIG_MSB                     12
+#define GPIO_PIN2_CONFIG_LSB                     11
+#define GPIO_PIN2_CONFIG_MASK                    0x00001800
+#define GPIO_PIN2_CONFIG_GET(x)                  (((x) & GPIO_PIN2_CONFIG_MASK) >> GPIO_PIN2_CONFIG_LSB)
+#define GPIO_PIN2_CONFIG_SET(x)                  (((x) << GPIO_PIN2_CONFIG_LSB) & GPIO_PIN2_CONFIG_MASK)
+#define GPIO_PIN2_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN2_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN2_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN2_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN2_WAKEUP_ENABLE_MASK) >> GPIO_PIN2_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN2_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN2_WAKEUP_ENABLE_LSB) & GPIO_PIN2_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN2_INT_TYPE_MSB                   9
+#define GPIO_PIN2_INT_TYPE_LSB                   7
+#define GPIO_PIN2_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN2_INT_TYPE_GET(x)                (((x) & GPIO_PIN2_INT_TYPE_MASK) >> GPIO_PIN2_INT_TYPE_LSB)
+#define GPIO_PIN2_INT_TYPE_SET(x)                (((x) << GPIO_PIN2_INT_TYPE_LSB) & GPIO_PIN2_INT_TYPE_MASK)
+#define GPIO_PIN2_PAD_DRIVER_MSB                 2
+#define GPIO_PIN2_PAD_DRIVER_LSB                 2
+#define GPIO_PIN2_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN2_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN2_PAD_DRIVER_MASK) >> GPIO_PIN2_PAD_DRIVER_LSB)
+#define GPIO_PIN2_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN2_PAD_DRIVER_LSB) & GPIO_PIN2_PAD_DRIVER_MASK)
+#define GPIO_PIN2_SOURCE_MSB                     0
+#define GPIO_PIN2_SOURCE_LSB                     0
+#define GPIO_PIN2_SOURCE_MASK                    0x00000001
+#define GPIO_PIN2_SOURCE_GET(x)                  (((x) & GPIO_PIN2_SOURCE_MASK) >> GPIO_PIN2_SOURCE_LSB)
+#define GPIO_PIN2_SOURCE_SET(x)                  (((x) << GPIO_PIN2_SOURCE_LSB) & GPIO_PIN2_SOURCE_MASK)
+
+#define GPIO_PIN3_ADDRESS                        0x00000034
+#define GPIO_PIN3_OFFSET                         0x00000034
+#define GPIO_PIN3_CONFIG_MSB                     12
+#define GPIO_PIN3_CONFIG_LSB                     11
+#define GPIO_PIN3_CONFIG_MASK                    0x00001800
+#define GPIO_PIN3_CONFIG_GET(x)                  (((x) & GPIO_PIN3_CONFIG_MASK) >> GPIO_PIN3_CONFIG_LSB)
+#define GPIO_PIN3_CONFIG_SET(x)                  (((x) << GPIO_PIN3_CONFIG_LSB) & GPIO_PIN3_CONFIG_MASK)
+#define GPIO_PIN3_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN3_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN3_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN3_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN3_WAKEUP_ENABLE_MASK) >> GPIO_PIN3_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN3_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN3_WAKEUP_ENABLE_LSB) & GPIO_PIN3_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN3_INT_TYPE_MSB                   9
+#define GPIO_PIN3_INT_TYPE_LSB                   7
+#define GPIO_PIN3_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN3_INT_TYPE_GET(x)                (((x) & GPIO_PIN3_INT_TYPE_MASK) >> GPIO_PIN3_INT_TYPE_LSB)
+#define GPIO_PIN3_INT_TYPE_SET(x)                (((x) << GPIO_PIN3_INT_TYPE_LSB) & GPIO_PIN3_INT_TYPE_MASK)
+#define GPIO_PIN3_PAD_DRIVER_MSB                 2
+#define GPIO_PIN3_PAD_DRIVER_LSB                 2
+#define GPIO_PIN3_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN3_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN3_PAD_DRIVER_MASK) >> GPIO_PIN3_PAD_DRIVER_LSB)
+#define GPIO_PIN3_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN3_PAD_DRIVER_LSB) & GPIO_PIN3_PAD_DRIVER_MASK)
+#define GPIO_PIN3_SOURCE_MSB                     0
+#define GPIO_PIN3_SOURCE_LSB                     0
+#define GPIO_PIN3_SOURCE_MASK                    0x00000001
+#define GPIO_PIN3_SOURCE_GET(x)                  (((x) & GPIO_PIN3_SOURCE_MASK) >> GPIO_PIN3_SOURCE_LSB)
+#define GPIO_PIN3_SOURCE_SET(x)                  (((x) << GPIO_PIN3_SOURCE_LSB) & GPIO_PIN3_SOURCE_MASK)
+
+#define GPIO_PIN4_ADDRESS                        0x00000038
+#define GPIO_PIN4_OFFSET                         0x00000038
+#define GPIO_PIN4_CONFIG_MSB                     12
+#define GPIO_PIN4_CONFIG_LSB                     11
+#define GPIO_PIN4_CONFIG_MASK                    0x00001800
+#define GPIO_PIN4_CONFIG_GET(x)                  (((x) & GPIO_PIN4_CONFIG_MASK) >> GPIO_PIN4_CONFIG_LSB)
+#define GPIO_PIN4_CONFIG_SET(x)                  (((x) << GPIO_PIN4_CONFIG_LSB) & GPIO_PIN4_CONFIG_MASK)
+#define GPIO_PIN4_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN4_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN4_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN4_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN4_WAKEUP_ENABLE_MASK) >> GPIO_PIN4_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN4_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN4_WAKEUP_ENABLE_LSB) & GPIO_PIN4_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN4_INT_TYPE_MSB                   9
+#define GPIO_PIN4_INT_TYPE_LSB                   7
+#define GPIO_PIN4_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN4_INT_TYPE_GET(x)                (((x) & GPIO_PIN4_INT_TYPE_MASK) >> GPIO_PIN4_INT_TYPE_LSB)
+#define GPIO_PIN4_INT_TYPE_SET(x)                (((x) << GPIO_PIN4_INT_TYPE_LSB) & GPIO_PIN4_INT_TYPE_MASK)
+#define GPIO_PIN4_PAD_DRIVER_MSB                 2
+#define GPIO_PIN4_PAD_DRIVER_LSB                 2
+#define GPIO_PIN4_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN4_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN4_PAD_DRIVER_MASK) >> GPIO_PIN4_PAD_DRIVER_LSB)
+#define GPIO_PIN4_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN4_PAD_DRIVER_LSB) & GPIO_PIN4_PAD_DRIVER_MASK)
+#define GPIO_PIN4_SOURCE_MSB                     0
+#define GPIO_PIN4_SOURCE_LSB                     0
+#define GPIO_PIN4_SOURCE_MASK                    0x00000001
+#define GPIO_PIN4_SOURCE_GET(x)                  (((x) & GPIO_PIN4_SOURCE_MASK) >> GPIO_PIN4_SOURCE_LSB)
+#define GPIO_PIN4_SOURCE_SET(x)                  (((x) << GPIO_PIN4_SOURCE_LSB) & GPIO_PIN4_SOURCE_MASK)
+
+#define GPIO_PIN5_ADDRESS                        0x0000003c
+#define GPIO_PIN5_OFFSET                         0x0000003c
+#define GPIO_PIN5_CONFIG_MSB                     12
+#define GPIO_PIN5_CONFIG_LSB                     11
+#define GPIO_PIN5_CONFIG_MASK                    0x00001800
+#define GPIO_PIN5_CONFIG_GET(x)                  (((x) & GPIO_PIN5_CONFIG_MASK) >> GPIO_PIN5_CONFIG_LSB)
+#define GPIO_PIN5_CONFIG_SET(x)                  (((x) << GPIO_PIN5_CONFIG_LSB) & GPIO_PIN5_CONFIG_MASK)
+#define GPIO_PIN5_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN5_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN5_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN5_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN5_WAKEUP_ENABLE_MASK) >> GPIO_PIN5_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN5_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN5_WAKEUP_ENABLE_LSB) & GPIO_PIN5_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN5_INT_TYPE_MSB                   9
+#define GPIO_PIN5_INT_TYPE_LSB                   7
+#define GPIO_PIN5_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN5_INT_TYPE_GET(x)                (((x) & GPIO_PIN5_INT_TYPE_MASK) >> GPIO_PIN5_INT_TYPE_LSB)
+#define GPIO_PIN5_INT_TYPE_SET(x)                (((x) << GPIO_PIN5_INT_TYPE_LSB) & GPIO_PIN5_INT_TYPE_MASK)
+#define GPIO_PIN5_PAD_DRIVER_MSB                 2
+#define GPIO_PIN5_PAD_DRIVER_LSB                 2
+#define GPIO_PIN5_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN5_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN5_PAD_DRIVER_MASK) >> GPIO_PIN5_PAD_DRIVER_LSB)
+#define GPIO_PIN5_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN5_PAD_DRIVER_LSB) & GPIO_PIN5_PAD_DRIVER_MASK)
+#define GPIO_PIN5_SOURCE_MSB                     0
+#define GPIO_PIN5_SOURCE_LSB                     0
+#define GPIO_PIN5_SOURCE_MASK                    0x00000001
+#define GPIO_PIN5_SOURCE_GET(x)                  (((x) & GPIO_PIN5_SOURCE_MASK) >> GPIO_PIN5_SOURCE_LSB)
+#define GPIO_PIN5_SOURCE_SET(x)                  (((x) << GPIO_PIN5_SOURCE_LSB) & GPIO_PIN5_SOURCE_MASK)
+
+#define GPIO_PIN6_ADDRESS                        0x00000040
+#define GPIO_PIN6_OFFSET                         0x00000040
+#define GPIO_PIN6_CONFIG_MSB                     12
+#define GPIO_PIN6_CONFIG_LSB                     11
+#define GPIO_PIN6_CONFIG_MASK                    0x00001800
+#define GPIO_PIN6_CONFIG_GET(x)                  (((x) & GPIO_PIN6_CONFIG_MASK) >> GPIO_PIN6_CONFIG_LSB)
+#define GPIO_PIN6_CONFIG_SET(x)                  (((x) << GPIO_PIN6_CONFIG_LSB) & GPIO_PIN6_CONFIG_MASK)
+#define GPIO_PIN6_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN6_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN6_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN6_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN6_WAKEUP_ENABLE_MASK) >> GPIO_PIN6_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN6_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN6_WAKEUP_ENABLE_LSB) & GPIO_PIN6_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN6_INT_TYPE_MSB                   9
+#define GPIO_PIN6_INT_TYPE_LSB                   7
+#define GPIO_PIN6_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN6_INT_TYPE_GET(x)                (((x) & GPIO_PIN6_INT_TYPE_MASK) >> GPIO_PIN6_INT_TYPE_LSB)
+#define GPIO_PIN6_INT_TYPE_SET(x)                (((x) << GPIO_PIN6_INT_TYPE_LSB) & GPIO_PIN6_INT_TYPE_MASK)
+#define GPIO_PIN6_PAD_DRIVER_MSB                 2
+#define GPIO_PIN6_PAD_DRIVER_LSB                 2
+#define GPIO_PIN6_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN6_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN6_PAD_DRIVER_MASK) >> GPIO_PIN6_PAD_DRIVER_LSB)
+#define GPIO_PIN6_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN6_PAD_DRIVER_LSB) & GPIO_PIN6_PAD_DRIVER_MASK)
+#define GPIO_PIN6_SOURCE_MSB                     0
+#define GPIO_PIN6_SOURCE_LSB                     0
+#define GPIO_PIN6_SOURCE_MASK                    0x00000001
+#define GPIO_PIN6_SOURCE_GET(x)                  (((x) & GPIO_PIN6_SOURCE_MASK) >> GPIO_PIN6_SOURCE_LSB)
+#define GPIO_PIN6_SOURCE_SET(x)                  (((x) << GPIO_PIN6_SOURCE_LSB) & GPIO_PIN6_SOURCE_MASK)
+
+#define GPIO_PIN7_ADDRESS                        0x00000044
+#define GPIO_PIN7_OFFSET                         0x00000044
+#define GPIO_PIN7_CONFIG_MSB                     12
+#define GPIO_PIN7_CONFIG_LSB                     11
+#define GPIO_PIN7_CONFIG_MASK                    0x00001800
+#define GPIO_PIN7_CONFIG_GET(x)                  (((x) & GPIO_PIN7_CONFIG_MASK) >> GPIO_PIN7_CONFIG_LSB)
+#define GPIO_PIN7_CONFIG_SET(x)                  (((x) << GPIO_PIN7_CONFIG_LSB) & GPIO_PIN7_CONFIG_MASK)
+#define GPIO_PIN7_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN7_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN7_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN7_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN7_WAKEUP_ENABLE_MASK) >> GPIO_PIN7_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN7_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN7_WAKEUP_ENABLE_LSB) & GPIO_PIN7_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN7_INT_TYPE_MSB                   9
+#define GPIO_PIN7_INT_TYPE_LSB                   7
+#define GPIO_PIN7_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN7_INT_TYPE_GET(x)                (((x) & GPIO_PIN7_INT_TYPE_MASK) >> GPIO_PIN7_INT_TYPE_LSB)
+#define GPIO_PIN7_INT_TYPE_SET(x)                (((x) << GPIO_PIN7_INT_TYPE_LSB) & GPIO_PIN7_INT_TYPE_MASK)
+#define GPIO_PIN7_PAD_DRIVER_MSB                 2
+#define GPIO_PIN7_PAD_DRIVER_LSB                 2
+#define GPIO_PIN7_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN7_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN7_PAD_DRIVER_MASK) >> GPIO_PIN7_PAD_DRIVER_LSB)
+#define GPIO_PIN7_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN7_PAD_DRIVER_LSB) & GPIO_PIN7_PAD_DRIVER_MASK)
+#define GPIO_PIN7_SOURCE_MSB                     0
+#define GPIO_PIN7_SOURCE_LSB                     0
+#define GPIO_PIN7_SOURCE_MASK                    0x00000001
+#define GPIO_PIN7_SOURCE_GET(x)                  (((x) & GPIO_PIN7_SOURCE_MASK) >> GPIO_PIN7_SOURCE_LSB)
+#define GPIO_PIN7_SOURCE_SET(x)                  (((x) << GPIO_PIN7_SOURCE_LSB) & GPIO_PIN7_SOURCE_MASK)
+
+#define GPIO_PIN8_ADDRESS                        0x00000048
+#define GPIO_PIN8_OFFSET                         0x00000048
+#define GPIO_PIN8_CONFIG_MSB                     12
+#define GPIO_PIN8_CONFIG_LSB                     11
+#define GPIO_PIN8_CONFIG_MASK                    0x00001800
+#define GPIO_PIN8_CONFIG_GET(x)                  (((x) & GPIO_PIN8_CONFIG_MASK) >> GPIO_PIN8_CONFIG_LSB)
+#define GPIO_PIN8_CONFIG_SET(x)                  (((x) << GPIO_PIN8_CONFIG_LSB) & GPIO_PIN8_CONFIG_MASK)
+#define GPIO_PIN8_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN8_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN8_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN8_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN8_WAKEUP_ENABLE_MASK) >> GPIO_PIN8_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN8_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN8_WAKEUP_ENABLE_LSB) & GPIO_PIN8_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN8_INT_TYPE_MSB                   9
+#define GPIO_PIN8_INT_TYPE_LSB                   7
+#define GPIO_PIN8_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN8_INT_TYPE_GET(x)                (((x) & GPIO_PIN8_INT_TYPE_MASK) >> GPIO_PIN8_INT_TYPE_LSB)
+#define GPIO_PIN8_INT_TYPE_SET(x)                (((x) << GPIO_PIN8_INT_TYPE_LSB) & GPIO_PIN8_INT_TYPE_MASK)
+#define GPIO_PIN8_PAD_DRIVER_MSB                 2
+#define GPIO_PIN8_PAD_DRIVER_LSB                 2
+#define GPIO_PIN8_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN8_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN8_PAD_DRIVER_MASK) >> GPIO_PIN8_PAD_DRIVER_LSB)
+#define GPIO_PIN8_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN8_PAD_DRIVER_LSB) & GPIO_PIN8_PAD_DRIVER_MASK)
+#define GPIO_PIN8_SOURCE_MSB                     0
+#define GPIO_PIN8_SOURCE_LSB                     0
+#define GPIO_PIN8_SOURCE_MASK                    0x00000001
+#define GPIO_PIN8_SOURCE_GET(x)                  (((x) & GPIO_PIN8_SOURCE_MASK) >> GPIO_PIN8_SOURCE_LSB)
+#define GPIO_PIN8_SOURCE_SET(x)                  (((x) << GPIO_PIN8_SOURCE_LSB) & GPIO_PIN8_SOURCE_MASK)
+
+#define GPIO_PIN9_ADDRESS                        0x0000004c
+#define GPIO_PIN9_OFFSET                         0x0000004c
+#define GPIO_PIN9_CONFIG_MSB                     12
+#define GPIO_PIN9_CONFIG_LSB                     11
+#define GPIO_PIN9_CONFIG_MASK                    0x00001800
+#define GPIO_PIN9_CONFIG_GET(x)                  (((x) & GPIO_PIN9_CONFIG_MASK) >> GPIO_PIN9_CONFIG_LSB)
+#define GPIO_PIN9_CONFIG_SET(x)                  (((x) << GPIO_PIN9_CONFIG_LSB) & GPIO_PIN9_CONFIG_MASK)
+#define GPIO_PIN9_WAKEUP_ENABLE_MSB              10
+#define GPIO_PIN9_WAKEUP_ENABLE_LSB              10
+#define GPIO_PIN9_WAKEUP_ENABLE_MASK             0x00000400
+#define GPIO_PIN9_WAKEUP_ENABLE_GET(x)           (((x) & GPIO_PIN9_WAKEUP_ENABLE_MASK) >> GPIO_PIN9_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN9_WAKEUP_ENABLE_SET(x)           (((x) << GPIO_PIN9_WAKEUP_ENABLE_LSB) & GPIO_PIN9_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN9_INT_TYPE_MSB                   9
+#define GPIO_PIN9_INT_TYPE_LSB                   7
+#define GPIO_PIN9_INT_TYPE_MASK                  0x00000380
+#define GPIO_PIN9_INT_TYPE_GET(x)                (((x) & GPIO_PIN9_INT_TYPE_MASK) >> GPIO_PIN9_INT_TYPE_LSB)
+#define GPIO_PIN9_INT_TYPE_SET(x)                (((x) << GPIO_PIN9_INT_TYPE_LSB) & GPIO_PIN9_INT_TYPE_MASK)
+#define GPIO_PIN9_PAD_DRIVER_MSB                 2
+#define GPIO_PIN9_PAD_DRIVER_LSB                 2
+#define GPIO_PIN9_PAD_DRIVER_MASK                0x00000004
+#define GPIO_PIN9_PAD_DRIVER_GET(x)              (((x) & GPIO_PIN9_PAD_DRIVER_MASK) >> GPIO_PIN9_PAD_DRIVER_LSB)
+#define GPIO_PIN9_PAD_DRIVER_SET(x)              (((x) << GPIO_PIN9_PAD_DRIVER_LSB) & GPIO_PIN9_PAD_DRIVER_MASK)
+#define GPIO_PIN9_SOURCE_MSB                     0
+#define GPIO_PIN9_SOURCE_LSB                     0
+#define GPIO_PIN9_SOURCE_MASK                    0x00000001
+#define GPIO_PIN9_SOURCE_GET(x)                  (((x) & GPIO_PIN9_SOURCE_MASK) >> GPIO_PIN9_SOURCE_LSB)
+#define GPIO_PIN9_SOURCE_SET(x)                  (((x) << GPIO_PIN9_SOURCE_LSB) & GPIO_PIN9_SOURCE_MASK)
+
+#define GPIO_PIN10_ADDRESS                       0x00000050
+#define GPIO_PIN10_OFFSET                        0x00000050
+#define GPIO_PIN10_CONFIG_MSB                    12
+#define GPIO_PIN10_CONFIG_LSB                    11
+#define GPIO_PIN10_CONFIG_MASK                   0x00001800
+#define GPIO_PIN10_CONFIG_GET(x)                 (((x) & GPIO_PIN10_CONFIG_MASK) >> GPIO_PIN10_CONFIG_LSB)
+#define GPIO_PIN10_CONFIG_SET(x)                 (((x) << GPIO_PIN10_CONFIG_LSB) & GPIO_PIN10_CONFIG_MASK)
+#define GPIO_PIN10_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN10_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN10_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN10_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN10_WAKEUP_ENABLE_MASK) >> GPIO_PIN10_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN10_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN10_WAKEUP_ENABLE_LSB) & GPIO_PIN10_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN10_INT_TYPE_MSB                  9
+#define GPIO_PIN10_INT_TYPE_LSB                  7
+#define GPIO_PIN10_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN10_INT_TYPE_GET(x)               (((x) & GPIO_PIN10_INT_TYPE_MASK) >> GPIO_PIN10_INT_TYPE_LSB)
+#define GPIO_PIN10_INT_TYPE_SET(x)               (((x) << GPIO_PIN10_INT_TYPE_LSB) & GPIO_PIN10_INT_TYPE_MASK)
+#define GPIO_PIN10_PAD_DRIVER_MSB                2
+#define GPIO_PIN10_PAD_DRIVER_LSB                2
+#define GPIO_PIN10_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN10_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN10_PAD_DRIVER_MASK) >> GPIO_PIN10_PAD_DRIVER_LSB)
+#define GPIO_PIN10_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN10_PAD_DRIVER_LSB) & GPIO_PIN10_PAD_DRIVER_MASK)
+#define GPIO_PIN10_SOURCE_MSB                    0
+#define GPIO_PIN10_SOURCE_LSB                    0
+#define GPIO_PIN10_SOURCE_MASK                   0x00000001
+#define GPIO_PIN10_SOURCE_GET(x)                 (((x) & GPIO_PIN10_SOURCE_MASK) >> GPIO_PIN10_SOURCE_LSB)
+#define GPIO_PIN10_SOURCE_SET(x)                 (((x) << GPIO_PIN10_SOURCE_LSB) & GPIO_PIN10_SOURCE_MASK)
+
+#define GPIO_PIN11_ADDRESS                       0x00000054
+#define GPIO_PIN11_OFFSET                        0x00000054
+#define GPIO_PIN11_CONFIG_MSB                    12
+#define GPIO_PIN11_CONFIG_LSB                    11
+#define GPIO_PIN11_CONFIG_MASK                   0x00001800
+#define GPIO_PIN11_CONFIG_GET(x)                 (((x) & GPIO_PIN11_CONFIG_MASK) >> GPIO_PIN11_CONFIG_LSB)
+#define GPIO_PIN11_CONFIG_SET(x)                 (((x) << GPIO_PIN11_CONFIG_LSB) & GPIO_PIN11_CONFIG_MASK)
+#define GPIO_PIN11_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN11_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN11_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN11_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN11_WAKEUP_ENABLE_MASK) >> GPIO_PIN11_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN11_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN11_WAKEUP_ENABLE_LSB) & GPIO_PIN11_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN11_INT_TYPE_MSB                  9
+#define GPIO_PIN11_INT_TYPE_LSB                  7
+#define GPIO_PIN11_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN11_INT_TYPE_GET(x)               (((x) & GPIO_PIN11_INT_TYPE_MASK) >> GPIO_PIN11_INT_TYPE_LSB)
+#define GPIO_PIN11_INT_TYPE_SET(x)               (((x) << GPIO_PIN11_INT_TYPE_LSB) & GPIO_PIN11_INT_TYPE_MASK)
+#define GPIO_PIN11_PAD_DRIVER_MSB                2
+#define GPIO_PIN11_PAD_DRIVER_LSB                2
+#define GPIO_PIN11_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN11_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN11_PAD_DRIVER_MASK) >> GPIO_PIN11_PAD_DRIVER_LSB)
+#define GPIO_PIN11_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN11_PAD_DRIVER_LSB) & GPIO_PIN11_PAD_DRIVER_MASK)
+#define GPIO_PIN11_SOURCE_MSB                    0
+#define GPIO_PIN11_SOURCE_LSB                    0
+#define GPIO_PIN11_SOURCE_MASK                   0x00000001
+#define GPIO_PIN11_SOURCE_GET(x)                 (((x) & GPIO_PIN11_SOURCE_MASK) >> GPIO_PIN11_SOURCE_LSB)
+#define GPIO_PIN11_SOURCE_SET(x)                 (((x) << GPIO_PIN11_SOURCE_LSB) & GPIO_PIN11_SOURCE_MASK)
+
+#define GPIO_PIN12_ADDRESS                       0x00000058
+#define GPIO_PIN12_OFFSET                        0x00000058
+#define GPIO_PIN12_CONFIG_MSB                    12
+#define GPIO_PIN12_CONFIG_LSB                    11
+#define GPIO_PIN12_CONFIG_MASK                   0x00001800
+#define GPIO_PIN12_CONFIG_GET(x)                 (((x) & GPIO_PIN12_CONFIG_MASK) >> GPIO_PIN12_CONFIG_LSB)
+#define GPIO_PIN12_CONFIG_SET(x)                 (((x) << GPIO_PIN12_CONFIG_LSB) & GPIO_PIN12_CONFIG_MASK)
+#define GPIO_PIN12_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN12_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN12_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN12_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN12_WAKEUP_ENABLE_MASK) >> GPIO_PIN12_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN12_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN12_WAKEUP_ENABLE_LSB) & GPIO_PIN12_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN12_INT_TYPE_MSB                  9
+#define GPIO_PIN12_INT_TYPE_LSB                  7
+#define GPIO_PIN12_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN12_INT_TYPE_GET(x)               (((x) & GPIO_PIN12_INT_TYPE_MASK) >> GPIO_PIN12_INT_TYPE_LSB)
+#define GPIO_PIN12_INT_TYPE_SET(x)               (((x) << GPIO_PIN12_INT_TYPE_LSB) & GPIO_PIN12_INT_TYPE_MASK)
+#define GPIO_PIN12_PAD_DRIVER_MSB                2
+#define GPIO_PIN12_PAD_DRIVER_LSB                2
+#define GPIO_PIN12_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN12_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN12_PAD_DRIVER_MASK) >> GPIO_PIN12_PAD_DRIVER_LSB)
+#define GPIO_PIN12_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN12_PAD_DRIVER_LSB) & GPIO_PIN12_PAD_DRIVER_MASK)
+#define GPIO_PIN12_SOURCE_MSB                    0
+#define GPIO_PIN12_SOURCE_LSB                    0
+#define GPIO_PIN12_SOURCE_MASK                   0x00000001
+#define GPIO_PIN12_SOURCE_GET(x)                 (((x) & GPIO_PIN12_SOURCE_MASK) >> GPIO_PIN12_SOURCE_LSB)
+#define GPIO_PIN12_SOURCE_SET(x)                 (((x) << GPIO_PIN12_SOURCE_LSB) & GPIO_PIN12_SOURCE_MASK)
+
+#define GPIO_PIN13_ADDRESS                       0x0000005c
+#define GPIO_PIN13_OFFSET                        0x0000005c
+#define GPIO_PIN13_CONFIG_MSB                    12
+#define GPIO_PIN13_CONFIG_LSB                    11
+#define GPIO_PIN13_CONFIG_MASK                   0x00001800
+#define GPIO_PIN13_CONFIG_GET(x)                 (((x) & GPIO_PIN13_CONFIG_MASK) >> GPIO_PIN13_CONFIG_LSB)
+#define GPIO_PIN13_CONFIG_SET(x)                 (((x) << GPIO_PIN13_CONFIG_LSB) & GPIO_PIN13_CONFIG_MASK)
+#define GPIO_PIN13_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN13_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN13_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN13_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN13_WAKEUP_ENABLE_MASK) >> GPIO_PIN13_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN13_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN13_WAKEUP_ENABLE_LSB) & GPIO_PIN13_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN13_INT_TYPE_MSB                  9
+#define GPIO_PIN13_INT_TYPE_LSB                  7
+#define GPIO_PIN13_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN13_INT_TYPE_GET(x)               (((x) & GPIO_PIN13_INT_TYPE_MASK) >> GPIO_PIN13_INT_TYPE_LSB)
+#define GPIO_PIN13_INT_TYPE_SET(x)               (((x) << GPIO_PIN13_INT_TYPE_LSB) & GPIO_PIN13_INT_TYPE_MASK)
+#define GPIO_PIN13_PAD_DRIVER_MSB                2
+#define GPIO_PIN13_PAD_DRIVER_LSB                2
+#define GPIO_PIN13_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN13_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN13_PAD_DRIVER_MASK) >> GPIO_PIN13_PAD_DRIVER_LSB)
+#define GPIO_PIN13_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN13_PAD_DRIVER_LSB) & GPIO_PIN13_PAD_DRIVER_MASK)
+#define GPIO_PIN13_SOURCE_MSB                    0
+#define GPIO_PIN13_SOURCE_LSB                    0
+#define GPIO_PIN13_SOURCE_MASK                   0x00000001
+#define GPIO_PIN13_SOURCE_GET(x)                 (((x) & GPIO_PIN13_SOURCE_MASK) >> GPIO_PIN13_SOURCE_LSB)
+#define GPIO_PIN13_SOURCE_SET(x)                 (((x) << GPIO_PIN13_SOURCE_LSB) & GPIO_PIN13_SOURCE_MASK)
+
+#define GPIO_PIN14_ADDRESS                       0x00000060
+#define GPIO_PIN14_OFFSET                        0x00000060
+#define GPIO_PIN14_CONFIG_MSB                    12
+#define GPIO_PIN14_CONFIG_LSB                    11
+#define GPIO_PIN14_CONFIG_MASK                   0x00001800
+#define GPIO_PIN14_CONFIG_GET(x)                 (((x) & GPIO_PIN14_CONFIG_MASK) >> GPIO_PIN14_CONFIG_LSB)
+#define GPIO_PIN14_CONFIG_SET(x)                 (((x) << GPIO_PIN14_CONFIG_LSB) & GPIO_PIN14_CONFIG_MASK)
+#define GPIO_PIN14_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN14_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN14_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN14_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN14_WAKEUP_ENABLE_MASK) >> GPIO_PIN14_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN14_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN14_WAKEUP_ENABLE_LSB) & GPIO_PIN14_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN14_INT_TYPE_MSB                  9
+#define GPIO_PIN14_INT_TYPE_LSB                  7
+#define GPIO_PIN14_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN14_INT_TYPE_GET(x)               (((x) & GPIO_PIN14_INT_TYPE_MASK) >> GPIO_PIN14_INT_TYPE_LSB)
+#define GPIO_PIN14_INT_TYPE_SET(x)               (((x) << GPIO_PIN14_INT_TYPE_LSB) & GPIO_PIN14_INT_TYPE_MASK)
+#define GPIO_PIN14_PAD_DRIVER_MSB                2
+#define GPIO_PIN14_PAD_DRIVER_LSB                2
+#define GPIO_PIN14_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN14_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN14_PAD_DRIVER_MASK) >> GPIO_PIN14_PAD_DRIVER_LSB)
+#define GPIO_PIN14_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN14_PAD_DRIVER_LSB) & GPIO_PIN14_PAD_DRIVER_MASK)
+#define GPIO_PIN14_SOURCE_MSB                    0
+#define GPIO_PIN14_SOURCE_LSB                    0
+#define GPIO_PIN14_SOURCE_MASK                   0x00000001
+#define GPIO_PIN14_SOURCE_GET(x)                 (((x) & GPIO_PIN14_SOURCE_MASK) >> GPIO_PIN14_SOURCE_LSB)
+#define GPIO_PIN14_SOURCE_SET(x)                 (((x) << GPIO_PIN14_SOURCE_LSB) & GPIO_PIN14_SOURCE_MASK)
+
+#define GPIO_PIN15_ADDRESS                       0x00000064
+#define GPIO_PIN15_OFFSET                        0x00000064
+#define GPIO_PIN15_CONFIG_MSB                    12
+#define GPIO_PIN15_CONFIG_LSB                    11
+#define GPIO_PIN15_CONFIG_MASK                   0x00001800
+#define GPIO_PIN15_CONFIG_GET(x)                 (((x) & GPIO_PIN15_CONFIG_MASK) >> GPIO_PIN15_CONFIG_LSB)
+#define GPIO_PIN15_CONFIG_SET(x)                 (((x) << GPIO_PIN15_CONFIG_LSB) & GPIO_PIN15_CONFIG_MASK)
+#define GPIO_PIN15_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN15_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN15_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN15_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN15_WAKEUP_ENABLE_MASK) >> GPIO_PIN15_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN15_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN15_WAKEUP_ENABLE_LSB) & GPIO_PIN15_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN15_INT_TYPE_MSB                  9
+#define GPIO_PIN15_INT_TYPE_LSB                  7
+#define GPIO_PIN15_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN15_INT_TYPE_GET(x)               (((x) & GPIO_PIN15_INT_TYPE_MASK) >> GPIO_PIN15_INT_TYPE_LSB)
+#define GPIO_PIN15_INT_TYPE_SET(x)               (((x) << GPIO_PIN15_INT_TYPE_LSB) & GPIO_PIN15_INT_TYPE_MASK)
+#define GPIO_PIN15_PAD_DRIVER_MSB                2
+#define GPIO_PIN15_PAD_DRIVER_LSB                2
+#define GPIO_PIN15_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN15_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN15_PAD_DRIVER_MASK) >> GPIO_PIN15_PAD_DRIVER_LSB)
+#define GPIO_PIN15_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN15_PAD_DRIVER_LSB) & GPIO_PIN15_PAD_DRIVER_MASK)
+#define GPIO_PIN15_SOURCE_MSB                    0
+#define GPIO_PIN15_SOURCE_LSB                    0
+#define GPIO_PIN15_SOURCE_MASK                   0x00000001
+#define GPIO_PIN15_SOURCE_GET(x)                 (((x) & GPIO_PIN15_SOURCE_MASK) >> GPIO_PIN15_SOURCE_LSB)
+#define GPIO_PIN15_SOURCE_SET(x)                 (((x) << GPIO_PIN15_SOURCE_LSB) & GPIO_PIN15_SOURCE_MASK)
+
+#define GPIO_PIN16_ADDRESS                       0x00000068
+#define GPIO_PIN16_OFFSET                        0x00000068
+#define GPIO_PIN16_CONFIG_MSB                    12
+#define GPIO_PIN16_CONFIG_LSB                    11
+#define GPIO_PIN16_CONFIG_MASK                   0x00001800
+#define GPIO_PIN16_CONFIG_GET(x)                 (((x) & GPIO_PIN16_CONFIG_MASK) >> GPIO_PIN16_CONFIG_LSB)
+#define GPIO_PIN16_CONFIG_SET(x)                 (((x) << GPIO_PIN16_CONFIG_LSB) & GPIO_PIN16_CONFIG_MASK)
+#define GPIO_PIN16_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN16_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN16_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN16_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN16_WAKEUP_ENABLE_MASK) >> GPIO_PIN16_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN16_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN16_WAKEUP_ENABLE_LSB) & GPIO_PIN16_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN16_INT_TYPE_MSB                  9
+#define GPIO_PIN16_INT_TYPE_LSB                  7
+#define GPIO_PIN16_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN16_INT_TYPE_GET(x)               (((x) & GPIO_PIN16_INT_TYPE_MASK) >> GPIO_PIN16_INT_TYPE_LSB)
+#define GPIO_PIN16_INT_TYPE_SET(x)               (((x) << GPIO_PIN16_INT_TYPE_LSB) & GPIO_PIN16_INT_TYPE_MASK)
+#define GPIO_PIN16_PAD_DRIVER_MSB                2
+#define GPIO_PIN16_PAD_DRIVER_LSB                2
+#define GPIO_PIN16_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN16_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN16_PAD_DRIVER_MASK) >> GPIO_PIN16_PAD_DRIVER_LSB)
+#define GPIO_PIN16_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN16_PAD_DRIVER_LSB) & GPIO_PIN16_PAD_DRIVER_MASK)
+#define GPIO_PIN16_SOURCE_MSB                    0
+#define GPIO_PIN16_SOURCE_LSB                    0
+#define GPIO_PIN16_SOURCE_MASK                   0x00000001
+#define GPIO_PIN16_SOURCE_GET(x)                 (((x) & GPIO_PIN16_SOURCE_MASK) >> GPIO_PIN16_SOURCE_LSB)
+#define GPIO_PIN16_SOURCE_SET(x)                 (((x) << GPIO_PIN16_SOURCE_LSB) & GPIO_PIN16_SOURCE_MASK)
+
+#define GPIO_PIN17_ADDRESS                       0x0000006c
+#define GPIO_PIN17_OFFSET                        0x0000006c
+#define GPIO_PIN17_CONFIG_MSB                    12
+#define GPIO_PIN17_CONFIG_LSB                    11
+#define GPIO_PIN17_CONFIG_MASK                   0x00001800
+#define GPIO_PIN17_CONFIG_GET(x)                 (((x) & GPIO_PIN17_CONFIG_MASK) >> GPIO_PIN17_CONFIG_LSB)
+#define GPIO_PIN17_CONFIG_SET(x)                 (((x) << GPIO_PIN17_CONFIG_LSB) & GPIO_PIN17_CONFIG_MASK)
+#define GPIO_PIN17_WAKEUP_ENABLE_MSB             10
+#define GPIO_PIN17_WAKEUP_ENABLE_LSB             10
+#define GPIO_PIN17_WAKEUP_ENABLE_MASK            0x00000400
+#define GPIO_PIN17_WAKEUP_ENABLE_GET(x)          (((x) & GPIO_PIN17_WAKEUP_ENABLE_MASK) >> GPIO_PIN17_WAKEUP_ENABLE_LSB)
+#define GPIO_PIN17_WAKEUP_ENABLE_SET(x)          (((x) << GPIO_PIN17_WAKEUP_ENABLE_LSB) & GPIO_PIN17_WAKEUP_ENABLE_MASK)
+#define GPIO_PIN17_INT_TYPE_MSB                  9
+#define GPIO_PIN17_INT_TYPE_LSB                  7
+#define GPIO_PIN17_INT_TYPE_MASK                 0x00000380
+#define GPIO_PIN17_INT_TYPE_GET(x)               (((x) & GPIO_PIN17_INT_TYPE_MASK) >> GPIO_PIN17_INT_TYPE_LSB)
+#define GPIO_PIN17_INT_TYPE_SET(x)               (((x) << GPIO_PIN17_INT_TYPE_LSB) & GPIO_PIN17_INT_TYPE_MASK)
+#define GPIO_PIN17_PAD_DRIVER_MSB                2
+#define GPIO_PIN17_PAD_DRIVER_LSB                2
+#define GPIO_PIN17_PAD_DRIVER_MASK               0x00000004
+#define GPIO_PIN17_PAD_DRIVER_GET(x)             (((x) & GPIO_PIN17_PAD_DRIVER_MASK) >> GPIO_PIN17_PAD_DRIVER_LSB)
+#define GPIO_PIN17_PAD_DRIVER_SET(x)             (((x) << GPIO_PIN17_PAD_DRIVER_LSB) & GPIO_PIN17_PAD_DRIVER_MASK)
+#define GPIO_PIN17_SOURCE_MSB                    0
+#define GPIO_PIN17_SOURCE_LSB                    0
+#define GPIO_PIN17_SOURCE_MASK                   0x00000001
+#define GPIO_PIN17_SOURCE_GET(x)                 (((x) & GPIO_PIN17_SOURCE_MASK) >> GPIO_PIN17_SOURCE_LSB)
+#define GPIO_PIN17_SOURCE_SET(x)                 (((x) << GPIO_PIN17_SOURCE_LSB) & GPIO_PIN17_SOURCE_MASK)
+
+#define SDIO_PIN_ADDRESS                         0x00000070
+#define SDIO_PIN_OFFSET                          0x00000070
+#define SDIO_PIN_PAD_PULL_MSB                    3
+#define SDIO_PIN_PAD_PULL_LSB                    2
+#define SDIO_PIN_PAD_PULL_MASK                   0x0000000c
+#define SDIO_PIN_PAD_PULL_GET(x)                 (((x) & SDIO_PIN_PAD_PULL_MASK) >> SDIO_PIN_PAD_PULL_LSB)
+#define SDIO_PIN_PAD_PULL_SET(x)                 (((x) << SDIO_PIN_PAD_PULL_LSB) & SDIO_PIN_PAD_PULL_MASK)
+#define SDIO_PIN_PAD_STRENGTH_MSB                1
+#define SDIO_PIN_PAD_STRENGTH_LSB                0
+#define SDIO_PIN_PAD_STRENGTH_MASK               0x00000003
+#define SDIO_PIN_PAD_STRENGTH_GET(x)             (((x) & SDIO_PIN_PAD_STRENGTH_MASK) >> SDIO_PIN_PAD_STRENGTH_LSB)
+#define SDIO_PIN_PAD_STRENGTH_SET(x)             (((x) << SDIO_PIN_PAD_STRENGTH_LSB) & SDIO_PIN_PAD_STRENGTH_MASK)
+
+#define CLK_REQ_PIN_ADDRESS                      0x00000074
+#define CLK_REQ_PIN_OFFSET                       0x00000074
+#define CLK_REQ_PIN_ATE_OE_L_MSB                 4
+#define CLK_REQ_PIN_ATE_OE_L_LSB                 4
+#define CLK_REQ_PIN_ATE_OE_L_MASK                0x00000010
+#define CLK_REQ_PIN_ATE_OE_L_GET(x)              (((x) & CLK_REQ_PIN_ATE_OE_L_MASK) >> CLK_REQ_PIN_ATE_OE_L_LSB)
+#define CLK_REQ_PIN_ATE_OE_L_SET(x)              (((x) << CLK_REQ_PIN_ATE_OE_L_LSB) & CLK_REQ_PIN_ATE_OE_L_MASK)
+#define CLK_REQ_PIN_PAD_PULL_MSB                 3
+#define CLK_REQ_PIN_PAD_PULL_LSB                 2
+#define CLK_REQ_PIN_PAD_PULL_MASK                0x0000000c
+#define CLK_REQ_PIN_PAD_PULL_GET(x)              (((x) & CLK_REQ_PIN_PAD_PULL_MASK) >> CLK_REQ_PIN_PAD_PULL_LSB)
+#define CLK_REQ_PIN_PAD_PULL_SET(x)              (((x) << CLK_REQ_PIN_PAD_PULL_LSB) & CLK_REQ_PIN_PAD_PULL_MASK)
+#define CLK_REQ_PIN_PAD_STRENGTH_MSB             1
+#define CLK_REQ_PIN_PAD_STRENGTH_LSB             0
+#define CLK_REQ_PIN_PAD_STRENGTH_MASK            0x00000003
+#define CLK_REQ_PIN_PAD_STRENGTH_GET(x)          (((x) & CLK_REQ_PIN_PAD_STRENGTH_MASK) >> CLK_REQ_PIN_PAD_STRENGTH_LSB)
+#define CLK_REQ_PIN_PAD_STRENGTH_SET(x)          (((x) << CLK_REQ_PIN_PAD_STRENGTH_LSB) & CLK_REQ_PIN_PAD_STRENGTH_MASK)
+
+#define SIGMA_DELTA_ADDRESS                      0x00000078
+#define SIGMA_DELTA_OFFSET                       0x00000078
+#define SIGMA_DELTA_ENABLE_MSB                   16
+#define SIGMA_DELTA_ENABLE_LSB                   16
+#define SIGMA_DELTA_ENABLE_MASK                  0x00010000
+#define SIGMA_DELTA_ENABLE_GET(x)                (((x) & SIGMA_DELTA_ENABLE_MASK) >> SIGMA_DELTA_ENABLE_LSB)
+#define SIGMA_DELTA_ENABLE_SET(x)                (((x) << SIGMA_DELTA_ENABLE_LSB) & SIGMA_DELTA_ENABLE_MASK)
+#define SIGMA_DELTA_PRESCALAR_MSB                15
+#define SIGMA_DELTA_PRESCALAR_LSB                8
+#define SIGMA_DELTA_PRESCALAR_MASK               0x0000ff00
+#define SIGMA_DELTA_PRESCALAR_GET(x)             (((x) & SIGMA_DELTA_PRESCALAR_MASK) >> SIGMA_DELTA_PRESCALAR_LSB)
+#define SIGMA_DELTA_PRESCALAR_SET(x)             (((x) << SIGMA_DELTA_PRESCALAR_LSB) & SIGMA_DELTA_PRESCALAR_MASK)
+#define SIGMA_DELTA_TARGET_MSB                   7
+#define SIGMA_DELTA_TARGET_LSB                   0
+#define SIGMA_DELTA_TARGET_MASK                  0x000000ff
+#define SIGMA_DELTA_TARGET_GET(x)                (((x) & SIGMA_DELTA_TARGET_MASK) >> SIGMA_DELTA_TARGET_LSB)
+#define SIGMA_DELTA_TARGET_SET(x)                (((x) << SIGMA_DELTA_TARGET_LSB) & SIGMA_DELTA_TARGET_MASK)
+
+#define DEBUG_CONTROL_ADDRESS                    0x0000007c
+#define DEBUG_CONTROL_OFFSET                     0x0000007c
+#define DEBUG_CONTROL_OBS_OE_L_MSB               1
+#define DEBUG_CONTROL_OBS_OE_L_LSB               1
+#define DEBUG_CONTROL_OBS_OE_L_MASK              0x00000002
+#define DEBUG_CONTROL_OBS_OE_L_GET(x)            (((x) & DEBUG_CONTROL_OBS_OE_L_MASK) >> DEBUG_CONTROL_OBS_OE_L_LSB)
+#define DEBUG_CONTROL_OBS_OE_L_SET(x)            (((x) << DEBUG_CONTROL_OBS_OE_L_LSB) & DEBUG_CONTROL_OBS_OE_L_MASK)
+#define DEBUG_CONTROL_ENABLE_MSB                 0
+#define DEBUG_CONTROL_ENABLE_LSB                 0
+#define DEBUG_CONTROL_ENABLE_MASK                0x00000001
+#define DEBUG_CONTROL_ENABLE_GET(x)              (((x) & DEBUG_CONTROL_ENABLE_MASK) >> DEBUG_CONTROL_ENABLE_LSB)
+#define DEBUG_CONTROL_ENABLE_SET(x)              (((x) << DEBUG_CONTROL_ENABLE_LSB) & DEBUG_CONTROL_ENABLE_MASK)
+
+#define DEBUG_INPUT_SEL_ADDRESS                  0x00000080
+#define DEBUG_INPUT_SEL_OFFSET                   0x00000080
+#define DEBUG_INPUT_SEL_SRC_MSB                  3
+#define DEBUG_INPUT_SEL_SRC_LSB                  0
+#define DEBUG_INPUT_SEL_SRC_MASK                 0x0000000f
+#define DEBUG_INPUT_SEL_SRC_GET(x)               (((x) & DEBUG_INPUT_SEL_SRC_MASK) >> DEBUG_INPUT_SEL_SRC_LSB)
+#define DEBUG_INPUT_SEL_SRC_SET(x)               (((x) << DEBUG_INPUT_SEL_SRC_LSB) & DEBUG_INPUT_SEL_SRC_MASK)
+
+#define DEBUG_OUT_ADDRESS                        0x00000084
+#define DEBUG_OUT_OFFSET                         0x00000084
+#define DEBUG_OUT_DATA_MSB                       17
+#define DEBUG_OUT_DATA_LSB                       0
+#define DEBUG_OUT_DATA_MASK                      0x0003ffff
+#define DEBUG_OUT_DATA_GET(x)                    (((x) & DEBUG_OUT_DATA_MASK) >> DEBUG_OUT_DATA_LSB)
+#define DEBUG_OUT_DATA_SET(x)                    (((x) << DEBUG_OUT_DATA_LSB) & DEBUG_OUT_DATA_MASK)
+
+#define LA_CONTROL_ADDRESS                       0x00000088
+#define LA_CONTROL_OFFSET                        0x00000088
+#define LA_CONTROL_RUN_MSB                       1
+#define LA_CONTROL_RUN_LSB                       1
+#define LA_CONTROL_RUN_MASK                      0x00000002
+#define LA_CONTROL_RUN_GET(x)                    (((x) & LA_CONTROL_RUN_MASK) >> LA_CONTROL_RUN_LSB)
+#define LA_CONTROL_RUN_SET(x)                    (((x) << LA_CONTROL_RUN_LSB) & LA_CONTROL_RUN_MASK)
+#define LA_CONTROL_TRIGGERED_MSB                 0
+#define LA_CONTROL_TRIGGERED_LSB                 0
+#define LA_CONTROL_TRIGGERED_MASK                0x00000001
+#define LA_CONTROL_TRIGGERED_GET(x)              (((x) & LA_CONTROL_TRIGGERED_MASK) >> LA_CONTROL_TRIGGERED_LSB)
+#define LA_CONTROL_TRIGGERED_SET(x)              (((x) << LA_CONTROL_TRIGGERED_LSB) & LA_CONTROL_TRIGGERED_MASK)
+
+#define LA_CLOCK_ADDRESS                         0x0000008c
+#define LA_CLOCK_OFFSET                          0x0000008c
+#define LA_CLOCK_DIV_MSB                         7
+#define LA_CLOCK_DIV_LSB                         0
+#define LA_CLOCK_DIV_MASK                        0x000000ff
+#define LA_CLOCK_DIV_GET(x)                      (((x) & LA_CLOCK_DIV_MASK) >> LA_CLOCK_DIV_LSB)
+#define LA_CLOCK_DIV_SET(x)                      (((x) << LA_CLOCK_DIV_LSB) & LA_CLOCK_DIV_MASK)
+
+#define LA_STATUS_ADDRESS                        0x00000090
+#define LA_STATUS_OFFSET                         0x00000090
+#define LA_STATUS_INTERRUPT_MSB                  0
+#define LA_STATUS_INTERRUPT_LSB                  0
+#define LA_STATUS_INTERRUPT_MASK                 0x00000001
+#define LA_STATUS_INTERRUPT_GET(x)               (((x) & LA_STATUS_INTERRUPT_MASK) >> LA_STATUS_INTERRUPT_LSB)
+#define LA_STATUS_INTERRUPT_SET(x)               (((x) << LA_STATUS_INTERRUPT_LSB) & LA_STATUS_INTERRUPT_MASK)
+
+#define LA_TRIGGER_SAMPLE_ADDRESS                0x00000094
+#define LA_TRIGGER_SAMPLE_OFFSET                 0x00000094
+#define LA_TRIGGER_SAMPLE_COUNT_MSB              15
+#define LA_TRIGGER_SAMPLE_COUNT_LSB              0
+#define LA_TRIGGER_SAMPLE_COUNT_MASK             0x0000ffff
+#define LA_TRIGGER_SAMPLE_COUNT_GET(x)           (((x) & LA_TRIGGER_SAMPLE_COUNT_MASK) >> LA_TRIGGER_SAMPLE_COUNT_LSB)
+#define LA_TRIGGER_SAMPLE_COUNT_SET(x)           (((x) << LA_TRIGGER_SAMPLE_COUNT_LSB) & LA_TRIGGER_SAMPLE_COUNT_MASK)
+
+#define LA_TRIGGER_POSITION_ADDRESS              0x00000098
+#define LA_TRIGGER_POSITION_OFFSET               0x00000098
+#define LA_TRIGGER_POSITION_VALUE_MSB            15
+#define LA_TRIGGER_POSITION_VALUE_LSB            0
+#define LA_TRIGGER_POSITION_VALUE_MASK           0x0000ffff
+#define LA_TRIGGER_POSITION_VALUE_GET(x)         (((x) & LA_TRIGGER_POSITION_VALUE_MASK) >> LA_TRIGGER_POSITION_VALUE_LSB)
+#define LA_TRIGGER_POSITION_VALUE_SET(x)         (((x) << LA_TRIGGER_POSITION_VALUE_LSB) & LA_TRIGGER_POSITION_VALUE_MASK)
+
+#define LA_PRE_TRIGGER_ADDRESS                   0x0000009c
+#define LA_PRE_TRIGGER_OFFSET                    0x0000009c
+#define LA_PRE_TRIGGER_COUNT_MSB                 15
+#define LA_PRE_TRIGGER_COUNT_LSB                 0
+#define LA_PRE_TRIGGER_COUNT_MASK                0x0000ffff
+#define LA_PRE_TRIGGER_COUNT_GET(x)              (((x) & LA_PRE_TRIGGER_COUNT_MASK) >> LA_PRE_TRIGGER_COUNT_LSB)
+#define LA_PRE_TRIGGER_COUNT_SET(x)              (((x) << LA_PRE_TRIGGER_COUNT_LSB) & LA_PRE_TRIGGER_COUNT_MASK)
+
+#define LA_POST_TRIGGER_ADDRESS                  0x000000a0
+#define LA_POST_TRIGGER_OFFSET                   0x000000a0
+#define LA_POST_TRIGGER_COUNT_MSB                15
+#define LA_POST_TRIGGER_COUNT_LSB                0
+#define LA_POST_TRIGGER_COUNT_MASK               0x0000ffff
+#define LA_POST_TRIGGER_COUNT_GET(x)             (((x) & LA_POST_TRIGGER_COUNT_MASK) >> LA_POST_TRIGGER_COUNT_LSB)
+#define LA_POST_TRIGGER_COUNT_SET(x)             (((x) << LA_POST_TRIGGER_COUNT_LSB) & LA_POST_TRIGGER_COUNT_MASK)
+
+#define LA_FILTER_CONTROL_ADDRESS                0x000000a4
+#define LA_FILTER_CONTROL_OFFSET                 0x000000a4
+#define LA_FILTER_CONTROL_DELTA_MSB              0
+#define LA_FILTER_CONTROL_DELTA_LSB              0
+#define LA_FILTER_CONTROL_DELTA_MASK             0x00000001
+#define LA_FILTER_CONTROL_DELTA_GET(x)           (((x) & LA_FILTER_CONTROL_DELTA_MASK) >> LA_FILTER_CONTROL_DELTA_LSB)
+#define LA_FILTER_CONTROL_DELTA_SET(x)           (((x) << LA_FILTER_CONTROL_DELTA_LSB) & LA_FILTER_CONTROL_DELTA_MASK)
+
+#define LA_FILTER_DATA_ADDRESS                   0x000000a8
+#define LA_FILTER_DATA_OFFSET                    0x000000a8
+#define LA_FILTER_DATA_MATCH_MSB                 17
+#define LA_FILTER_DATA_MATCH_LSB                 0
+#define LA_FILTER_DATA_MATCH_MASK                0x0003ffff
+#define LA_FILTER_DATA_MATCH_GET(x)              (((x) & LA_FILTER_DATA_MATCH_MASK) >> LA_FILTER_DATA_MATCH_LSB)
+#define LA_FILTER_DATA_MATCH_SET(x)              (((x) << LA_FILTER_DATA_MATCH_LSB) & LA_FILTER_DATA_MATCH_MASK)
+
+#define LA_FILTER_WILDCARD_ADDRESS               0x000000ac
+#define LA_FILTER_WILDCARD_OFFSET                0x000000ac
+#define LA_FILTER_WILDCARD_MATCH_MSB             17
+#define LA_FILTER_WILDCARD_MATCH_LSB             0
+#define LA_FILTER_WILDCARD_MATCH_MASK            0x0003ffff
+#define LA_FILTER_WILDCARD_MATCH_GET(x)          (((x) & LA_FILTER_WILDCARD_MATCH_MASK) >> LA_FILTER_WILDCARD_MATCH_LSB)
+#define LA_FILTER_WILDCARD_MATCH_SET(x)          (((x) << LA_FILTER_WILDCARD_MATCH_LSB) & LA_FILTER_WILDCARD_MATCH_MASK)
+
+#define LA_TRIGGERA_DATA_ADDRESS                 0x000000b0
+#define LA_TRIGGERA_DATA_OFFSET                  0x000000b0
+#define LA_TRIGGERA_DATA_MATCH_MSB               17
+#define LA_TRIGGERA_DATA_MATCH_LSB               0
+#define LA_TRIGGERA_DATA_MATCH_MASK              0x0003ffff
+#define LA_TRIGGERA_DATA_MATCH_GET(x)            (((x) & LA_TRIGGERA_DATA_MATCH_MASK) >> LA_TRIGGERA_DATA_MATCH_LSB)
+#define LA_TRIGGERA_DATA_MATCH_SET(x)            (((x) << LA_TRIGGERA_DATA_MATCH_LSB) & LA_TRIGGERA_DATA_MATCH_MASK)
+
+#define LA_TRIGGERA_WILDCARD_ADDRESS             0x000000b4
+#define LA_TRIGGERA_WILDCARD_OFFSET              0x000000b4
+#define LA_TRIGGERA_WILDCARD_MATCH_MSB           17
+#define LA_TRIGGERA_WILDCARD_MATCH_LSB           0
+#define LA_TRIGGERA_WILDCARD_MATCH_MASK          0x0003ffff
+#define LA_TRIGGERA_WILDCARD_MATCH_GET(x)        (((x) & LA_TRIGGERA_WILDCARD_MATCH_MASK) >> LA_TRIGGERA_WILDCARD_MATCH_LSB)
+#define LA_TRIGGERA_WILDCARD_MATCH_SET(x)        (((x) << LA_TRIGGERA_WILDCARD_MATCH_LSB) & LA_TRIGGERA_WILDCARD_MATCH_MASK)
+
+#define LA_TRIGGERB_DATA_ADDRESS                 0x000000b8
+#define LA_TRIGGERB_DATA_OFFSET                  0x000000b8
+#define LA_TRIGGERB_DATA_MATCH_MSB               17
+#define LA_TRIGGERB_DATA_MATCH_LSB               0
+#define LA_TRIGGERB_DATA_MATCH_MASK              0x0003ffff
+#define LA_TRIGGERB_DATA_MATCH_GET(x)            (((x) & LA_TRIGGERB_DATA_MATCH_MASK) >> LA_TRIGGERB_DATA_MATCH_LSB)
+#define LA_TRIGGERB_DATA_MATCH_SET(x)            (((x) << LA_TRIGGERB_DATA_MATCH_LSB) & LA_TRIGGERB_DATA_MATCH_MASK)
+
+#define LA_TRIGGERB_WILDCARD_ADDRESS             0x000000bc
+#define LA_TRIGGERB_WILDCARD_OFFSET              0x000000bc
+#define LA_TRIGGERB_WILDCARD_MATCH_MSB           17
+#define LA_TRIGGERB_WILDCARD_MATCH_LSB           0
+#define LA_TRIGGERB_WILDCARD_MATCH_MASK          0x0003ffff
+#define LA_TRIGGERB_WILDCARD_MATCH_GET(x)        (((x) & LA_TRIGGERB_WILDCARD_MATCH_MASK) >> LA_TRIGGERB_WILDCARD_MATCH_LSB)
+#define LA_TRIGGERB_WILDCARD_MATCH_SET(x)        (((x) << LA_TRIGGERB_WILDCARD_MATCH_LSB) & LA_TRIGGERB_WILDCARD_MATCH_MASK)
+
+#define LA_TRIGGER_ADDRESS                       0x000000c0
+#define LA_TRIGGER_OFFSET                        0x000000c0
+#define LA_TRIGGER_EVENT_MSB                     2
+#define LA_TRIGGER_EVENT_LSB                     0
+#define LA_TRIGGER_EVENT_MASK                    0x00000007
+#define LA_TRIGGER_EVENT_GET(x)                  (((x) & LA_TRIGGER_EVENT_MASK) >> LA_TRIGGER_EVENT_LSB)
+#define LA_TRIGGER_EVENT_SET(x)                  (((x) << LA_TRIGGER_EVENT_LSB) & LA_TRIGGER_EVENT_MASK)
+
+#define LA_FIFO_ADDRESS                          0x000000c4
+#define LA_FIFO_OFFSET                           0x000000c4
+#define LA_FIFO_FULL_MSB                         1
+#define LA_FIFO_FULL_LSB                         1
+#define LA_FIFO_FULL_MASK                        0x00000002
+#define LA_FIFO_FULL_GET(x)                      (((x) & LA_FIFO_FULL_MASK) >> LA_FIFO_FULL_LSB)
+#define LA_FIFO_FULL_SET(x)                      (((x) << LA_FIFO_FULL_LSB) & LA_FIFO_FULL_MASK)
+#define LA_FIFO_EMPTY_MSB                        0
+#define LA_FIFO_EMPTY_LSB                        0
+#define LA_FIFO_EMPTY_MASK                       0x00000001
+#define LA_FIFO_EMPTY_GET(x)                     (((x) & LA_FIFO_EMPTY_MASK) >> LA_FIFO_EMPTY_LSB)
+#define LA_FIFO_EMPTY_SET(x)                     (((x) << LA_FIFO_EMPTY_LSB) & LA_FIFO_EMPTY_MASK)
+
+#define LA_ADDRESS                               0x000000c8
+#define LA_OFFSET                                0x000000c8
+#define LA_DATA_MSB                              17
+#define LA_DATA_LSB                              0
+#define LA_DATA_MASK                             0x0003ffff
+#define LA_DATA_GET(x)                           (((x) & LA_DATA_MASK) >> LA_DATA_LSB)
+#define LA_DATA_SET(x)                           (((x) << LA_DATA_LSB) & LA_DATA_MASK)
+
+#define ANT_PIN_ADDRESS                          0x000000d0
+#define ANT_PIN_OFFSET                           0x000000d0
+#define ANT_PIN_PAD_PULL_MSB                     3
+#define ANT_PIN_PAD_PULL_LSB                     2
+#define ANT_PIN_PAD_PULL_MASK                    0x0000000c
+#define ANT_PIN_PAD_PULL_GET(x)                  (((x) & ANT_PIN_PAD_PULL_MASK) >> ANT_PIN_PAD_PULL_LSB)
+#define ANT_PIN_PAD_PULL_SET(x)                  (((x) << ANT_PIN_PAD_PULL_LSB) & ANT_PIN_PAD_PULL_MASK)
+#define ANT_PIN_PAD_STRENGTH_MSB                 1
+#define ANT_PIN_PAD_STRENGTH_LSB                 0
+#define ANT_PIN_PAD_STRENGTH_MASK                0x00000003
+#define ANT_PIN_PAD_STRENGTH_GET(x)              (((x) & ANT_PIN_PAD_STRENGTH_MASK) >> ANT_PIN_PAD_STRENGTH_LSB)
+#define ANT_PIN_PAD_STRENGTH_SET(x)              (((x) << ANT_PIN_PAD_STRENGTH_LSB) & ANT_PIN_PAD_STRENGTH_MASK)
+
+#define ANTD_PIN_ADDRESS                         0x000000d4
+#define ANTD_PIN_OFFSET                          0x000000d4
+#define ANTD_PIN_PAD_PULL_MSB                    1
+#define ANTD_PIN_PAD_PULL_LSB                    0
+#define ANTD_PIN_PAD_PULL_MASK                   0x00000003
+#define ANTD_PIN_PAD_PULL_GET(x)                 (((x) & ANTD_PIN_PAD_PULL_MASK) >> ANTD_PIN_PAD_PULL_LSB)
+#define ANTD_PIN_PAD_PULL_SET(x)                 (((x) << ANTD_PIN_PAD_PULL_LSB) & ANTD_PIN_PAD_PULL_MASK)
+
+#define GPIO_PIN_ADDRESS                         0x000000d8
+#define GPIO_PIN_OFFSET                          0x000000d8
+#define GPIO_PIN_PAD_PULL_MSB                    3
+#define GPIO_PIN_PAD_PULL_LSB                    2
+#define GPIO_PIN_PAD_PULL_MASK                   0x0000000c
+#define GPIO_PIN_PAD_PULL_GET(x)                 (((x) & GPIO_PIN_PAD_PULL_MASK) >> GPIO_PIN_PAD_PULL_LSB)
+#define GPIO_PIN_PAD_PULL_SET(x)                 (((x) << GPIO_PIN_PAD_PULL_LSB) & GPIO_PIN_PAD_PULL_MASK)
+#define GPIO_PIN_PAD_STRENGTH_MSB                1
+#define GPIO_PIN_PAD_STRENGTH_LSB                0
+#define GPIO_PIN_PAD_STRENGTH_MASK               0x00000003
+#define GPIO_PIN_PAD_STRENGTH_GET(x)             (((x) & GPIO_PIN_PAD_STRENGTH_MASK) >> GPIO_PIN_PAD_STRENGTH_LSB)
+#define GPIO_PIN_PAD_STRENGTH_SET(x)             (((x) << GPIO_PIN_PAD_STRENGTH_LSB) & GPIO_PIN_PAD_STRENGTH_MASK)
+
+#define GPIO_H_PIN_ADDRESS                       0x000000dc
+#define GPIO_H_PIN_OFFSET                        0x000000dc
+#define GPIO_H_PIN_PAD_PULL_MSB                  1
+#define GPIO_H_PIN_PAD_PULL_LSB                  0
+#define GPIO_H_PIN_PAD_PULL_MASK                 0x00000003
+#define GPIO_H_PIN_PAD_PULL_GET(x)               (((x) & GPIO_H_PIN_PAD_PULL_MASK) >> GPIO_H_PIN_PAD_PULL_LSB)
+#define GPIO_H_PIN_PAD_PULL_SET(x)               (((x) << GPIO_H_PIN_PAD_PULL_LSB) & GPIO_H_PIN_PAD_PULL_MASK)
+
+#define BT_PIN_ADDRESS                           0x000000e0
+#define BT_PIN_OFFSET                            0x000000e0
+#define BT_PIN_PAD_PULL_MSB                      3
+#define BT_PIN_PAD_PULL_LSB                      2
+#define BT_PIN_PAD_PULL_MASK                     0x0000000c
+#define BT_PIN_PAD_PULL_GET(x)                   (((x) & BT_PIN_PAD_PULL_MASK) >> BT_PIN_PAD_PULL_LSB)
+#define BT_PIN_PAD_PULL_SET(x)                   (((x) << BT_PIN_PAD_PULL_LSB) & BT_PIN_PAD_PULL_MASK)
+#define BT_PIN_PAD_STRENGTH_MSB                  1
+#define BT_PIN_PAD_STRENGTH_LSB                  0
+#define BT_PIN_PAD_STRENGTH_MASK                 0x00000003
+#define BT_PIN_PAD_STRENGTH_GET(x)               (((x) & BT_PIN_PAD_STRENGTH_MASK) >> BT_PIN_PAD_STRENGTH_LSB)
+#define BT_PIN_PAD_STRENGTH_SET(x)               (((x) << BT_PIN_PAD_STRENGTH_LSB) & BT_PIN_PAD_STRENGTH_MASK)
+
+#define BT_WLAN_PIN_ADDRESS                      0x000000e4
+#define BT_WLAN_PIN_OFFSET                       0x000000e4
+#define BT_WLAN_PIN_PAD_PULL_MSB                 1
+#define BT_WLAN_PIN_PAD_PULL_LSB                 0
+#define BT_WLAN_PIN_PAD_PULL_MASK                0x00000003
+#define BT_WLAN_PIN_PAD_PULL_GET(x)              (((x) & BT_WLAN_PIN_PAD_PULL_MASK) >> BT_WLAN_PIN_PAD_PULL_LSB)
+#define BT_WLAN_PIN_PAD_PULL_SET(x)              (((x) << BT_WLAN_PIN_PAD_PULL_LSB) & BT_WLAN_PIN_PAD_PULL_MASK)
+
+#define SI_UART_PIN_ADDRESS                      0x000000e8
+#define SI_UART_PIN_OFFSET                       0x000000e8
+#define SI_UART_PIN_PAD_PULL_MSB                 3
+#define SI_UART_PIN_PAD_PULL_LSB                 2
+#define SI_UART_PIN_PAD_PULL_MASK                0x0000000c
+#define SI_UART_PIN_PAD_PULL_GET(x)              (((x) & SI_UART_PIN_PAD_PULL_MASK) >> SI_UART_PIN_PAD_PULL_LSB)
+#define SI_UART_PIN_PAD_PULL_SET(x)              (((x) << SI_UART_PIN_PAD_PULL_LSB) & SI_UART_PIN_PAD_PULL_MASK)
+#define SI_UART_PIN_PAD_STRENGTH_MSB             1
+#define SI_UART_PIN_PAD_STRENGTH_LSB             0
+#define SI_UART_PIN_PAD_STRENGTH_MASK            0x00000003
+#define SI_UART_PIN_PAD_STRENGTH_GET(x)          (((x) & SI_UART_PIN_PAD_STRENGTH_MASK) >> SI_UART_PIN_PAD_STRENGTH_LSB)
+#define SI_UART_PIN_PAD_STRENGTH_SET(x)          (((x) << SI_UART_PIN_PAD_STRENGTH_LSB) & SI_UART_PIN_PAD_STRENGTH_MASK)
+
+#define CLK32K_PIN_ADDRESS                       0x000000ec
+#define CLK32K_PIN_OFFSET                        0x000000ec
+#define CLK32K_PIN_PAD_PULL_MSB                  1
+#define CLK32K_PIN_PAD_PULL_LSB                  0
+#define CLK32K_PIN_PAD_PULL_MASK                 0x00000003
+#define CLK32K_PIN_PAD_PULL_GET(x)               (((x) & CLK32K_PIN_PAD_PULL_MASK) >> CLK32K_PIN_PAD_PULL_LSB)
+#define CLK32K_PIN_PAD_PULL_SET(x)               (((x) << CLK32K_PIN_PAD_PULL_LSB) & CLK32K_PIN_PAD_PULL_MASK)
+
+#define RESET_TUPLE_STATUS_ADDRESS               0x000000f0
+#define RESET_TUPLE_STATUS_OFFSET                0x000000f0
+#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MSB  11
+#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB  8
+#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK 0x00000f00
+#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_GET(x) (((x) & RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK) >> RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB)
+#define RESET_TUPLE_STATUS_TEST_RESET_TUPLE_SET(x) (((x) << RESET_TUPLE_STATUS_TEST_RESET_TUPLE_LSB) & RESET_TUPLE_STATUS_TEST_RESET_TUPLE_MASK)
+#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MSB   7
+#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB   0
+#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK  0x000000ff
+#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_GET(x) (((x) & RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK) >> RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB)
+#define RESET_TUPLE_STATUS_PIN_RESET_TUPLE_SET(x) (((x) << RESET_TUPLE_STATUS_PIN_RESET_TUPLE_LSB) & RESET_TUPLE_STATUS_PIN_RESET_TUPLE_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct gpio_reg_reg_s {
+  volatile unsigned int gpio_out;
+  volatile unsigned int gpio_out_w1ts;
+  volatile unsigned int gpio_out_w1tc;
+  volatile unsigned int gpio_enable;
+  volatile unsigned int gpio_enable_w1ts;
+  volatile unsigned int gpio_enable_w1tc;
+  volatile unsigned int gpio_in;
+  volatile unsigned int gpio_status;
+  volatile unsigned int gpio_status_w1ts;
+  volatile unsigned int gpio_status_w1tc;
+  volatile unsigned int gpio_pin0;
+  volatile unsigned int gpio_pin1;
+  volatile unsigned int gpio_pin2;
+  volatile unsigned int gpio_pin3;
+  volatile unsigned int gpio_pin4;
+  volatile unsigned int gpio_pin5;
+  volatile unsigned int gpio_pin6;
+  volatile unsigned int gpio_pin7;
+  volatile unsigned int gpio_pin8;
+  volatile unsigned int gpio_pin9;
+  volatile unsigned int gpio_pin10;
+  volatile unsigned int gpio_pin11;
+  volatile unsigned int gpio_pin12;
+  volatile unsigned int gpio_pin13;
+  volatile unsigned int gpio_pin14;
+  volatile unsigned int gpio_pin15;
+  volatile unsigned int gpio_pin16;
+  volatile unsigned int gpio_pin17;
+  volatile unsigned int sdio_pin;
+  volatile unsigned int clk_req_pin;
+  volatile unsigned int sigma_delta;
+  volatile unsigned int debug_control;
+  volatile unsigned int debug_input_sel;
+  volatile unsigned int debug_out;
+  volatile unsigned int la_control;
+  volatile unsigned int la_clock;
+  volatile unsigned int la_status;
+  volatile unsigned int la_trigger_sample;
+  volatile unsigned int la_trigger_position;
+  volatile unsigned int la_pre_trigger;
+  volatile unsigned int la_post_trigger;
+  volatile unsigned int la_filter_control;
+  volatile unsigned int la_filter_data;
+  volatile unsigned int la_filter_wildcard;
+  volatile unsigned int la_triggera_data;
+  volatile unsigned int la_triggera_wildcard;
+  volatile unsigned int la_triggerb_data;
+  volatile unsigned int la_triggerb_wildcard;
+  volatile unsigned int la_trigger;
+  volatile unsigned int la_fifo;
+  volatile unsigned int la[2];
+  volatile unsigned int ant_pin;
+  volatile unsigned int antd_pin;
+  volatile unsigned int gpio_pin;
+  volatile unsigned int gpio_h_pin;
+  volatile unsigned int bt_pin;
+  volatile unsigned int bt_wlan_pin;
+  volatile unsigned int si_uart_pin;
+  volatile unsigned int clk32k_pin;
+  volatile unsigned int reset_tuple_status;
+} gpio_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _GPIO_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
new file mode 100644
index 0000000..f836ae4
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
@@ -0,0 +1,386 @@
+#ifndef _MBOX_HOST_REG_REG_H_
+#define _MBOX_HOST_REG_REG_H_
+
+#define HOST_INT_STATUS_ADDRESS                  0x00000400
+#define HOST_INT_STATUS_OFFSET                   0x00000400
+#define HOST_INT_STATUS_ERROR_MSB                7
+#define HOST_INT_STATUS_ERROR_LSB                7
+#define HOST_INT_STATUS_ERROR_MASK               0x00000080
+#define HOST_INT_STATUS_ERROR_GET(x)             (((x) & HOST_INT_STATUS_ERROR_MASK) >> HOST_INT_STATUS_ERROR_LSB)
+#define HOST_INT_STATUS_ERROR_SET(x)             (((x) << HOST_INT_STATUS_ERROR_LSB) & HOST_INT_STATUS_ERROR_MASK)
+#define HOST_INT_STATUS_CPU_MSB                  6
+#define HOST_INT_STATUS_CPU_LSB                  6
+#define HOST_INT_STATUS_CPU_MASK                 0x00000040
+#define HOST_INT_STATUS_CPU_GET(x)               (((x) & HOST_INT_STATUS_CPU_MASK) >> HOST_INT_STATUS_CPU_LSB)
+#define HOST_INT_STATUS_CPU_SET(x)               (((x) << HOST_INT_STATUS_CPU_LSB) & HOST_INT_STATUS_CPU_MASK)
+#define HOST_INT_STATUS_DRAGON_INT_MSB           5
+#define HOST_INT_STATUS_DRAGON_INT_LSB           5
+#define HOST_INT_STATUS_DRAGON_INT_MASK          0x00000020
+#define HOST_INT_STATUS_DRAGON_INT_GET(x)        (((x) & HOST_INT_STATUS_DRAGON_INT_MASK) >> HOST_INT_STATUS_DRAGON_INT_LSB)
+#define HOST_INT_STATUS_DRAGON_INT_SET(x)        (((x) << HOST_INT_STATUS_DRAGON_INT_LSB) & HOST_INT_STATUS_DRAGON_INT_MASK)
+#define HOST_INT_STATUS_COUNTER_MSB              4
+#define HOST_INT_STATUS_COUNTER_LSB              4
+#define HOST_INT_STATUS_COUNTER_MASK             0x00000010
+#define HOST_INT_STATUS_COUNTER_GET(x)           (((x) & HOST_INT_STATUS_COUNTER_MASK) >> HOST_INT_STATUS_COUNTER_LSB)
+#define HOST_INT_STATUS_COUNTER_SET(x)           (((x) << HOST_INT_STATUS_COUNTER_LSB) & HOST_INT_STATUS_COUNTER_MASK)
+#define HOST_INT_STATUS_MBOX_DATA_MSB            3
+#define HOST_INT_STATUS_MBOX_DATA_LSB            0
+#define HOST_INT_STATUS_MBOX_DATA_MASK           0x0000000f
+#define HOST_INT_STATUS_MBOX_DATA_GET(x)         (((x) & HOST_INT_STATUS_MBOX_DATA_MASK) >> HOST_INT_STATUS_MBOX_DATA_LSB)
+#define HOST_INT_STATUS_MBOX_DATA_SET(x)         (((x) << HOST_INT_STATUS_MBOX_DATA_LSB) & HOST_INT_STATUS_MBOX_DATA_MASK)
+
+#define CPU_INT_STATUS_ADDRESS                   0x00000401
+#define CPU_INT_STATUS_OFFSET                    0x00000401
+#define CPU_INT_STATUS_BIT_MSB                   7
+#define CPU_INT_STATUS_BIT_LSB                   0
+#define CPU_INT_STATUS_BIT_MASK                  0x000000ff
+#define CPU_INT_STATUS_BIT_GET(x)                (((x) & CPU_INT_STATUS_BIT_MASK) >> CPU_INT_STATUS_BIT_LSB)
+#define CPU_INT_STATUS_BIT_SET(x)                (((x) << CPU_INT_STATUS_BIT_LSB) & CPU_INT_STATUS_BIT_MASK)
+
+#define ERROR_INT_STATUS_ADDRESS                 0x00000402
+#define ERROR_INT_STATUS_OFFSET                  0x00000402
+#define ERROR_INT_STATUS_SPI_MSB                 3
+#define ERROR_INT_STATUS_SPI_LSB                 3
+#define ERROR_INT_STATUS_SPI_MASK                0x00000008
+#define ERROR_INT_STATUS_SPI_GET(x)              (((x) & ERROR_INT_STATUS_SPI_MASK) >> ERROR_INT_STATUS_SPI_LSB)
+#define ERROR_INT_STATUS_SPI_SET(x)              (((x) << ERROR_INT_STATUS_SPI_LSB) & ERROR_INT_STATUS_SPI_MASK)
+#define ERROR_INT_STATUS_WAKEUP_MSB              2
+#define ERROR_INT_STATUS_WAKEUP_LSB              2
+#define ERROR_INT_STATUS_WAKEUP_MASK             0x00000004
+#define ERROR_INT_STATUS_WAKEUP_GET(x)           (((x) & ERROR_INT_STATUS_WAKEUP_MASK) >> ERROR_INT_STATUS_WAKEUP_LSB)
+#define ERROR_INT_STATUS_WAKEUP_SET(x)           (((x) << ERROR_INT_STATUS_WAKEUP_LSB) & ERROR_INT_STATUS_WAKEUP_MASK)
+#define ERROR_INT_STATUS_RX_UNDERFLOW_MSB        1
+#define ERROR_INT_STATUS_RX_UNDERFLOW_LSB        1
+#define ERROR_INT_STATUS_RX_UNDERFLOW_MASK       0x00000002
+#define ERROR_INT_STATUS_RX_UNDERFLOW_GET(x)     (((x) & ERROR_INT_STATUS_RX_UNDERFLOW_MASK) >> ERROR_INT_STATUS_RX_UNDERFLOW_LSB)
+#define ERROR_INT_STATUS_RX_UNDERFLOW_SET(x)     (((x) << ERROR_INT_STATUS_RX_UNDERFLOW_LSB) & ERROR_INT_STATUS_RX_UNDERFLOW_MASK)
+#define ERROR_INT_STATUS_TX_OVERFLOW_MSB         0
+#define ERROR_INT_STATUS_TX_OVERFLOW_LSB         0
+#define ERROR_INT_STATUS_TX_OVERFLOW_MASK        0x00000001
+#define ERROR_INT_STATUS_TX_OVERFLOW_GET(x)      (((x) & ERROR_INT_STATUS_TX_OVERFLOW_MASK) >> ERROR_INT_STATUS_TX_OVERFLOW_LSB)
+#define ERROR_INT_STATUS_TX_OVERFLOW_SET(x)      (((x) << ERROR_INT_STATUS_TX_OVERFLOW_LSB) & ERROR_INT_STATUS_TX_OVERFLOW_MASK)
+
+#define COUNTER_INT_STATUS_ADDRESS               0x00000403
+#define COUNTER_INT_STATUS_OFFSET                0x00000403
+#define COUNTER_INT_STATUS_COUNTER_MSB           7
+#define COUNTER_INT_STATUS_COUNTER_LSB           0
+#define COUNTER_INT_STATUS_COUNTER_MASK          0x000000ff
+#define COUNTER_INT_STATUS_COUNTER_GET(x)        (((x) & COUNTER_INT_STATUS_COUNTER_MASK) >> COUNTER_INT_STATUS_COUNTER_LSB)
+#define COUNTER_INT_STATUS_COUNTER_SET(x)        (((x) << COUNTER_INT_STATUS_COUNTER_LSB) & COUNTER_INT_STATUS_COUNTER_MASK)
+
+#define MBOX_FRAME_ADDRESS                       0x00000404
+#define MBOX_FRAME_OFFSET                        0x00000404
+#define MBOX_FRAME_RX_EOM_MSB                    7
+#define MBOX_FRAME_RX_EOM_LSB                    4
+#define MBOX_FRAME_RX_EOM_MASK                   0x000000f0
+#define MBOX_FRAME_RX_EOM_GET(x)                 (((x) & MBOX_FRAME_RX_EOM_MASK) >> MBOX_FRAME_RX_EOM_LSB)
+#define MBOX_FRAME_RX_EOM_SET(x)                 (((x) << MBOX_FRAME_RX_EOM_LSB) & MBOX_FRAME_RX_EOM_MASK)
+#define MBOX_FRAME_RX_SOM_MSB                    3
+#define MBOX_FRAME_RX_SOM_LSB                    0
+#define MBOX_FRAME_RX_SOM_MASK                   0x0000000f
+#define MBOX_FRAME_RX_SOM_GET(x)                 (((x) & MBOX_FRAME_RX_SOM_MASK) >> MBOX_FRAME_RX_SOM_LSB)
+#define MBOX_FRAME_RX_SOM_SET(x)                 (((x) << MBOX_FRAME_RX_SOM_LSB) & MBOX_FRAME_RX_SOM_MASK)
+
+#define RX_LOOKAHEAD_VALID_ADDRESS               0x00000405
+#define RX_LOOKAHEAD_VALID_OFFSET                0x00000405
+#define RX_LOOKAHEAD_VALID_MBOX_MSB              3
+#define RX_LOOKAHEAD_VALID_MBOX_LSB              0
+#define RX_LOOKAHEAD_VALID_MBOX_MASK             0x0000000f
+#define RX_LOOKAHEAD_VALID_MBOX_GET(x)           (((x) & RX_LOOKAHEAD_VALID_MBOX_MASK) >> RX_LOOKAHEAD_VALID_MBOX_LSB)
+#define RX_LOOKAHEAD_VALID_MBOX_SET(x)           (((x) << RX_LOOKAHEAD_VALID_MBOX_LSB) & RX_LOOKAHEAD_VALID_MBOX_MASK)
+
+#define RX_LOOKAHEAD0_ADDRESS                    0x00000408
+#define RX_LOOKAHEAD0_OFFSET                     0x00000408
+#define RX_LOOKAHEAD0_DATA_MSB                   7
+#define RX_LOOKAHEAD0_DATA_LSB                   0
+#define RX_LOOKAHEAD0_DATA_MASK                  0x000000ff
+#define RX_LOOKAHEAD0_DATA_GET(x)                (((x) & RX_LOOKAHEAD0_DATA_MASK) >> RX_LOOKAHEAD0_DATA_LSB)
+#define RX_LOOKAHEAD0_DATA_SET(x)                (((x) << RX_LOOKAHEAD0_DATA_LSB) & RX_LOOKAHEAD0_DATA_MASK)
+
+#define RX_LOOKAHEAD1_ADDRESS                    0x0000040c
+#define RX_LOOKAHEAD1_OFFSET                     0x0000040c
+#define RX_LOOKAHEAD1_DATA_MSB                   7
+#define RX_LOOKAHEAD1_DATA_LSB                   0
+#define RX_LOOKAHEAD1_DATA_MASK                  0x000000ff
+#define RX_LOOKAHEAD1_DATA_GET(x)                (((x) & RX_LOOKAHEAD1_DATA_MASK) >> RX_LOOKAHEAD1_DATA_LSB)
+#define RX_LOOKAHEAD1_DATA_SET(x)                (((x) << RX_LOOKAHEAD1_DATA_LSB) & RX_LOOKAHEAD1_DATA_MASK)
+
+#define RX_LOOKAHEAD2_ADDRESS                    0x00000410
+#define RX_LOOKAHEAD2_OFFSET                     0x00000410
+#define RX_LOOKAHEAD2_DATA_MSB                   7
+#define RX_LOOKAHEAD2_DATA_LSB                   0
+#define RX_LOOKAHEAD2_DATA_MASK                  0x000000ff
+#define RX_LOOKAHEAD2_DATA_GET(x)                (((x) & RX_LOOKAHEAD2_DATA_MASK) >> RX_LOOKAHEAD2_DATA_LSB)
+#define RX_LOOKAHEAD2_DATA_SET(x)                (((x) << RX_LOOKAHEAD2_DATA_LSB) & RX_LOOKAHEAD2_DATA_MASK)
+
+#define RX_LOOKAHEAD3_ADDRESS                    0x00000414
+#define RX_LOOKAHEAD3_OFFSET                     0x00000414
+#define RX_LOOKAHEAD3_DATA_MSB                   7
+#define RX_LOOKAHEAD3_DATA_LSB                   0
+#define RX_LOOKAHEAD3_DATA_MASK                  0x000000ff
+#define RX_LOOKAHEAD3_DATA_GET(x)                (((x) & RX_LOOKAHEAD3_DATA_MASK) >> RX_LOOKAHEAD3_DATA_LSB)
+#define RX_LOOKAHEAD3_DATA_SET(x)                (((x) << RX_LOOKAHEAD3_DATA_LSB) & RX_LOOKAHEAD3_DATA_MASK)
+
+#define INT_STATUS_ENABLE_ADDRESS                0x00000418
+#define INT_STATUS_ENABLE_OFFSET                 0x00000418
+#define INT_STATUS_ENABLE_ERROR_MSB              7
+#define INT_STATUS_ENABLE_ERROR_LSB              7
+#define INT_STATUS_ENABLE_ERROR_MASK             0x00000080
+#define INT_STATUS_ENABLE_ERROR_GET(x)           (((x) & INT_STATUS_ENABLE_ERROR_MASK) >> INT_STATUS_ENABLE_ERROR_LSB)
+#define INT_STATUS_ENABLE_ERROR_SET(x)           (((x) << INT_STATUS_ENABLE_ERROR_LSB) & INT_STATUS_ENABLE_ERROR_MASK)
+#define INT_STATUS_ENABLE_CPU_MSB                6
+#define INT_STATUS_ENABLE_CPU_LSB                6
+#define INT_STATUS_ENABLE_CPU_MASK               0x00000040
+#define INT_STATUS_ENABLE_CPU_GET(x)             (((x) & INT_STATUS_ENABLE_CPU_MASK) >> INT_STATUS_ENABLE_CPU_LSB)
+#define INT_STATUS_ENABLE_CPU_SET(x)             (((x) << INT_STATUS_ENABLE_CPU_LSB) & INT_STATUS_ENABLE_CPU_MASK)
+#define INT_STATUS_ENABLE_DRAGON_INT_MSB         5
+#define INT_STATUS_ENABLE_DRAGON_INT_LSB         5
+#define INT_STATUS_ENABLE_DRAGON_INT_MASK        0x00000020
+#define INT_STATUS_ENABLE_DRAGON_INT_GET(x)      (((x) & INT_STATUS_ENABLE_DRAGON_INT_MASK) >> INT_STATUS_ENABLE_DRAGON_INT_LSB)
+#define INT_STATUS_ENABLE_DRAGON_INT_SET(x)      (((x) << INT_STATUS_ENABLE_DRAGON_INT_LSB) & INT_STATUS_ENABLE_DRAGON_INT_MASK)
+#define INT_STATUS_ENABLE_COUNTER_MSB            4
+#define INT_STATUS_ENABLE_COUNTER_LSB            4
+#define INT_STATUS_ENABLE_COUNTER_MASK           0x00000010
+#define INT_STATUS_ENABLE_COUNTER_GET(x)         (((x) & INT_STATUS_ENABLE_COUNTER_MASK) >> INT_STATUS_ENABLE_COUNTER_LSB)
+#define INT_STATUS_ENABLE_COUNTER_SET(x)         (((x) << INT_STATUS_ENABLE_COUNTER_LSB) & INT_STATUS_ENABLE_COUNTER_MASK)
+#define INT_STATUS_ENABLE_MBOX_DATA_MSB          3
+#define INT_STATUS_ENABLE_MBOX_DATA_LSB          0
+#define INT_STATUS_ENABLE_MBOX_DATA_MASK         0x0000000f
+#define INT_STATUS_ENABLE_MBOX_DATA_GET(x)       (((x) & INT_STATUS_ENABLE_MBOX_DATA_MASK) >> INT_STATUS_ENABLE_MBOX_DATA_LSB)
+#define INT_STATUS_ENABLE_MBOX_DATA_SET(x)       (((x) << INT_STATUS_ENABLE_MBOX_DATA_LSB) & INT_STATUS_ENABLE_MBOX_DATA_MASK)
+
+#define CPU_INT_STATUS_ENABLE_ADDRESS            0x00000419
+#define CPU_INT_STATUS_ENABLE_OFFSET             0x00000419
+#define CPU_INT_STATUS_ENABLE_BIT_MSB            7
+#define CPU_INT_STATUS_ENABLE_BIT_LSB            0
+#define CPU_INT_STATUS_ENABLE_BIT_MASK           0x000000ff
+#define CPU_INT_STATUS_ENABLE_BIT_GET(x)         (((x) & CPU_INT_STATUS_ENABLE_BIT_MASK) >> CPU_INT_STATUS_ENABLE_BIT_LSB)
+#define CPU_INT_STATUS_ENABLE_BIT_SET(x)         (((x) << CPU_INT_STATUS_ENABLE_BIT_LSB) & CPU_INT_STATUS_ENABLE_BIT_MASK)
+
+#define ERROR_STATUS_ENABLE_ADDRESS              0x0000041a
+#define ERROR_STATUS_ENABLE_OFFSET               0x0000041a
+#define ERROR_STATUS_ENABLE_WAKEUP_MSB           2
+#define ERROR_STATUS_ENABLE_WAKEUP_LSB           2
+#define ERROR_STATUS_ENABLE_WAKEUP_MASK          0x00000004
+#define ERROR_STATUS_ENABLE_WAKEUP_GET(x)        (((x) & ERROR_STATUS_ENABLE_WAKEUP_MASK) >> ERROR_STATUS_ENABLE_WAKEUP_LSB)
+#define ERROR_STATUS_ENABLE_WAKEUP_SET(x)        (((x) << ERROR_STATUS_ENABLE_WAKEUP_LSB) & ERROR_STATUS_ENABLE_WAKEUP_MASK)
+#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_MSB     1
+#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB     1
+#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK    0x00000002
+#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_GET(x)  (((x) & ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK) >> ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB)
+#define ERROR_STATUS_ENABLE_RX_UNDERFLOW_SET(x)  (((x) << ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB) & ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK)
+#define ERROR_STATUS_ENABLE_TX_OVERFLOW_MSB      0
+#define ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB      0
+#define ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK     0x00000001
+#define ERROR_STATUS_ENABLE_TX_OVERFLOW_GET(x)   (((x) & ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK) >> ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB)
+#define ERROR_STATUS_ENABLE_TX_OVERFLOW_SET(x)   (((x) << ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB) & ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK)
+
+#define COUNTER_INT_STATUS_ENABLE_ADDRESS        0x0000041b
+#define COUNTER_INT_STATUS_ENABLE_OFFSET         0x0000041b
+#define COUNTER_INT_STATUS_ENABLE_BIT_MSB        7
+#define COUNTER_INT_STATUS_ENABLE_BIT_LSB        0
+#define COUNTER_INT_STATUS_ENABLE_BIT_MASK       0x000000ff
+#define COUNTER_INT_STATUS_ENABLE_BIT_GET(x)     (((x) & COUNTER_INT_STATUS_ENABLE_BIT_MASK) >> COUNTER_INT_STATUS_ENABLE_BIT_LSB)
+#define COUNTER_INT_STATUS_ENABLE_BIT_SET(x)     (((x) << COUNTER_INT_STATUS_ENABLE_BIT_LSB) & COUNTER_INT_STATUS_ENABLE_BIT_MASK)
+
+#define COUNT_ADDRESS                            0x00000420
+#define COUNT_OFFSET                             0x00000420
+#define COUNT_VALUE_MSB                          7
+#define COUNT_VALUE_LSB                          0
+#define COUNT_VALUE_MASK                         0x000000ff
+#define COUNT_VALUE_GET(x)                       (((x) & COUNT_VALUE_MASK) >> COUNT_VALUE_LSB)
+#define COUNT_VALUE_SET(x)                       (((x) << COUNT_VALUE_LSB) & COUNT_VALUE_MASK)
+
+#define COUNT_DEC_ADDRESS                        0x00000440
+#define COUNT_DEC_OFFSET                         0x00000440
+#define COUNT_DEC_VALUE_MSB                      7
+#define COUNT_DEC_VALUE_LSB                      0
+#define COUNT_DEC_VALUE_MASK                     0x000000ff
+#define COUNT_DEC_VALUE_GET(x)                   (((x) & COUNT_DEC_VALUE_MASK) >> COUNT_DEC_VALUE_LSB)
+#define COUNT_DEC_VALUE_SET(x)                   (((x) << COUNT_DEC_VALUE_LSB) & COUNT_DEC_VALUE_MASK)
+
+#define SCRATCH_ADDRESS                          0x00000460
+#define SCRATCH_OFFSET                           0x00000460
+#define SCRATCH_VALUE_MSB                        7
+#define SCRATCH_VALUE_LSB                        0
+#define SCRATCH_VALUE_MASK                       0x000000ff
+#define SCRATCH_VALUE_GET(x)                     (((x) & SCRATCH_VALUE_MASK) >> SCRATCH_VALUE_LSB)
+#define SCRATCH_VALUE_SET(x)                     (((x) << SCRATCH_VALUE_LSB) & SCRATCH_VALUE_MASK)
+
+#define FIFO_TIMEOUT_ADDRESS                     0x00000468
+#define FIFO_TIMEOUT_OFFSET                      0x00000468
+#define FIFO_TIMEOUT_VALUE_MSB                   7
+#define FIFO_TIMEOUT_VALUE_LSB                   0
+#define FIFO_TIMEOUT_VALUE_MASK                  0x000000ff
+#define FIFO_TIMEOUT_VALUE_GET(x)                (((x) & FIFO_TIMEOUT_VALUE_MASK) >> FIFO_TIMEOUT_VALUE_LSB)
+#define FIFO_TIMEOUT_VALUE_SET(x)                (((x) << FIFO_TIMEOUT_VALUE_LSB) & FIFO_TIMEOUT_VALUE_MASK)
+
+#define FIFO_TIMEOUT_ENABLE_ADDRESS              0x00000469
+#define FIFO_TIMEOUT_ENABLE_OFFSET               0x00000469
+#define FIFO_TIMEOUT_ENABLE_SET_MSB              0
+#define FIFO_TIMEOUT_ENABLE_SET_LSB              0
+#define FIFO_TIMEOUT_ENABLE_SET_MASK             0x00000001
+#define FIFO_TIMEOUT_ENABLE_SET_GET(x)           (((x) & FIFO_TIMEOUT_ENABLE_SET_MASK) >> FIFO_TIMEOUT_ENABLE_SET_LSB)
+#define FIFO_TIMEOUT_ENABLE_SET_SET(x)           (((x) << FIFO_TIMEOUT_ENABLE_SET_LSB) & FIFO_TIMEOUT_ENABLE_SET_MASK)
+
+#define DISABLE_SLEEP_ADDRESS                    0x0000046a
+#define DISABLE_SLEEP_OFFSET                     0x0000046a
+#define DISABLE_SLEEP_FOR_INT_MSB                1
+#define DISABLE_SLEEP_FOR_INT_LSB                1
+#define DISABLE_SLEEP_FOR_INT_MASK               0x00000002
+#define DISABLE_SLEEP_FOR_INT_GET(x)             (((x) & DISABLE_SLEEP_FOR_INT_MASK) >> DISABLE_SLEEP_FOR_INT_LSB)
+#define DISABLE_SLEEP_FOR_INT_SET(x)             (((x) << DISABLE_SLEEP_FOR_INT_LSB) & DISABLE_SLEEP_FOR_INT_MASK)
+#define DISABLE_SLEEP_ON_MSB                     0
+#define DISABLE_SLEEP_ON_LSB                     0
+#define DISABLE_SLEEP_ON_MASK                    0x00000001
+#define DISABLE_SLEEP_ON_GET(x)                  (((x) & DISABLE_SLEEP_ON_MASK) >> DISABLE_SLEEP_ON_LSB)
+#define DISABLE_SLEEP_ON_SET(x)                  (((x) << DISABLE_SLEEP_ON_LSB) & DISABLE_SLEEP_ON_MASK)
+
+#define LOCAL_BUS_ADDRESS                        0x00000470
+#define LOCAL_BUS_OFFSET                         0x00000470
+#define LOCAL_BUS_STATE_MSB                      1
+#define LOCAL_BUS_STATE_LSB                      0
+#define LOCAL_BUS_STATE_MASK                     0x00000003
+#define LOCAL_BUS_STATE_GET(x)                   (((x) & LOCAL_BUS_STATE_MASK) >> LOCAL_BUS_STATE_LSB)
+#define LOCAL_BUS_STATE_SET(x)                   (((x) << LOCAL_BUS_STATE_LSB) & LOCAL_BUS_STATE_MASK)
+
+#define INT_WLAN_ADDRESS                         0x00000472
+#define INT_WLAN_OFFSET                          0x00000472
+#define INT_WLAN_VECTOR_MSB                      7
+#define INT_WLAN_VECTOR_LSB                      0
+#define INT_WLAN_VECTOR_MASK                     0x000000ff
+#define INT_WLAN_VECTOR_GET(x)                   (((x) & INT_WLAN_VECTOR_MASK) >> INT_WLAN_VECTOR_LSB)
+#define INT_WLAN_VECTOR_SET(x)                   (((x) << INT_WLAN_VECTOR_LSB) & INT_WLAN_VECTOR_MASK)
+
+#define WINDOW_DATA_ADDRESS                      0x00000474
+#define WINDOW_DATA_OFFSET                       0x00000474
+#define WINDOW_DATA_DATA_MSB                     7
+#define WINDOW_DATA_DATA_LSB                     0
+#define WINDOW_DATA_DATA_MASK                    0x000000ff
+#define WINDOW_DATA_DATA_GET(x)                  (((x) & WINDOW_DATA_DATA_MASK) >> WINDOW_DATA_DATA_LSB)
+#define WINDOW_DATA_DATA_SET(x)                  (((x) << WINDOW_DATA_DATA_LSB) & WINDOW_DATA_DATA_MASK)
+
+#define WINDOW_WRITE_ADDR_ADDRESS                0x00000478
+#define WINDOW_WRITE_ADDR_OFFSET                 0x00000478
+#define WINDOW_WRITE_ADDR_ADDR_MSB               7
+#define WINDOW_WRITE_ADDR_ADDR_LSB               0
+#define WINDOW_WRITE_ADDR_ADDR_MASK              0x000000ff
+#define WINDOW_WRITE_ADDR_ADDR_GET(x)            (((x) & WINDOW_WRITE_ADDR_ADDR_MASK) >> WINDOW_WRITE_ADDR_ADDR_LSB)
+#define WINDOW_WRITE_ADDR_ADDR_SET(x)            (((x) << WINDOW_WRITE_ADDR_ADDR_LSB) & WINDOW_WRITE_ADDR_ADDR_MASK)
+
+#define WINDOW_READ_ADDR_ADDRESS                 0x0000047c
+#define WINDOW_READ_ADDR_OFFSET                  0x0000047c
+#define WINDOW_READ_ADDR_ADDR_MSB                7
+#define WINDOW_READ_ADDR_ADDR_LSB                0
+#define WINDOW_READ_ADDR_ADDR_MASK               0x000000ff
+#define WINDOW_READ_ADDR_ADDR_GET(x)             (((x) & WINDOW_READ_ADDR_ADDR_MASK) >> WINDOW_READ_ADDR_ADDR_LSB)
+#define WINDOW_READ_ADDR_ADDR_SET(x)             (((x) << WINDOW_READ_ADDR_ADDR_LSB) & WINDOW_READ_ADDR_ADDR_MASK)
+
+#define SPI_CONFIG_ADDRESS                       0x00000480
+#define SPI_CONFIG_OFFSET                        0x00000480
+#define SPI_CONFIG_SPI_RESET_MSB                 4
+#define SPI_CONFIG_SPI_RESET_LSB                 4
+#define SPI_CONFIG_SPI_RESET_MASK                0x00000010
+#define SPI_CONFIG_SPI_RESET_GET(x)              (((x) & SPI_CONFIG_SPI_RESET_MASK) >> SPI_CONFIG_SPI_RESET_LSB)
+#define SPI_CONFIG_SPI_RESET_SET(x)              (((x) << SPI_CONFIG_SPI_RESET_LSB) & SPI_CONFIG_SPI_RESET_MASK)
+#define SPI_CONFIG_INTERRUPT_ENABLE_MSB          3
+#define SPI_CONFIG_INTERRUPT_ENABLE_LSB          3
+#define SPI_CONFIG_INTERRUPT_ENABLE_MASK         0x00000008
+#define SPI_CONFIG_INTERRUPT_ENABLE_GET(x)       (((x) & SPI_CONFIG_INTERRUPT_ENABLE_MASK) >> SPI_CONFIG_INTERRUPT_ENABLE_LSB)
+#define SPI_CONFIG_INTERRUPT_ENABLE_SET(x)       (((x) << SPI_CONFIG_INTERRUPT_ENABLE_LSB) & SPI_CONFIG_INTERRUPT_ENABLE_MASK)
+#define SPI_CONFIG_TEST_MODE_MSB                 2
+#define SPI_CONFIG_TEST_MODE_LSB                 2
+#define SPI_CONFIG_TEST_MODE_MASK                0x00000004
+#define SPI_CONFIG_TEST_MODE_GET(x)              (((x) & SPI_CONFIG_TEST_MODE_MASK) >> SPI_CONFIG_TEST_MODE_LSB)
+#define SPI_CONFIG_TEST_MODE_SET(x)              (((x) << SPI_CONFIG_TEST_MODE_LSB) & SPI_CONFIG_TEST_MODE_MASK)
+#define SPI_CONFIG_DATA_SIZE_MSB                 1
+#define SPI_CONFIG_DATA_SIZE_LSB                 0
+#define SPI_CONFIG_DATA_SIZE_MASK                0x00000003
+#define SPI_CONFIG_DATA_SIZE_GET(x)              (((x) & SPI_CONFIG_DATA_SIZE_MASK) >> SPI_CONFIG_DATA_SIZE_LSB)
+#define SPI_CONFIG_DATA_SIZE_SET(x)              (((x) << SPI_CONFIG_DATA_SIZE_LSB) & SPI_CONFIG_DATA_SIZE_MASK)
+
+#define SPI_STATUS_ADDRESS                       0x00000481
+#define SPI_STATUS_OFFSET                        0x00000481
+#define SPI_STATUS_ADDR_ERR_MSB                  3
+#define SPI_STATUS_ADDR_ERR_LSB                  3
+#define SPI_STATUS_ADDR_ERR_MASK                 0x00000008
+#define SPI_STATUS_ADDR_ERR_GET(x)               (((x) & SPI_STATUS_ADDR_ERR_MASK) >> SPI_STATUS_ADDR_ERR_LSB)
+#define SPI_STATUS_ADDR_ERR_SET(x)               (((x) << SPI_STATUS_ADDR_ERR_LSB) & SPI_STATUS_ADDR_ERR_MASK)
+#define SPI_STATUS_RD_ERR_MSB                    2
+#define SPI_STATUS_RD_ERR_LSB                    2
+#define SPI_STATUS_RD_ERR_MASK                   0x00000004
+#define SPI_STATUS_RD_ERR_GET(x)                 (((x) & SPI_STATUS_RD_ERR_MASK) >> SPI_STATUS_RD_ERR_LSB)
+#define SPI_STATUS_RD_ERR_SET(x)                 (((x) << SPI_STATUS_RD_ERR_LSB) & SPI_STATUS_RD_ERR_MASK)
+#define SPI_STATUS_WR_ERR_MSB                    1
+#define SPI_STATUS_WR_ERR_LSB                    1
+#define SPI_STATUS_WR_ERR_MASK                   0x00000002
+#define SPI_STATUS_WR_ERR_GET(x)                 (((x) & SPI_STATUS_WR_ERR_MASK) >> SPI_STATUS_WR_ERR_LSB)
+#define SPI_STATUS_WR_ERR_SET(x)                 (((x) << SPI_STATUS_WR_ERR_LSB) & SPI_STATUS_WR_ERR_MASK)
+#define SPI_STATUS_READY_MSB                     0
+#define SPI_STATUS_READY_LSB                     0
+#define SPI_STATUS_READY_MASK                    0x00000001
+#define SPI_STATUS_READY_GET(x)                  (((x) & SPI_STATUS_READY_MASK) >> SPI_STATUS_READY_LSB)
+#define SPI_STATUS_READY_SET(x)                  (((x) << SPI_STATUS_READY_LSB) & SPI_STATUS_READY_MASK)
+
+#define NON_ASSOC_SLEEP_EN_ADDRESS               0x00000482
+#define NON_ASSOC_SLEEP_EN_OFFSET                0x00000482
+#define NON_ASSOC_SLEEP_EN_BIT_MSB               0
+#define NON_ASSOC_SLEEP_EN_BIT_LSB               0
+#define NON_ASSOC_SLEEP_EN_BIT_MASK              0x00000001
+#define NON_ASSOC_SLEEP_EN_BIT_GET(x)            (((x) & NON_ASSOC_SLEEP_EN_BIT_MASK) >> NON_ASSOC_SLEEP_EN_BIT_LSB)
+#define NON_ASSOC_SLEEP_EN_BIT_SET(x)            (((x) << NON_ASSOC_SLEEP_EN_BIT_LSB) & NON_ASSOC_SLEEP_EN_BIT_MASK)
+
+#define CIS_WINDOW_ADDRESS                       0x00000600
+#define CIS_WINDOW_OFFSET                        0x00000600
+#define CIS_WINDOW_DATA_MSB                      7
+#define CIS_WINDOW_DATA_LSB                      0
+#define CIS_WINDOW_DATA_MASK                     0x000000ff
+#define CIS_WINDOW_DATA_GET(x)                   (((x) & CIS_WINDOW_DATA_MASK) >> CIS_WINDOW_DATA_LSB)
+#define CIS_WINDOW_DATA_SET(x)                   (((x) << CIS_WINDOW_DATA_LSB) & CIS_WINDOW_DATA_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct mbox_host_reg_reg_s {
+  unsigned char pad0[1024]; /* pad to 0x400 */
+  volatile unsigned char host_int_status;
+  volatile unsigned char cpu_int_status;
+  volatile unsigned char error_int_status;
+  volatile unsigned char counter_int_status;
+  volatile unsigned char mbox_frame;
+  volatile unsigned char rx_lookahead_valid;
+  unsigned char pad1[2]; /* pad to 0x408 */
+  volatile unsigned char rx_lookahead0[4];
+  volatile unsigned char rx_lookahead1[4];
+  volatile unsigned char rx_lookahead2[4];
+  volatile unsigned char rx_lookahead3[4];
+  volatile unsigned char int_status_enable;
+  volatile unsigned char cpu_int_status_enable;
+  volatile unsigned char error_status_enable;
+  volatile unsigned char counter_int_status_enable;
+  unsigned char pad2[4]; /* pad to 0x420 */
+  volatile unsigned char count[8];
+  unsigned char pad3[24]; /* pad to 0x440 */
+  volatile unsigned char count_dec[32];
+  volatile unsigned char scratch[8];
+  volatile unsigned char fifo_timeout;
+  volatile unsigned char fifo_timeout_enable;
+  volatile unsigned char disable_sleep;
+  unsigned char pad4[5]; /* pad to 0x470 */
+  volatile unsigned char local_bus;
+  unsigned char pad5[1]; /* pad to 0x472 */
+  volatile unsigned char int_wlan;
+  unsigned char pad6[1]; /* pad to 0x474 */
+  volatile unsigned char window_data[4];
+  volatile unsigned char window_write_addr[4];
+  volatile unsigned char window_read_addr[4];
+  volatile unsigned char spi_config;
+  volatile unsigned char spi_status;
+  volatile unsigned char non_assoc_sleep_en;
+  unsigned char pad7[381]; /* pad to 0x600 */
+  volatile unsigned char cis_window[512];
+} mbox_host_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _MBOX_HOST_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
new file mode 100644
index 0000000..4e07d22
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
@@ -0,0 +1,481 @@
+#ifndef _MBOX_REG_REG_H_
+#define _MBOX_REG_REG_H_
+
+#define MBOX_FIFO_ADDRESS                        0x00000000
+#define MBOX_FIFO_OFFSET                         0x00000000
+#define MBOX_FIFO_DATA_MSB                       19
+#define MBOX_FIFO_DATA_LSB                       0
+#define MBOX_FIFO_DATA_MASK                      0x000fffff
+#define MBOX_FIFO_DATA_GET(x)                    (((x) & MBOX_FIFO_DATA_MASK) >> MBOX_FIFO_DATA_LSB)
+#define MBOX_FIFO_DATA_SET(x)                    (((x) << MBOX_FIFO_DATA_LSB) & MBOX_FIFO_DATA_MASK)
+
+#define MBOX_FIFO_STATUS_ADDRESS                 0x00000010
+#define MBOX_FIFO_STATUS_OFFSET                  0x00000010
+#define MBOX_FIFO_STATUS_EMPTY_MSB               19
+#define MBOX_FIFO_STATUS_EMPTY_LSB               16
+#define MBOX_FIFO_STATUS_EMPTY_MASK              0x000f0000
+#define MBOX_FIFO_STATUS_EMPTY_GET(x)            (((x) & MBOX_FIFO_STATUS_EMPTY_MASK) >> MBOX_FIFO_STATUS_EMPTY_LSB)
+#define MBOX_FIFO_STATUS_EMPTY_SET(x)            (((x) << MBOX_FIFO_STATUS_EMPTY_LSB) & MBOX_FIFO_STATUS_EMPTY_MASK)
+#define MBOX_FIFO_STATUS_FULL_MSB                15
+#define MBOX_FIFO_STATUS_FULL_LSB                12
+#define MBOX_FIFO_STATUS_FULL_MASK               0x0000f000
+#define MBOX_FIFO_STATUS_FULL_GET(x)             (((x) & MBOX_FIFO_STATUS_FULL_MASK) >> MBOX_FIFO_STATUS_FULL_LSB)
+#define MBOX_FIFO_STATUS_FULL_SET(x)             (((x) << MBOX_FIFO_STATUS_FULL_LSB) & MBOX_FIFO_STATUS_FULL_MASK)
+
+#define MBOX_DMA_POLICY_ADDRESS                  0x00000014
+#define MBOX_DMA_POLICY_OFFSET                   0x00000014
+#define MBOX_DMA_POLICY_TX_QUANTUM_MSB           3
+#define MBOX_DMA_POLICY_TX_QUANTUM_LSB           3
+#define MBOX_DMA_POLICY_TX_QUANTUM_MASK          0x00000008
+#define MBOX_DMA_POLICY_TX_QUANTUM_GET(x)        (((x) & MBOX_DMA_POLICY_TX_QUANTUM_MASK) >> MBOX_DMA_POLICY_TX_QUANTUM_LSB)
+#define MBOX_DMA_POLICY_TX_QUANTUM_SET(x)        (((x) << MBOX_DMA_POLICY_TX_QUANTUM_LSB) & MBOX_DMA_POLICY_TX_QUANTUM_MASK)
+#define MBOX_DMA_POLICY_TX_ORDER_MSB             2
+#define MBOX_DMA_POLICY_TX_ORDER_LSB             2
+#define MBOX_DMA_POLICY_TX_ORDER_MASK            0x00000004
+#define MBOX_DMA_POLICY_TX_ORDER_GET(x)          (((x) & MBOX_DMA_POLICY_TX_ORDER_MASK) >> MBOX_DMA_POLICY_TX_ORDER_LSB)
+#define MBOX_DMA_POLICY_TX_ORDER_SET(x)          (((x) << MBOX_DMA_POLICY_TX_ORDER_LSB) & MBOX_DMA_POLICY_TX_ORDER_MASK)
+#define MBOX_DMA_POLICY_RX_QUANTUM_MSB           1
+#define MBOX_DMA_POLICY_RX_QUANTUM_LSB           1
+#define MBOX_DMA_POLICY_RX_QUANTUM_MASK          0x00000002
+#define MBOX_DMA_POLICY_RX_QUANTUM_GET(x)        (((x) & MBOX_DMA_POLICY_RX_QUANTUM_MASK) >> MBOX_DMA_POLICY_RX_QUANTUM_LSB)
+#define MBOX_DMA_POLICY_RX_QUANTUM_SET(x)        (((x) << MBOX_DMA_POLICY_RX_QUANTUM_LSB) & MBOX_DMA_POLICY_RX_QUANTUM_MASK)
+#define MBOX_DMA_POLICY_RX_ORDER_MSB             0
+#define MBOX_DMA_POLICY_RX_ORDER_LSB             0
+#define MBOX_DMA_POLICY_RX_ORDER_MASK            0x00000001
+#define MBOX_DMA_POLICY_RX_ORDER_GET(x)          (((x) & MBOX_DMA_POLICY_RX_ORDER_MASK) >> MBOX_DMA_POLICY_RX_ORDER_LSB)
+#define MBOX_DMA_POLICY_RX_ORDER_SET(x)          (((x) << MBOX_DMA_POLICY_RX_ORDER_LSB) & MBOX_DMA_POLICY_RX_ORDER_MASK)
+
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000018
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000018
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX0_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX0_DMA_RX_CONTROL_ADDRESS             0x0000001c
+#define MBOX0_DMA_RX_CONTROL_OFFSET              0x0000001c
+#define MBOX0_DMA_RX_CONTROL_RESUME_MSB          2
+#define MBOX0_DMA_RX_CONTROL_RESUME_LSB          2
+#define MBOX0_DMA_RX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX0_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX0_DMA_RX_CONTROL_RESUME_MASK) >> MBOX0_DMA_RX_CONTROL_RESUME_LSB)
+#define MBOX0_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX0_DMA_RX_CONTROL_RESUME_LSB) & MBOX0_DMA_RX_CONTROL_RESUME_MASK)
+#define MBOX0_DMA_RX_CONTROL_START_MSB           1
+#define MBOX0_DMA_RX_CONTROL_START_LSB           1
+#define MBOX0_DMA_RX_CONTROL_START_MASK          0x00000002
+#define MBOX0_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX0_DMA_RX_CONTROL_START_MASK) >> MBOX0_DMA_RX_CONTROL_START_LSB)
+#define MBOX0_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX0_DMA_RX_CONTROL_START_LSB) & MBOX0_DMA_RX_CONTROL_START_MASK)
+#define MBOX0_DMA_RX_CONTROL_STOP_MSB            0
+#define MBOX0_DMA_RX_CONTROL_STOP_LSB            0
+#define MBOX0_DMA_RX_CONTROL_STOP_MASK           0x00000001
+#define MBOX0_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX0_DMA_RX_CONTROL_STOP_MASK) >> MBOX0_DMA_RX_CONTROL_STOP_LSB)
+#define MBOX0_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX0_DMA_RX_CONTROL_STOP_LSB) & MBOX0_DMA_RX_CONTROL_STOP_MASK)
+
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000020
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000020
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX0_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX0_DMA_TX_CONTROL_ADDRESS             0x00000024
+#define MBOX0_DMA_TX_CONTROL_OFFSET              0x00000024
+#define MBOX0_DMA_TX_CONTROL_RESUME_MSB          2
+#define MBOX0_DMA_TX_CONTROL_RESUME_LSB          2
+#define MBOX0_DMA_TX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX0_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX0_DMA_TX_CONTROL_RESUME_MASK) >> MBOX0_DMA_TX_CONTROL_RESUME_LSB)
+#define MBOX0_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX0_DMA_TX_CONTROL_RESUME_LSB) & MBOX0_DMA_TX_CONTROL_RESUME_MASK)
+#define MBOX0_DMA_TX_CONTROL_START_MSB           1
+#define MBOX0_DMA_TX_CONTROL_START_LSB           1
+#define MBOX0_DMA_TX_CONTROL_START_MASK          0x00000002
+#define MBOX0_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX0_DMA_TX_CONTROL_START_MASK) >> MBOX0_DMA_TX_CONTROL_START_LSB)
+#define MBOX0_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX0_DMA_TX_CONTROL_START_LSB) & MBOX0_DMA_TX_CONTROL_START_MASK)
+#define MBOX0_DMA_TX_CONTROL_STOP_MSB            0
+#define MBOX0_DMA_TX_CONTROL_STOP_LSB            0
+#define MBOX0_DMA_TX_CONTROL_STOP_MASK           0x00000001
+#define MBOX0_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX0_DMA_TX_CONTROL_STOP_MASK) >> MBOX0_DMA_TX_CONTROL_STOP_LSB)
+#define MBOX0_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX0_DMA_TX_CONTROL_STOP_LSB) & MBOX0_DMA_TX_CONTROL_STOP_MASK)
+
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000028
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000028
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX1_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX1_DMA_RX_CONTROL_ADDRESS             0x0000002c
+#define MBOX1_DMA_RX_CONTROL_OFFSET              0x0000002c
+#define MBOX1_DMA_RX_CONTROL_RESUME_MSB          2
+#define MBOX1_DMA_RX_CONTROL_RESUME_LSB          2
+#define MBOX1_DMA_RX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX1_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX1_DMA_RX_CONTROL_RESUME_MASK) >> MBOX1_DMA_RX_CONTROL_RESUME_LSB)
+#define MBOX1_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX1_DMA_RX_CONTROL_RESUME_LSB) & MBOX1_DMA_RX_CONTROL_RESUME_MASK)
+#define MBOX1_DMA_RX_CONTROL_START_MSB           1
+#define MBOX1_DMA_RX_CONTROL_START_LSB           1
+#define MBOX1_DMA_RX_CONTROL_START_MASK          0x00000002
+#define MBOX1_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX1_DMA_RX_CONTROL_START_MASK) >> MBOX1_DMA_RX_CONTROL_START_LSB)
+#define MBOX1_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX1_DMA_RX_CONTROL_START_LSB) & MBOX1_DMA_RX_CONTROL_START_MASK)
+#define MBOX1_DMA_RX_CONTROL_STOP_MSB            0
+#define MBOX1_DMA_RX_CONTROL_STOP_LSB            0
+#define MBOX1_DMA_RX_CONTROL_STOP_MASK           0x00000001
+#define MBOX1_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX1_DMA_RX_CONTROL_STOP_MASK) >> MBOX1_DMA_RX_CONTROL_STOP_LSB)
+#define MBOX1_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX1_DMA_RX_CONTROL_STOP_LSB) & MBOX1_DMA_RX_CONTROL_STOP_MASK)
+
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000030
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000030
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX1_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX1_DMA_TX_CONTROL_ADDRESS             0x00000034
+#define MBOX1_DMA_TX_CONTROL_OFFSET              0x00000034
+#define MBOX1_DMA_TX_CONTROL_RESUME_MSB          2
+#define MBOX1_DMA_TX_CONTROL_RESUME_LSB          2
+#define MBOX1_DMA_TX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX1_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX1_DMA_TX_CONTROL_RESUME_MASK) >> MBOX1_DMA_TX_CONTROL_RESUME_LSB)
+#define MBOX1_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX1_DMA_TX_CONTROL_RESUME_LSB) & MBOX1_DMA_TX_CONTROL_RESUME_MASK)
+#define MBOX1_DMA_TX_CONTROL_START_MSB           1
+#define MBOX1_DMA_TX_CONTROL_START_LSB           1
+#define MBOX1_DMA_TX_CONTROL_START_MASK          0x00000002
+#define MBOX1_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX1_DMA_TX_CONTROL_START_MASK) >> MBOX1_DMA_TX_CONTROL_START_LSB)
+#define MBOX1_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX1_DMA_TX_CONTROL_START_LSB) & MBOX1_DMA_TX_CONTROL_START_MASK)
+#define MBOX1_DMA_TX_CONTROL_STOP_MSB            0
+#define MBOX1_DMA_TX_CONTROL_STOP_LSB            0
+#define MBOX1_DMA_TX_CONTROL_STOP_MASK           0x00000001
+#define MBOX1_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX1_DMA_TX_CONTROL_STOP_MASK) >> MBOX1_DMA_TX_CONTROL_STOP_LSB)
+#define MBOX1_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX1_DMA_TX_CONTROL_STOP_LSB) & MBOX1_DMA_TX_CONTROL_STOP_MASK)
+
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000038
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000038
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX2_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX2_DMA_RX_CONTROL_ADDRESS             0x0000003c
+#define MBOX2_DMA_RX_CONTROL_OFFSET              0x0000003c
+#define MBOX2_DMA_RX_CONTROL_RESUME_MSB          2
+#define MBOX2_DMA_RX_CONTROL_RESUME_LSB          2
+#define MBOX2_DMA_RX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX2_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX2_DMA_RX_CONTROL_RESUME_MASK) >> MBOX2_DMA_RX_CONTROL_RESUME_LSB)
+#define MBOX2_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX2_DMA_RX_CONTROL_RESUME_LSB) & MBOX2_DMA_RX_CONTROL_RESUME_MASK)
+#define MBOX2_DMA_RX_CONTROL_START_MSB           1
+#define MBOX2_DMA_RX_CONTROL_START_LSB           1
+#define MBOX2_DMA_RX_CONTROL_START_MASK          0x00000002
+#define MBOX2_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX2_DMA_RX_CONTROL_START_MASK) >> MBOX2_DMA_RX_CONTROL_START_LSB)
+#define MBOX2_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX2_DMA_RX_CONTROL_START_LSB) & MBOX2_DMA_RX_CONTROL_START_MASK)
+#define MBOX2_DMA_RX_CONTROL_STOP_MSB            0
+#define MBOX2_DMA_RX_CONTROL_STOP_LSB            0
+#define MBOX2_DMA_RX_CONTROL_STOP_MASK           0x00000001
+#define MBOX2_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX2_DMA_RX_CONTROL_STOP_MASK) >> MBOX2_DMA_RX_CONTROL_STOP_LSB)
+#define MBOX2_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX2_DMA_RX_CONTROL_STOP_LSB) & MBOX2_DMA_RX_CONTROL_STOP_MASK)
+
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000040
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000040
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX2_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX2_DMA_TX_CONTROL_ADDRESS             0x00000044
+#define MBOX2_DMA_TX_CONTROL_OFFSET              0x00000044
+#define MBOX2_DMA_TX_CONTROL_RESUME_MSB          2
+#define MBOX2_DMA_TX_CONTROL_RESUME_LSB          2
+#define MBOX2_DMA_TX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX2_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX2_DMA_TX_CONTROL_RESUME_MASK) >> MBOX2_DMA_TX_CONTROL_RESUME_LSB)
+#define MBOX2_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX2_DMA_TX_CONTROL_RESUME_LSB) & MBOX2_DMA_TX_CONTROL_RESUME_MASK)
+#define MBOX2_DMA_TX_CONTROL_START_MSB           1
+#define MBOX2_DMA_TX_CONTROL_START_LSB           1
+#define MBOX2_DMA_TX_CONTROL_START_MASK          0x00000002
+#define MBOX2_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX2_DMA_TX_CONTROL_START_MASK) >> MBOX2_DMA_TX_CONTROL_START_LSB)
+#define MBOX2_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX2_DMA_TX_CONTROL_START_LSB) & MBOX2_DMA_TX_CONTROL_START_MASK)
+#define MBOX2_DMA_TX_CONTROL_STOP_MSB            0
+#define MBOX2_DMA_TX_CONTROL_STOP_LSB            0
+#define MBOX2_DMA_TX_CONTROL_STOP_MASK           0x00000001
+#define MBOX2_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX2_DMA_TX_CONTROL_STOP_MASK) >> MBOX2_DMA_TX_CONTROL_STOP_LSB)
+#define MBOX2_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX2_DMA_TX_CONTROL_STOP_LSB) & MBOX2_DMA_TX_CONTROL_STOP_MASK)
+
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS     0x00000048
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_OFFSET      0x00000048
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX3_DMA_RX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX3_DMA_RX_CONTROL_ADDRESS             0x0000004c
+#define MBOX3_DMA_RX_CONTROL_OFFSET              0x0000004c
+#define MBOX3_DMA_RX_CONTROL_RESUME_MSB          2
+#define MBOX3_DMA_RX_CONTROL_RESUME_LSB          2
+#define MBOX3_DMA_RX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX3_DMA_RX_CONTROL_RESUME_GET(x)       (((x) & MBOX3_DMA_RX_CONTROL_RESUME_MASK) >> MBOX3_DMA_RX_CONTROL_RESUME_LSB)
+#define MBOX3_DMA_RX_CONTROL_RESUME_SET(x)       (((x) << MBOX3_DMA_RX_CONTROL_RESUME_LSB) & MBOX3_DMA_RX_CONTROL_RESUME_MASK)
+#define MBOX3_DMA_RX_CONTROL_START_MSB           1
+#define MBOX3_DMA_RX_CONTROL_START_LSB           1
+#define MBOX3_DMA_RX_CONTROL_START_MASK          0x00000002
+#define MBOX3_DMA_RX_CONTROL_START_GET(x)        (((x) & MBOX3_DMA_RX_CONTROL_START_MASK) >> MBOX3_DMA_RX_CONTROL_START_LSB)
+#define MBOX3_DMA_RX_CONTROL_START_SET(x)        (((x) << MBOX3_DMA_RX_CONTROL_START_LSB) & MBOX3_DMA_RX_CONTROL_START_MASK)
+#define MBOX3_DMA_RX_CONTROL_STOP_MSB            0
+#define MBOX3_DMA_RX_CONTROL_STOP_LSB            0
+#define MBOX3_DMA_RX_CONTROL_STOP_MASK           0x00000001
+#define MBOX3_DMA_RX_CONTROL_STOP_GET(x)         (((x) & MBOX3_DMA_RX_CONTROL_STOP_MASK) >> MBOX3_DMA_RX_CONTROL_STOP_LSB)
+#define MBOX3_DMA_RX_CONTROL_STOP_SET(x)         (((x) << MBOX3_DMA_RX_CONTROL_STOP_LSB) & MBOX3_DMA_RX_CONTROL_STOP_MASK)
+
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS     0x00000050
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_OFFSET      0x00000050
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MSB 27
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB 2
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK 0x0ffffffc
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_GET(x) (((x) & MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK) >> MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB)
+#define MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_SET(x) (((x) << MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_LSB) & MBOX3_DMA_TX_DESCRIPTOR_BASE_ADDRESS_MASK)
+
+#define MBOX3_DMA_TX_CONTROL_ADDRESS             0x00000054
+#define MBOX3_DMA_TX_CONTROL_OFFSET              0x00000054
+#define MBOX3_DMA_TX_CONTROL_RESUME_MSB          2
+#define MBOX3_DMA_TX_CONTROL_RESUME_LSB          2
+#define MBOX3_DMA_TX_CONTROL_RESUME_MASK         0x00000004
+#define MBOX3_DMA_TX_CONTROL_RESUME_GET(x)       (((x) & MBOX3_DMA_TX_CONTROL_RESUME_MASK) >> MBOX3_DMA_TX_CONTROL_RESUME_LSB)
+#define MBOX3_DMA_TX_CONTROL_RESUME_SET(x)       (((x) << MBOX3_DMA_TX_CONTROL_RESUME_LSB) & MBOX3_DMA_TX_CONTROL_RESUME_MASK)
+#define MBOX3_DMA_TX_CONTROL_START_MSB           1
+#define MBOX3_DMA_TX_CONTROL_START_LSB           1
+#define MBOX3_DMA_TX_CONTROL_START_MASK          0x00000002
+#define MBOX3_DMA_TX_CONTROL_START_GET(x)        (((x) & MBOX3_DMA_TX_CONTROL_START_MASK) >> MBOX3_DMA_TX_CONTROL_START_LSB)
+#define MBOX3_DMA_TX_CONTROL_START_SET(x)        (((x) << MBOX3_DMA_TX_CONTROL_START_LSB) & MBOX3_DMA_TX_CONTROL_START_MASK)
+#define MBOX3_DMA_TX_CONTROL_STOP_MSB            0
+#define MBOX3_DMA_TX_CONTROL_STOP_LSB            0
+#define MBOX3_DMA_TX_CONTROL_STOP_MASK           0x00000001
+#define MBOX3_DMA_TX_CONTROL_STOP_GET(x)         (((x) & MBOX3_DMA_TX_CONTROL_STOP_MASK) >> MBOX3_DMA_TX_CONTROL_STOP_LSB)
+#define MBOX3_DMA_TX_CONTROL_STOP_SET(x)         (((x) << MBOX3_DMA_TX_CONTROL_STOP_LSB) & MBOX3_DMA_TX_CONTROL_STOP_MASK)
+
+#define MBOX_INT_STATUS_ADDRESS                  0x00000058
+#define MBOX_INT_STATUS_OFFSET                   0x00000058
+#define MBOX_INT_STATUS_RX_DMA_COMPLETE_MSB      31
+#define MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB      28
+#define MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK     0xf0000000
+#define MBOX_INT_STATUS_RX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK) >> MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB)
+#define MBOX_INT_STATUS_RX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_STATUS_RX_DMA_COMPLETE_LSB) & MBOX_INT_STATUS_RX_DMA_COMPLETE_MASK)
+#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MSB  27
+#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB  24
+#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK 0x0f000000
+#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_GET(x) (((x) & MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK) >> MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB)
+#define MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_SET(x) (((x) << MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_LSB) & MBOX_INT_STATUS_TX_DMA_EOM_COMPLETE_MASK)
+#define MBOX_INT_STATUS_TX_DMA_COMPLETE_MSB      23
+#define MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB      20
+#define MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK     0x00f00000
+#define MBOX_INT_STATUS_TX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK) >> MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB)
+#define MBOX_INT_STATUS_TX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_STATUS_TX_DMA_COMPLETE_LSB) & MBOX_INT_STATUS_TX_DMA_COMPLETE_MASK)
+#define MBOX_INT_STATUS_TX_OVERFLOW_MSB          17
+#define MBOX_INT_STATUS_TX_OVERFLOW_LSB          17
+#define MBOX_INT_STATUS_TX_OVERFLOW_MASK         0x00020000
+#define MBOX_INT_STATUS_TX_OVERFLOW_GET(x)       (((x) & MBOX_INT_STATUS_TX_OVERFLOW_MASK) >> MBOX_INT_STATUS_TX_OVERFLOW_LSB)
+#define MBOX_INT_STATUS_TX_OVERFLOW_SET(x)       (((x) << MBOX_INT_STATUS_TX_OVERFLOW_LSB) & MBOX_INT_STATUS_TX_OVERFLOW_MASK)
+#define MBOX_INT_STATUS_RX_UNDERFLOW_MSB         16
+#define MBOX_INT_STATUS_RX_UNDERFLOW_LSB         16
+#define MBOX_INT_STATUS_RX_UNDERFLOW_MASK        0x00010000
+#define MBOX_INT_STATUS_RX_UNDERFLOW_GET(x)      (((x) & MBOX_INT_STATUS_RX_UNDERFLOW_MASK) >> MBOX_INT_STATUS_RX_UNDERFLOW_LSB)
+#define MBOX_INT_STATUS_RX_UNDERFLOW_SET(x)      (((x) << MBOX_INT_STATUS_RX_UNDERFLOW_LSB) & MBOX_INT_STATUS_RX_UNDERFLOW_MASK)
+#define MBOX_INT_STATUS_TX_NOT_EMPTY_MSB         15
+#define MBOX_INT_STATUS_TX_NOT_EMPTY_LSB         12
+#define MBOX_INT_STATUS_TX_NOT_EMPTY_MASK        0x0000f000
+#define MBOX_INT_STATUS_TX_NOT_EMPTY_GET(x)      (((x) & MBOX_INT_STATUS_TX_NOT_EMPTY_MASK) >> MBOX_INT_STATUS_TX_NOT_EMPTY_LSB)
+#define MBOX_INT_STATUS_TX_NOT_EMPTY_SET(x)      (((x) << MBOX_INT_STATUS_TX_NOT_EMPTY_LSB) & MBOX_INT_STATUS_TX_NOT_EMPTY_MASK)
+#define MBOX_INT_STATUS_RX_NOT_FULL_MSB          11
+#define MBOX_INT_STATUS_RX_NOT_FULL_LSB          8
+#define MBOX_INT_STATUS_RX_NOT_FULL_MASK         0x00000f00
+#define MBOX_INT_STATUS_RX_NOT_FULL_GET(x)       (((x) & MBOX_INT_STATUS_RX_NOT_FULL_MASK) >> MBOX_INT_STATUS_RX_NOT_FULL_LSB)
+#define MBOX_INT_STATUS_RX_NOT_FULL_SET(x)       (((x) << MBOX_INT_STATUS_RX_NOT_FULL_LSB) & MBOX_INT_STATUS_RX_NOT_FULL_MASK)
+#define MBOX_INT_STATUS_HOST_MSB                 7
+#define MBOX_INT_STATUS_HOST_LSB                 0
+#define MBOX_INT_STATUS_HOST_MASK                0x000000ff
+#define MBOX_INT_STATUS_HOST_GET(x)              (((x) & MBOX_INT_STATUS_HOST_MASK) >> MBOX_INT_STATUS_HOST_LSB)
+#define MBOX_INT_STATUS_HOST_SET(x)              (((x) << MBOX_INT_STATUS_HOST_LSB) & MBOX_INT_STATUS_HOST_MASK)
+
+#define MBOX_INT_ENABLE_ADDRESS                  0x0000005c
+#define MBOX_INT_ENABLE_OFFSET                   0x0000005c
+#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_MSB      31
+#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB      28
+#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK     0xf0000000
+#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK) >> MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB)
+#define MBOX_INT_ENABLE_RX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_ENABLE_RX_DMA_COMPLETE_LSB) & MBOX_INT_ENABLE_RX_DMA_COMPLETE_MASK)
+#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MSB  27
+#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB  24
+#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK 0x0f000000
+#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_GET(x) (((x) & MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK) >> MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB)
+#define MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_SET(x) (((x) << MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_LSB) & MBOX_INT_ENABLE_TX_DMA_EOM_COMPLETE_MASK)
+#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_MSB      23
+#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB      20
+#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK     0x00f00000
+#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_GET(x)   (((x) & MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK) >> MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB)
+#define MBOX_INT_ENABLE_TX_DMA_COMPLETE_SET(x)   (((x) << MBOX_INT_ENABLE_TX_DMA_COMPLETE_LSB) & MBOX_INT_ENABLE_TX_DMA_COMPLETE_MASK)
+#define MBOX_INT_ENABLE_TX_OVERFLOW_MSB          17
+#define MBOX_INT_ENABLE_TX_OVERFLOW_LSB          17
+#define MBOX_INT_ENABLE_TX_OVERFLOW_MASK         0x00020000
+#define MBOX_INT_ENABLE_TX_OVERFLOW_GET(x)       (((x) & MBOX_INT_ENABLE_TX_OVERFLOW_MASK) >> MBOX_INT_ENABLE_TX_OVERFLOW_LSB)
+#define MBOX_INT_ENABLE_TX_OVERFLOW_SET(x)       (((x) << MBOX_INT_ENABLE_TX_OVERFLOW_LSB) & MBOX_INT_ENABLE_TX_OVERFLOW_MASK)
+#define MBOX_INT_ENABLE_RX_UNDERFLOW_MSB         16
+#define MBOX_INT_ENABLE_RX_UNDERFLOW_LSB         16
+#define MBOX_INT_ENABLE_RX_UNDERFLOW_MASK        0x00010000
+#define MBOX_INT_ENABLE_RX_UNDERFLOW_GET(x)      (((x) & MBOX_INT_ENABLE_RX_UNDERFLOW_MASK) >> MBOX_INT_ENABLE_RX_UNDERFLOW_LSB)
+#define MBOX_INT_ENABLE_RX_UNDERFLOW_SET(x)      (((x) << MBOX_INT_ENABLE_RX_UNDERFLOW_LSB) & MBOX_INT_ENABLE_RX_UNDERFLOW_MASK)
+#define MBOX_INT_ENABLE_TX_NOT_EMPTY_MSB         15
+#define MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB         12
+#define MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK        0x0000f000
+#define MBOX_INT_ENABLE_TX_NOT_EMPTY_GET(x)      (((x) & MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK) >> MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB)
+#define MBOX_INT_ENABLE_TX_NOT_EMPTY_SET(x)      (((x) << MBOX_INT_ENABLE_TX_NOT_EMPTY_LSB) & MBOX_INT_ENABLE_TX_NOT_EMPTY_MASK)
+#define MBOX_INT_ENABLE_RX_NOT_FULL_MSB          11
+#define MBOX_INT_ENABLE_RX_NOT_FULL_LSB          8
+#define MBOX_INT_ENABLE_RX_NOT_FULL_MASK         0x00000f00
+#define MBOX_INT_ENABLE_RX_NOT_FULL_GET(x)       (((x) & MBOX_INT_ENABLE_RX_NOT_FULL_MASK) >> MBOX_INT_ENABLE_RX_NOT_FULL_LSB)
+#define MBOX_INT_ENABLE_RX_NOT_FULL_SET(x)       (((x) << MBOX_INT_ENABLE_RX_NOT_FULL_LSB) & MBOX_INT_ENABLE_RX_NOT_FULL_MASK)
+#define MBOX_INT_ENABLE_HOST_MSB                 7
+#define MBOX_INT_ENABLE_HOST_LSB                 0
+#define MBOX_INT_ENABLE_HOST_MASK                0x000000ff
+#define MBOX_INT_ENABLE_HOST_GET(x)              (((x) & MBOX_INT_ENABLE_HOST_MASK) >> MBOX_INT_ENABLE_HOST_LSB)
+#define MBOX_INT_ENABLE_HOST_SET(x)              (((x) << MBOX_INT_ENABLE_HOST_LSB) & MBOX_INT_ENABLE_HOST_MASK)
+
+#define INT_HOST_ADDRESS                         0x00000060
+#define INT_HOST_OFFSET                          0x00000060
+#define INT_HOST_VECTOR_MSB                      7
+#define INT_HOST_VECTOR_LSB                      0
+#define INT_HOST_VECTOR_MASK                     0x000000ff
+#define INT_HOST_VECTOR_GET(x)                   (((x) & INT_HOST_VECTOR_MASK) >> INT_HOST_VECTOR_LSB)
+#define INT_HOST_VECTOR_SET(x)                   (((x) << INT_HOST_VECTOR_LSB) & INT_HOST_VECTOR_MASK)
+
+#define LOCAL_COUNT_ADDRESS                      0x00000080
+#define LOCAL_COUNT_OFFSET                       0x00000080
+#define LOCAL_COUNT_VALUE_MSB                    7
+#define LOCAL_COUNT_VALUE_LSB                    0
+#define LOCAL_COUNT_VALUE_MASK                   0x000000ff
+#define LOCAL_COUNT_VALUE_GET(x)                 (((x) & LOCAL_COUNT_VALUE_MASK) >> LOCAL_COUNT_VALUE_LSB)
+#define LOCAL_COUNT_VALUE_SET(x)                 (((x) << LOCAL_COUNT_VALUE_LSB) & LOCAL_COUNT_VALUE_MASK)
+
+#define COUNT_INC_ADDRESS                        0x000000a0
+#define COUNT_INC_OFFSET                         0x000000a0
+#define COUNT_INC_VALUE_MSB                      7
+#define COUNT_INC_VALUE_LSB                      0
+#define COUNT_INC_VALUE_MASK                     0x000000ff
+#define COUNT_INC_VALUE_GET(x)                   (((x) & COUNT_INC_VALUE_MASK) >> COUNT_INC_VALUE_LSB)
+#define COUNT_INC_VALUE_SET(x)                   (((x) << COUNT_INC_VALUE_LSB) & COUNT_INC_VALUE_MASK)
+
+#define LOCAL_SCRATCH_ADDRESS                    0x000000c0
+#define LOCAL_SCRATCH_OFFSET                     0x000000c0
+#define LOCAL_SCRATCH_VALUE_MSB                  7
+#define LOCAL_SCRATCH_VALUE_LSB                  0
+#define LOCAL_SCRATCH_VALUE_MASK                 0x000000ff
+#define LOCAL_SCRATCH_VALUE_GET(x)               (((x) & LOCAL_SCRATCH_VALUE_MASK) >> LOCAL_SCRATCH_VALUE_LSB)
+#define LOCAL_SCRATCH_VALUE_SET(x)               (((x) << LOCAL_SCRATCH_VALUE_LSB) & LOCAL_SCRATCH_VALUE_MASK)
+
+#define USE_LOCAL_BUS_ADDRESS                    0x000000e0
+#define USE_LOCAL_BUS_OFFSET                     0x000000e0
+#define USE_LOCAL_BUS_PIN_INIT_MSB               0
+#define USE_LOCAL_BUS_PIN_INIT_LSB               0
+#define USE_LOCAL_BUS_PIN_INIT_MASK              0x00000001
+#define USE_LOCAL_BUS_PIN_INIT_GET(x)            (((x) & USE_LOCAL_BUS_PIN_INIT_MASK) >> USE_LOCAL_BUS_PIN_INIT_LSB)
+#define USE_LOCAL_BUS_PIN_INIT_SET(x)            (((x) << USE_LOCAL_BUS_PIN_INIT_LSB) & USE_LOCAL_BUS_PIN_INIT_MASK)
+
+#define SDIO_CONFIG_ADDRESS                      0x000000e4
+#define SDIO_CONFIG_OFFSET                       0x000000e4
+#define SDIO_CONFIG_CCCR_IOR1_MSB                0
+#define SDIO_CONFIG_CCCR_IOR1_LSB                0
+#define SDIO_CONFIG_CCCR_IOR1_MASK               0x00000001
+#define SDIO_CONFIG_CCCR_IOR1_GET(x)             (((x) & SDIO_CONFIG_CCCR_IOR1_MASK) >> SDIO_CONFIG_CCCR_IOR1_LSB)
+#define SDIO_CONFIG_CCCR_IOR1_SET(x)             (((x) << SDIO_CONFIG_CCCR_IOR1_LSB) & SDIO_CONFIG_CCCR_IOR1_MASK)
+
+#define MBOX_DEBUG_ADDRESS                       0x000000e8
+#define MBOX_DEBUG_OFFSET                        0x000000e8
+#define MBOX_DEBUG_SEL_MSB                       2
+#define MBOX_DEBUG_SEL_LSB                       0
+#define MBOX_DEBUG_SEL_MASK                      0x00000007
+#define MBOX_DEBUG_SEL_GET(x)                    (((x) & MBOX_DEBUG_SEL_MASK) >> MBOX_DEBUG_SEL_LSB)
+#define MBOX_DEBUG_SEL_SET(x)                    (((x) << MBOX_DEBUG_SEL_LSB) & MBOX_DEBUG_SEL_MASK)
+
+#define MBOX_FIFO_RESET_ADDRESS                  0x000000ec
+#define MBOX_FIFO_RESET_OFFSET                   0x000000ec
+#define MBOX_FIFO_RESET_INIT_MSB                 0
+#define MBOX_FIFO_RESET_INIT_LSB                 0
+#define MBOX_FIFO_RESET_INIT_MASK                0x00000001
+#define MBOX_FIFO_RESET_INIT_GET(x)              (((x) & MBOX_FIFO_RESET_INIT_MASK) >> MBOX_FIFO_RESET_INIT_LSB)
+#define MBOX_FIFO_RESET_INIT_SET(x)              (((x) << MBOX_FIFO_RESET_INIT_LSB) & MBOX_FIFO_RESET_INIT_MASK)
+
+#define MBOX_TXFIFO_POP_ADDRESS                  0x000000f0
+#define MBOX_TXFIFO_POP_OFFSET                   0x000000f0
+#define MBOX_TXFIFO_POP_DATA_MSB                 0
+#define MBOX_TXFIFO_POP_DATA_LSB                 0
+#define MBOX_TXFIFO_POP_DATA_MASK                0x00000001
+#define MBOX_TXFIFO_POP_DATA_GET(x)              (((x) & MBOX_TXFIFO_POP_DATA_MASK) >> MBOX_TXFIFO_POP_DATA_LSB)
+#define MBOX_TXFIFO_POP_DATA_SET(x)              (((x) << MBOX_TXFIFO_POP_DATA_LSB) & MBOX_TXFIFO_POP_DATA_MASK)
+
+#define MBOX_RXFIFO_POP_ADDRESS                  0x00000100
+#define MBOX_RXFIFO_POP_OFFSET                   0x00000100
+#define MBOX_RXFIFO_POP_DATA_MSB                 0
+#define MBOX_RXFIFO_POP_DATA_LSB                 0
+#define MBOX_RXFIFO_POP_DATA_MASK                0x00000001
+#define MBOX_RXFIFO_POP_DATA_GET(x)              (((x) & MBOX_RXFIFO_POP_DATA_MASK) >> MBOX_RXFIFO_POP_DATA_LSB)
+#define MBOX_RXFIFO_POP_DATA_SET(x)              (((x) << MBOX_RXFIFO_POP_DATA_LSB) & MBOX_RXFIFO_POP_DATA_MASK)
+
+#define SDIO_DEBUG_ADDRESS                       0x00000110
+#define SDIO_DEBUG_OFFSET                        0x00000110
+#define SDIO_DEBUG_SEL_MSB                       3
+#define SDIO_DEBUG_SEL_LSB                       0
+#define SDIO_DEBUG_SEL_MASK                      0x0000000f
+#define SDIO_DEBUG_SEL_GET(x)                    (((x) & SDIO_DEBUG_SEL_MASK) >> SDIO_DEBUG_SEL_LSB)
+#define SDIO_DEBUG_SEL_SET(x)                    (((x) << SDIO_DEBUG_SEL_LSB) & SDIO_DEBUG_SEL_MASK)
+
+#define HOST_IF_WINDOW_ADDRESS                   0x00002000
+#define HOST_IF_WINDOW_OFFSET                    0x00002000
+#define HOST_IF_WINDOW_DATA_MSB                  7
+#define HOST_IF_WINDOW_DATA_LSB                  0
+#define HOST_IF_WINDOW_DATA_MASK                 0x000000ff
+#define HOST_IF_WINDOW_DATA_GET(x)               (((x) & HOST_IF_WINDOW_DATA_MASK) >> HOST_IF_WINDOW_DATA_LSB)
+#define HOST_IF_WINDOW_DATA_SET(x)               (((x) << HOST_IF_WINDOW_DATA_LSB) & HOST_IF_WINDOW_DATA_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct mbox_reg_reg_s {
+  volatile unsigned int mbox_fifo[4];
+  volatile unsigned int mbox_fifo_status;
+  volatile unsigned int mbox_dma_policy;
+  volatile unsigned int mbox0_dma_rx_descriptor_base;
+  volatile unsigned int mbox0_dma_rx_control;
+  volatile unsigned int mbox0_dma_tx_descriptor_base;
+  volatile unsigned int mbox0_dma_tx_control;
+  volatile unsigned int mbox1_dma_rx_descriptor_base;
+  volatile unsigned int mbox1_dma_rx_control;
+  volatile unsigned int mbox1_dma_tx_descriptor_base;
+  volatile unsigned int mbox1_dma_tx_control;
+  volatile unsigned int mbox2_dma_rx_descriptor_base;
+  volatile unsigned int mbox2_dma_rx_control;
+  volatile unsigned int mbox2_dma_tx_descriptor_base;
+  volatile unsigned int mbox2_dma_tx_control;
+  volatile unsigned int mbox3_dma_rx_descriptor_base;
+  volatile unsigned int mbox3_dma_rx_control;
+  volatile unsigned int mbox3_dma_tx_descriptor_base;
+  volatile unsigned int mbox3_dma_tx_control;
+  volatile unsigned int mbox_int_status;
+  volatile unsigned int mbox_int_enable;
+  volatile unsigned int int_host;
+  unsigned char pad0[28]; /* pad to 0x80 */
+  volatile unsigned int local_count[8];
+  volatile unsigned int count_inc[8];
+  volatile unsigned int local_scratch[8];
+  volatile unsigned int use_local_bus;
+  volatile unsigned int sdio_config;
+  volatile unsigned int mbox_debug;
+  volatile unsigned int mbox_fifo_reset;
+  volatile unsigned int mbox_txfifo_pop[4];
+  volatile unsigned int mbox_rxfifo_pop[4];
+  volatile unsigned int sdio_debug;
+  unsigned char pad1[7916]; /* pad to 0x2000 */
+  volatile unsigned int host_if_window[2048];
+} mbox_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _MBOX_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
new file mode 100644
index 0000000..8b3980a
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
@@ -0,0 +1,1163 @@
+#ifndef _RTC_REG_REG_H_
+#define _RTC_REG_REG_H_
+
+#define RESET_CONTROL_ADDRESS                    0x00000000
+#define RESET_CONTROL_OFFSET                     0x00000000
+#define RESET_CONTROL_CPU_INIT_RESET_MSB         11
+#define RESET_CONTROL_CPU_INIT_RESET_LSB         11
+#define RESET_CONTROL_CPU_INIT_RESET_MASK        0x00000800
+#define RESET_CONTROL_CPU_INIT_RESET_GET(x)      (((x) & RESET_CONTROL_CPU_INIT_RESET_MASK) >> RESET_CONTROL_CPU_INIT_RESET_LSB)
+#define RESET_CONTROL_CPU_INIT_RESET_SET(x)      (((x) << RESET_CONTROL_CPU_INIT_RESET_LSB) & RESET_CONTROL_CPU_INIT_RESET_MASK)
+#define RESET_CONTROL_VMC_REMAP_RESET_MSB        10
+#define RESET_CONTROL_VMC_REMAP_RESET_LSB        10
+#define RESET_CONTROL_VMC_REMAP_RESET_MASK       0x00000400
+#define RESET_CONTROL_VMC_REMAP_RESET_GET(x)     (((x) & RESET_CONTROL_VMC_REMAP_RESET_MASK) >> RESET_CONTROL_VMC_REMAP_RESET_LSB)
+#define RESET_CONTROL_VMC_REMAP_RESET_SET(x)     (((x) << RESET_CONTROL_VMC_REMAP_RESET_LSB) & RESET_CONTROL_VMC_REMAP_RESET_MASK)
+#define RESET_CONTROL_RST_OUT_MSB                9
+#define RESET_CONTROL_RST_OUT_LSB                9
+#define RESET_CONTROL_RST_OUT_MASK               0x00000200
+#define RESET_CONTROL_RST_OUT_GET(x)             (((x) & RESET_CONTROL_RST_OUT_MASK) >> RESET_CONTROL_RST_OUT_LSB)
+#define RESET_CONTROL_RST_OUT_SET(x)             (((x) << RESET_CONTROL_RST_OUT_LSB) & RESET_CONTROL_RST_OUT_MASK)
+#define RESET_CONTROL_COLD_RST_MSB               8
+#define RESET_CONTROL_COLD_RST_LSB               8
+#define RESET_CONTROL_COLD_RST_MASK              0x00000100
+#define RESET_CONTROL_COLD_RST_GET(x)            (((x) & RESET_CONTROL_COLD_RST_MASK) >> RESET_CONTROL_COLD_RST_LSB)
+#define RESET_CONTROL_COLD_RST_SET(x)            (((x) << RESET_CONTROL_COLD_RST_LSB) & RESET_CONTROL_COLD_RST_MASK)
+#define RESET_CONTROL_WARM_RST_MSB               7
+#define RESET_CONTROL_WARM_RST_LSB               7
+#define RESET_CONTROL_WARM_RST_MASK              0x00000080
+#define RESET_CONTROL_WARM_RST_GET(x)            (((x) & RESET_CONTROL_WARM_RST_MASK) >> RESET_CONTROL_WARM_RST_LSB)
+#define RESET_CONTROL_WARM_RST_SET(x)            (((x) << RESET_CONTROL_WARM_RST_LSB) & RESET_CONTROL_WARM_RST_MASK)
+#define RESET_CONTROL_CPU_WARM_RST_MSB           6
+#define RESET_CONTROL_CPU_WARM_RST_LSB           6
+#define RESET_CONTROL_CPU_WARM_RST_MASK          0x00000040
+#define RESET_CONTROL_CPU_WARM_RST_GET(x)        (((x) & RESET_CONTROL_CPU_WARM_RST_MASK) >> RESET_CONTROL_CPU_WARM_RST_LSB)
+#define RESET_CONTROL_CPU_WARM_RST_SET(x)        (((x) << RESET_CONTROL_CPU_WARM_RST_LSB) & RESET_CONTROL_CPU_WARM_RST_MASK)
+#define RESET_CONTROL_MAC_COLD_RST_MSB           5
+#define RESET_CONTROL_MAC_COLD_RST_LSB           5
+#define RESET_CONTROL_MAC_COLD_RST_MASK          0x00000020
+#define RESET_CONTROL_MAC_COLD_RST_GET(x)        (((x) & RESET_CONTROL_MAC_COLD_RST_MASK) >> RESET_CONTROL_MAC_COLD_RST_LSB)
+#define RESET_CONTROL_MAC_COLD_RST_SET(x)        (((x) << RESET_CONTROL_MAC_COLD_RST_LSB) & RESET_CONTROL_MAC_COLD_RST_MASK)
+#define RESET_CONTROL_MAC_WARM_RST_MSB           4
+#define RESET_CONTROL_MAC_WARM_RST_LSB           4
+#define RESET_CONTROL_MAC_WARM_RST_MASK          0x00000010
+#define RESET_CONTROL_MAC_WARM_RST_GET(x)        (((x) & RESET_CONTROL_MAC_WARM_RST_MASK) >> RESET_CONTROL_MAC_WARM_RST_LSB)
+#define RESET_CONTROL_MAC_WARM_RST_SET(x)        (((x) << RESET_CONTROL_MAC_WARM_RST_LSB) & RESET_CONTROL_MAC_WARM_RST_MASK)
+#define RESET_CONTROL_MBOX_RST_MSB               2
+#define RESET_CONTROL_MBOX_RST_LSB               2
+#define RESET_CONTROL_MBOX_RST_MASK              0x00000004
+#define RESET_CONTROL_MBOX_RST_GET(x)            (((x) & RESET_CONTROL_MBOX_RST_MASK) >> RESET_CONTROL_MBOX_RST_LSB)
+#define RESET_CONTROL_MBOX_RST_SET(x)            (((x) << RESET_CONTROL_MBOX_RST_LSB) & RESET_CONTROL_MBOX_RST_MASK)
+#define RESET_CONTROL_UART_RST_MSB               1
+#define RESET_CONTROL_UART_RST_LSB               1
+#define RESET_CONTROL_UART_RST_MASK              0x00000002
+#define RESET_CONTROL_UART_RST_GET(x)            (((x) & RESET_CONTROL_UART_RST_MASK) >> RESET_CONTROL_UART_RST_LSB)
+#define RESET_CONTROL_UART_RST_SET(x)            (((x) << RESET_CONTROL_UART_RST_LSB) & RESET_CONTROL_UART_RST_MASK)
+#define RESET_CONTROL_SI0_RST_MSB                0
+#define RESET_CONTROL_SI0_RST_LSB                0
+#define RESET_CONTROL_SI0_RST_MASK               0x00000001
+#define RESET_CONTROL_SI0_RST_GET(x)             (((x) & RESET_CONTROL_SI0_RST_MASK) >> RESET_CONTROL_SI0_RST_LSB)
+#define RESET_CONTROL_SI0_RST_SET(x)             (((x) << RESET_CONTROL_SI0_RST_LSB) & RESET_CONTROL_SI0_RST_MASK)
+
+#define XTAL_CONTROL_ADDRESS                     0x00000004
+#define XTAL_CONTROL_OFFSET                      0x00000004
+#define XTAL_CONTROL_TCXO_MSB                    0
+#define XTAL_CONTROL_TCXO_LSB                    0
+#define XTAL_CONTROL_TCXO_MASK                   0x00000001
+#define XTAL_CONTROL_TCXO_GET(x)                 (((x) & XTAL_CONTROL_TCXO_MASK) >> XTAL_CONTROL_TCXO_LSB)
+#define XTAL_CONTROL_TCXO_SET(x)                 (((x) << XTAL_CONTROL_TCXO_LSB) & XTAL_CONTROL_TCXO_MASK)
+
+#define TCXO_DETECT_ADDRESS                      0x00000008
+#define TCXO_DETECT_OFFSET                       0x00000008
+#define TCXO_DETECT_PRESENT_MSB                  0
+#define TCXO_DETECT_PRESENT_LSB                  0
+#define TCXO_DETECT_PRESENT_MASK                 0x00000001
+#define TCXO_DETECT_PRESENT_GET(x)               (((x) & TCXO_DETECT_PRESENT_MASK) >> TCXO_DETECT_PRESENT_LSB)
+#define TCXO_DETECT_PRESENT_SET(x)               (((x) << TCXO_DETECT_PRESENT_LSB) & TCXO_DETECT_PRESENT_MASK)
+
+#define XTAL_TEST_ADDRESS                        0x0000000c
+#define XTAL_TEST_OFFSET                         0x0000000c
+#define XTAL_TEST_NOTCXODET_MSB                  0
+#define XTAL_TEST_NOTCXODET_LSB                  0
+#define XTAL_TEST_NOTCXODET_MASK                 0x00000001
+#define XTAL_TEST_NOTCXODET_GET(x)               (((x) & XTAL_TEST_NOTCXODET_MASK) >> XTAL_TEST_NOTCXODET_LSB)
+#define XTAL_TEST_NOTCXODET_SET(x)               (((x) << XTAL_TEST_NOTCXODET_LSB) & XTAL_TEST_NOTCXODET_MASK)
+
+#define QUADRATURE_ADDRESS                       0x00000010
+#define QUADRATURE_OFFSET                        0x00000010
+#define QUADRATURE_ADC_MSB                       5
+#define QUADRATURE_ADC_LSB                       4
+#define QUADRATURE_ADC_MASK                      0x00000030
+#define QUADRATURE_ADC_GET(x)                    (((x) & QUADRATURE_ADC_MASK) >> QUADRATURE_ADC_LSB)
+#define QUADRATURE_ADC_SET(x)                    (((x) << QUADRATURE_ADC_LSB) & QUADRATURE_ADC_MASK)
+#define QUADRATURE_SEL_MSB                       2
+#define QUADRATURE_SEL_LSB                       2
+#define QUADRATURE_SEL_MASK                      0x00000004
+#define QUADRATURE_SEL_GET(x)                    (((x) & QUADRATURE_SEL_MASK) >> QUADRATURE_SEL_LSB)
+#define QUADRATURE_SEL_SET(x)                    (((x) << QUADRATURE_SEL_LSB) & QUADRATURE_SEL_MASK)
+#define QUADRATURE_DAC_MSB                       1
+#define QUADRATURE_DAC_LSB                       0
+#define QUADRATURE_DAC_MASK                      0x00000003
+#define QUADRATURE_DAC_GET(x)                    (((x) & QUADRATURE_DAC_MASK) >> QUADRATURE_DAC_LSB)
+#define QUADRATURE_DAC_SET(x)                    (((x) << QUADRATURE_DAC_LSB) & QUADRATURE_DAC_MASK)
+
+#define PLL_CONTROL_ADDRESS                      0x00000014
+#define PLL_CONTROL_OFFSET                       0x00000014
+#define PLL_CONTROL_DIG_TEST_CLK_MSB             20
+#define PLL_CONTROL_DIG_TEST_CLK_LSB             20
+#define PLL_CONTROL_DIG_TEST_CLK_MASK            0x00100000
+#define PLL_CONTROL_DIG_TEST_CLK_GET(x)          (((x) & PLL_CONTROL_DIG_TEST_CLK_MASK) >> PLL_CONTROL_DIG_TEST_CLK_LSB)
+#define PLL_CONTROL_DIG_TEST_CLK_SET(x)          (((x) << PLL_CONTROL_DIG_TEST_CLK_LSB) & PLL_CONTROL_DIG_TEST_CLK_MASK)
+#define PLL_CONTROL_MAC_OVERRIDE_MSB             19
+#define PLL_CONTROL_MAC_OVERRIDE_LSB             19
+#define PLL_CONTROL_MAC_OVERRIDE_MASK            0x00080000
+#define PLL_CONTROL_MAC_OVERRIDE_GET(x)          (((x) & PLL_CONTROL_MAC_OVERRIDE_MASK) >> PLL_CONTROL_MAC_OVERRIDE_LSB)
+#define PLL_CONTROL_MAC_OVERRIDE_SET(x)          (((x) << PLL_CONTROL_MAC_OVERRIDE_LSB) & PLL_CONTROL_MAC_OVERRIDE_MASK)
+#define PLL_CONTROL_NOPWD_MSB                    18
+#define PLL_CONTROL_NOPWD_LSB                    18
+#define PLL_CONTROL_NOPWD_MASK                   0x00040000
+#define PLL_CONTROL_NOPWD_GET(x)                 (((x) & PLL_CONTROL_NOPWD_MASK) >> PLL_CONTROL_NOPWD_LSB)
+#define PLL_CONTROL_NOPWD_SET(x)                 (((x) << PLL_CONTROL_NOPWD_LSB) & PLL_CONTROL_NOPWD_MASK)
+#define PLL_CONTROL_UPDATING_MSB                 17
+#define PLL_CONTROL_UPDATING_LSB                 17
+#define PLL_CONTROL_UPDATING_MASK                0x00020000
+#define PLL_CONTROL_UPDATING_GET(x)              (((x) & PLL_CONTROL_UPDATING_MASK) >> PLL_CONTROL_UPDATING_LSB)
+#define PLL_CONTROL_UPDATING_SET(x)              (((x) << PLL_CONTROL_UPDATING_LSB) & PLL_CONTROL_UPDATING_MASK)
+#define PLL_CONTROL_BYPASS_MSB                   16
+#define PLL_CONTROL_BYPASS_LSB                   16
+#define PLL_CONTROL_BYPASS_MASK                  0x00010000
+#define PLL_CONTROL_BYPASS_GET(x)                (((x) & PLL_CONTROL_BYPASS_MASK) >> PLL_CONTROL_BYPASS_LSB)
+#define PLL_CONTROL_BYPASS_SET(x)                (((x) << PLL_CONTROL_BYPASS_LSB) & PLL_CONTROL_BYPASS_MASK)
+#define PLL_CONTROL_REFDIV_MSB                   15
+#define PLL_CONTROL_REFDIV_LSB                   12
+#define PLL_CONTROL_REFDIV_MASK                  0x0000f000
+#define PLL_CONTROL_REFDIV_GET(x)                (((x) & PLL_CONTROL_REFDIV_MASK) >> PLL_CONTROL_REFDIV_LSB)
+#define PLL_CONTROL_REFDIV_SET(x)                (((x) << PLL_CONTROL_REFDIV_LSB) & PLL_CONTROL_REFDIV_MASK)
+#define PLL_CONTROL_DIV_MSB                      9
+#define PLL_CONTROL_DIV_LSB                      0
+#define PLL_CONTROL_DIV_MASK                     0x000003ff
+#define PLL_CONTROL_DIV_GET(x)                   (((x) & PLL_CONTROL_DIV_MASK) >> PLL_CONTROL_DIV_LSB)
+#define PLL_CONTROL_DIV_SET(x)                   (((x) << PLL_CONTROL_DIV_LSB) & PLL_CONTROL_DIV_MASK)
+
+#define PLL_SETTLE_ADDRESS                       0x00000018
+#define PLL_SETTLE_OFFSET                        0x00000018
+#define PLL_SETTLE_TIME_MSB                      11
+#define PLL_SETTLE_TIME_LSB                      0
+#define PLL_SETTLE_TIME_MASK                     0x00000fff
+#define PLL_SETTLE_TIME_GET(x)                   (((x) & PLL_SETTLE_TIME_MASK) >> PLL_SETTLE_TIME_LSB)
+#define PLL_SETTLE_TIME_SET(x)                   (((x) << PLL_SETTLE_TIME_LSB) & PLL_SETTLE_TIME_MASK)
+
+#define XTAL_SETTLE_ADDRESS                      0x0000001c
+#define XTAL_SETTLE_OFFSET                       0x0000001c
+#define XTAL_SETTLE_TIME_MSB                     7
+#define XTAL_SETTLE_TIME_LSB                     0
+#define XTAL_SETTLE_TIME_MASK                    0x000000ff
+#define XTAL_SETTLE_TIME_GET(x)                  (((x) & XTAL_SETTLE_TIME_MASK) >> XTAL_SETTLE_TIME_LSB)
+#define XTAL_SETTLE_TIME_SET(x)                  (((x) << XTAL_SETTLE_TIME_LSB) & XTAL_SETTLE_TIME_MASK)
+
+#define CPU_CLOCK_ADDRESS                        0x00000020
+#define CPU_CLOCK_OFFSET                         0x00000020
+#define CPU_CLOCK_STANDARD_MSB                   1
+#define CPU_CLOCK_STANDARD_LSB                   0
+#define CPU_CLOCK_STANDARD_MASK                  0x00000003
+#define CPU_CLOCK_STANDARD_GET(x)                (((x) & CPU_CLOCK_STANDARD_MASK) >> CPU_CLOCK_STANDARD_LSB)
+#define CPU_CLOCK_STANDARD_SET(x)                (((x) << CPU_CLOCK_STANDARD_LSB) & CPU_CLOCK_STANDARD_MASK)
+
+#define CLOCK_OUT_ADDRESS                        0x00000024
+#define CLOCK_OUT_OFFSET                         0x00000024
+#define CLOCK_OUT_SELECT_MSB                     3
+#define CLOCK_OUT_SELECT_LSB                     0
+#define CLOCK_OUT_SELECT_MASK                    0x0000000f
+#define CLOCK_OUT_SELECT_GET(x)                  (((x) & CLOCK_OUT_SELECT_MASK) >> CLOCK_OUT_SELECT_LSB)
+#define CLOCK_OUT_SELECT_SET(x)                  (((x) << CLOCK_OUT_SELECT_LSB) & CLOCK_OUT_SELECT_MASK)
+
+#define CLOCK_CONTROL_ADDRESS                    0x00000028
+#define CLOCK_CONTROL_OFFSET                     0x00000028
+#define CLOCK_CONTROL_LF_CLK32_MSB               2
+#define CLOCK_CONTROL_LF_CLK32_LSB               2
+#define CLOCK_CONTROL_LF_CLK32_MASK              0x00000004
+#define CLOCK_CONTROL_LF_CLK32_GET(x)            (((x) & CLOCK_CONTROL_LF_CLK32_MASK) >> CLOCK_CONTROL_LF_CLK32_LSB)
+#define CLOCK_CONTROL_LF_CLK32_SET(x)            (((x) << CLOCK_CONTROL_LF_CLK32_LSB) & CLOCK_CONTROL_LF_CLK32_MASK)
+#define CLOCK_CONTROL_UART_CLK_MSB               1
+#define CLOCK_CONTROL_UART_CLK_LSB               1
+#define CLOCK_CONTROL_UART_CLK_MASK              0x00000002
+#define CLOCK_CONTROL_UART_CLK_GET(x)            (((x) & CLOCK_CONTROL_UART_CLK_MASK) >> CLOCK_CONTROL_UART_CLK_LSB)
+#define CLOCK_CONTROL_UART_CLK_SET(x)            (((x) << CLOCK_CONTROL_UART_CLK_LSB) & CLOCK_CONTROL_UART_CLK_MASK)
+#define CLOCK_CONTROL_SI0_CLK_MSB                0
+#define CLOCK_CONTROL_SI0_CLK_LSB                0
+#define CLOCK_CONTROL_SI0_CLK_MASK               0x00000001
+#define CLOCK_CONTROL_SI0_CLK_GET(x)             (((x) & CLOCK_CONTROL_SI0_CLK_MASK) >> CLOCK_CONTROL_SI0_CLK_LSB)
+#define CLOCK_CONTROL_SI0_CLK_SET(x)             (((x) << CLOCK_CONTROL_SI0_CLK_LSB) & CLOCK_CONTROL_SI0_CLK_MASK)
+
+#define BIAS_OVERRIDE_ADDRESS                    0x0000002c
+#define BIAS_OVERRIDE_OFFSET                     0x0000002c
+#define BIAS_OVERRIDE_ON_MSB                     0
+#define BIAS_OVERRIDE_ON_LSB                     0
+#define BIAS_OVERRIDE_ON_MASK                    0x00000001
+#define BIAS_OVERRIDE_ON_GET(x)                  (((x) & BIAS_OVERRIDE_ON_MASK) >> BIAS_OVERRIDE_ON_LSB)
+#define BIAS_OVERRIDE_ON_SET(x)                  (((x) << BIAS_OVERRIDE_ON_LSB) & BIAS_OVERRIDE_ON_MASK)
+
+#define WDT_CONTROL_ADDRESS                      0x00000030
+#define WDT_CONTROL_OFFSET                       0x00000030
+#define WDT_CONTROL_ACTION_MSB                   2
+#define WDT_CONTROL_ACTION_LSB                   0
+#define WDT_CONTROL_ACTION_MASK                  0x00000007
+#define WDT_CONTROL_ACTION_GET(x)                (((x) & WDT_CONTROL_ACTION_MASK) >> WDT_CONTROL_ACTION_LSB)
+#define WDT_CONTROL_ACTION_SET(x)                (((x) << WDT_CONTROL_ACTION_LSB) & WDT_CONTROL_ACTION_MASK)
+
+#define WDT_STATUS_ADDRESS                       0x00000034
+#define WDT_STATUS_OFFSET                        0x00000034
+#define WDT_STATUS_INTERRUPT_MSB                 0
+#define WDT_STATUS_INTERRUPT_LSB                 0
+#define WDT_STATUS_INTERRUPT_MASK                0x00000001
+#define WDT_STATUS_INTERRUPT_GET(x)              (((x) & WDT_STATUS_INTERRUPT_MASK) >> WDT_STATUS_INTERRUPT_LSB)
+#define WDT_STATUS_INTERRUPT_SET(x)              (((x) << WDT_STATUS_INTERRUPT_LSB) & WDT_STATUS_INTERRUPT_MASK)
+
+#define WDT_ADDRESS                              0x00000038
+#define WDT_OFFSET                               0x00000038
+#define WDT_TARGET_MSB                           21
+#define WDT_TARGET_LSB                           0
+#define WDT_TARGET_MASK                          0x003fffff
+#define WDT_TARGET_GET(x)                        (((x) & WDT_TARGET_MASK) >> WDT_TARGET_LSB)
+#define WDT_TARGET_SET(x)                        (((x) << WDT_TARGET_LSB) & WDT_TARGET_MASK)
+
+#define WDT_COUNT_ADDRESS                        0x0000003c
+#define WDT_COUNT_OFFSET                         0x0000003c
+#define WDT_COUNT_VALUE_MSB                      21
+#define WDT_COUNT_VALUE_LSB                      0
+#define WDT_COUNT_VALUE_MASK                     0x003fffff
+#define WDT_COUNT_VALUE_GET(x)                   (((x) & WDT_COUNT_VALUE_MASK) >> WDT_COUNT_VALUE_LSB)
+#define WDT_COUNT_VALUE_SET(x)                   (((x) << WDT_COUNT_VALUE_LSB) & WDT_COUNT_VALUE_MASK)
+
+#define WDT_RESET_ADDRESS                        0x00000040
+#define WDT_RESET_OFFSET                         0x00000040
+#define WDT_RESET_VALUE_MSB                      0
+#define WDT_RESET_VALUE_LSB                      0
+#define WDT_RESET_VALUE_MASK                     0x00000001
+#define WDT_RESET_VALUE_GET(x)                   (((x) & WDT_RESET_VALUE_MASK) >> WDT_RESET_VALUE_LSB)
+#define WDT_RESET_VALUE_SET(x)                   (((x) << WDT_RESET_VALUE_LSB) & WDT_RESET_VALUE_MASK)
+
+#define INT_STATUS_ADDRESS                       0x00000044
+#define INT_STATUS_OFFSET                        0x00000044
+#define INT_STATUS_RTC_POWER_MSB                 14
+#define INT_STATUS_RTC_POWER_LSB                 14
+#define INT_STATUS_RTC_POWER_MASK                0x00004000
+#define INT_STATUS_RTC_POWER_GET(x)              (((x) & INT_STATUS_RTC_POWER_MASK) >> INT_STATUS_RTC_POWER_LSB)
+#define INT_STATUS_RTC_POWER_SET(x)              (((x) << INT_STATUS_RTC_POWER_LSB) & INT_STATUS_RTC_POWER_MASK)
+#define INT_STATUS_MAC_MSB                       13
+#define INT_STATUS_MAC_LSB                       13
+#define INT_STATUS_MAC_MASK                      0x00002000
+#define INT_STATUS_MAC_GET(x)                    (((x) & INT_STATUS_MAC_MASK) >> INT_STATUS_MAC_LSB)
+#define INT_STATUS_MAC_SET(x)                    (((x) << INT_STATUS_MAC_LSB) & INT_STATUS_MAC_MASK)
+#define INT_STATUS_MAILBOX_MSB                   12
+#define INT_STATUS_MAILBOX_LSB                   12
+#define INT_STATUS_MAILBOX_MASK                  0x00001000
+#define INT_STATUS_MAILBOX_GET(x)                (((x) & INT_STATUS_MAILBOX_MASK) >> INT_STATUS_MAILBOX_LSB)
+#define INT_STATUS_MAILBOX_SET(x)                (((x) << INT_STATUS_MAILBOX_LSB) & INT_STATUS_MAILBOX_MASK)
+#define INT_STATUS_RTC_ALARM_MSB                 11
+#define INT_STATUS_RTC_ALARM_LSB                 11
+#define INT_STATUS_RTC_ALARM_MASK                0x00000800
+#define INT_STATUS_RTC_ALARM_GET(x)              (((x) & INT_STATUS_RTC_ALARM_MASK) >> INT_STATUS_RTC_ALARM_LSB)
+#define INT_STATUS_RTC_ALARM_SET(x)              (((x) << INT_STATUS_RTC_ALARM_LSB) & INT_STATUS_RTC_ALARM_MASK)
+#define INT_STATUS_HF_TIMER_MSB                  10
+#define INT_STATUS_HF_TIMER_LSB                  10
+#define INT_STATUS_HF_TIMER_MASK                 0x00000400
+#define INT_STATUS_HF_TIMER_GET(x)               (((x) & INT_STATUS_HF_TIMER_MASK) >> INT_STATUS_HF_TIMER_LSB)
+#define INT_STATUS_HF_TIMER_SET(x)               (((x) << INT_STATUS_HF_TIMER_LSB) & INT_STATUS_HF_TIMER_MASK)
+#define INT_STATUS_LF_TIMER3_MSB                 9
+#define INT_STATUS_LF_TIMER3_LSB                 9
+#define INT_STATUS_LF_TIMER3_MASK                0x00000200
+#define INT_STATUS_LF_TIMER3_GET(x)              (((x) & INT_STATUS_LF_TIMER3_MASK) >> INT_STATUS_LF_TIMER3_LSB)
+#define INT_STATUS_LF_TIMER3_SET(x)              (((x) << INT_STATUS_LF_TIMER3_LSB) & INT_STATUS_LF_TIMER3_MASK)
+#define INT_STATUS_LF_TIMER2_MSB                 8
+#define INT_STATUS_LF_TIMER2_LSB                 8
+#define INT_STATUS_LF_TIMER2_MASK                0x00000100
+#define INT_STATUS_LF_TIMER2_GET(x)              (((x) & INT_STATUS_LF_TIMER2_MASK) >> INT_STATUS_LF_TIMER2_LSB)
+#define INT_STATUS_LF_TIMER2_SET(x)              (((x) << INT_STATUS_LF_TIMER2_LSB) & INT_STATUS_LF_TIMER2_MASK)
+#define INT_STATUS_LF_TIMER1_MSB                 7
+#define INT_STATUS_LF_TIMER1_LSB                 7
+#define INT_STATUS_LF_TIMER1_MASK                0x00000080
+#define INT_STATUS_LF_TIMER1_GET(x)              (((x) & INT_STATUS_LF_TIMER1_MASK) >> INT_STATUS_LF_TIMER1_LSB)
+#define INT_STATUS_LF_TIMER1_SET(x)              (((x) << INT_STATUS_LF_TIMER1_LSB) & INT_STATUS_LF_TIMER1_MASK)
+#define INT_STATUS_LF_TIMER0_MSB                 6
+#define INT_STATUS_LF_TIMER0_LSB                 6
+#define INT_STATUS_LF_TIMER0_MASK                0x00000040
+#define INT_STATUS_LF_TIMER0_GET(x)              (((x) & INT_STATUS_LF_TIMER0_MASK) >> INT_STATUS_LF_TIMER0_LSB)
+#define INT_STATUS_LF_TIMER0_SET(x)              (((x) << INT_STATUS_LF_TIMER0_LSB) & INT_STATUS_LF_TIMER0_MASK)
+#define INT_STATUS_KEYPAD_MSB                    5
+#define INT_STATUS_KEYPAD_LSB                    5
+#define INT_STATUS_KEYPAD_MASK                   0x00000020
+#define INT_STATUS_KEYPAD_GET(x)                 (((x) & INT_STATUS_KEYPAD_MASK) >> INT_STATUS_KEYPAD_LSB)
+#define INT_STATUS_KEYPAD_SET(x)                 (((x) << INT_STATUS_KEYPAD_LSB) & INT_STATUS_KEYPAD_MASK)
+#define INT_STATUS_SI_MSB                        4
+#define INT_STATUS_SI_LSB                        4
+#define INT_STATUS_SI_MASK                       0x00000010
+#define INT_STATUS_SI_GET(x)                     (((x) & INT_STATUS_SI_MASK) >> INT_STATUS_SI_LSB)
+#define INT_STATUS_SI_SET(x)                     (((x) << INT_STATUS_SI_LSB) & INT_STATUS_SI_MASK)
+#define INT_STATUS_GPIO_MSB                      3
+#define INT_STATUS_GPIO_LSB                      3
+#define INT_STATUS_GPIO_MASK                     0x00000008
+#define INT_STATUS_GPIO_GET(x)                   (((x) & INT_STATUS_GPIO_MASK) >> INT_STATUS_GPIO_LSB)
+#define INT_STATUS_GPIO_SET(x)                   (((x) << INT_STATUS_GPIO_LSB) & INT_STATUS_GPIO_MASK)
+#define INT_STATUS_UART_MSB                      2
+#define INT_STATUS_UART_LSB                      2
+#define INT_STATUS_UART_MASK                     0x00000004
+#define INT_STATUS_UART_GET(x)                   (((x) & INT_STATUS_UART_MASK) >> INT_STATUS_UART_LSB)
+#define INT_STATUS_UART_SET(x)                   (((x) << INT_STATUS_UART_LSB) & INT_STATUS_UART_MASK)
+#define INT_STATUS_ERROR_MSB                     1
+#define INT_STATUS_ERROR_LSB                     1
+#define INT_STATUS_ERROR_MASK                    0x00000002
+#define INT_STATUS_ERROR_GET(x)                  (((x) & INT_STATUS_ERROR_MASK) >> INT_STATUS_ERROR_LSB)
+#define INT_STATUS_ERROR_SET(x)                  (((x) << INT_STATUS_ERROR_LSB) & INT_STATUS_ERROR_MASK)
+#define INT_STATUS_WDT_INT_MSB                   0
+#define INT_STATUS_WDT_INT_LSB                   0
+#define INT_STATUS_WDT_INT_MASK                  0x00000001
+#define INT_STATUS_WDT_INT_GET(x)                (((x) & INT_STATUS_WDT_INT_MASK) >> INT_STATUS_WDT_INT_LSB)
+#define INT_STATUS_WDT_INT_SET(x)                (((x) << INT_STATUS_WDT_INT_LSB) & INT_STATUS_WDT_INT_MASK)
+
+#define LF_TIMER0_ADDRESS                        0x00000048
+#define LF_TIMER0_OFFSET                         0x00000048
+#define LF_TIMER0_TARGET_MSB                     31
+#define LF_TIMER0_TARGET_LSB                     0
+#define LF_TIMER0_TARGET_MASK                    0xffffffff
+#define LF_TIMER0_TARGET_GET(x)                  (((x) & LF_TIMER0_TARGET_MASK) >> LF_TIMER0_TARGET_LSB)
+#define LF_TIMER0_TARGET_SET(x)                  (((x) << LF_TIMER0_TARGET_LSB) & LF_TIMER0_TARGET_MASK)
+
+#define LF_TIMER_COUNT0_ADDRESS                  0x0000004c
+#define LF_TIMER_COUNT0_OFFSET                   0x0000004c
+#define LF_TIMER_COUNT0_VALUE_MSB                31
+#define LF_TIMER_COUNT0_VALUE_LSB                0
+#define LF_TIMER_COUNT0_VALUE_MASK               0xffffffff
+#define LF_TIMER_COUNT0_VALUE_GET(x)             (((x) & LF_TIMER_COUNT0_VALUE_MASK) >> LF_TIMER_COUNT0_VALUE_LSB)
+#define LF_TIMER_COUNT0_VALUE_SET(x)             (((x) << LF_TIMER_COUNT0_VALUE_LSB) & LF_TIMER_COUNT0_VALUE_MASK)
+
+#define LF_TIMER_CONTROL0_ADDRESS                0x00000050
+#define LF_TIMER_CONTROL0_OFFSET                 0x00000050
+#define LF_TIMER_CONTROL0_ENABLE_MSB             2
+#define LF_TIMER_CONTROL0_ENABLE_LSB             2
+#define LF_TIMER_CONTROL0_ENABLE_MASK            0x00000004
+#define LF_TIMER_CONTROL0_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL0_ENABLE_MASK) >> LF_TIMER_CONTROL0_ENABLE_LSB)
+#define LF_TIMER_CONTROL0_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL0_ENABLE_LSB) & LF_TIMER_CONTROL0_ENABLE_MASK)
+#define LF_TIMER_CONTROL0_AUTO_RESTART_MSB       1
+#define LF_TIMER_CONTROL0_AUTO_RESTART_LSB       1
+#define LF_TIMER_CONTROL0_AUTO_RESTART_MASK      0x00000002
+#define LF_TIMER_CONTROL0_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL0_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL0_AUTO_RESTART_LSB)
+#define LF_TIMER_CONTROL0_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL0_AUTO_RESTART_LSB) & LF_TIMER_CONTROL0_AUTO_RESTART_MASK)
+#define LF_TIMER_CONTROL0_RESET_MSB              0
+#define LF_TIMER_CONTROL0_RESET_LSB              0
+#define LF_TIMER_CONTROL0_RESET_MASK             0x00000001
+#define LF_TIMER_CONTROL0_RESET_GET(x)           (((x) & LF_TIMER_CONTROL0_RESET_MASK) >> LF_TIMER_CONTROL0_RESET_LSB)
+#define LF_TIMER_CONTROL0_RESET_SET(x)           (((x) << LF_TIMER_CONTROL0_RESET_LSB) & LF_TIMER_CONTROL0_RESET_MASK)
+
+#define LF_TIMER_STATUS0_ADDRESS                 0x00000054
+#define LF_TIMER_STATUS0_OFFSET                  0x00000054
+#define LF_TIMER_STATUS0_INTERRUPT_MSB           0
+#define LF_TIMER_STATUS0_INTERRUPT_LSB           0
+#define LF_TIMER_STATUS0_INTERRUPT_MASK          0x00000001
+#define LF_TIMER_STATUS0_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS0_INTERRUPT_MASK) >> LF_TIMER_STATUS0_INTERRUPT_LSB)
+#define LF_TIMER_STATUS0_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS0_INTERRUPT_LSB) & LF_TIMER_STATUS0_INTERRUPT_MASK)
+
+#define LF_TIMER1_ADDRESS                        0x00000058
+#define LF_TIMER1_OFFSET                         0x00000058
+#define LF_TIMER1_TARGET_MSB                     31
+#define LF_TIMER1_TARGET_LSB                     0
+#define LF_TIMER1_TARGET_MASK                    0xffffffff
+#define LF_TIMER1_TARGET_GET(x)                  (((x) & LF_TIMER1_TARGET_MASK) >> LF_TIMER1_TARGET_LSB)
+#define LF_TIMER1_TARGET_SET(x)                  (((x) << LF_TIMER1_TARGET_LSB) & LF_TIMER1_TARGET_MASK)
+
+#define LF_TIMER_COUNT1_ADDRESS                  0x0000005c
+#define LF_TIMER_COUNT1_OFFSET                   0x0000005c
+#define LF_TIMER_COUNT1_VALUE_MSB                31
+#define LF_TIMER_COUNT1_VALUE_LSB                0
+#define LF_TIMER_COUNT1_VALUE_MASK               0xffffffff
+#define LF_TIMER_COUNT1_VALUE_GET(x)             (((x) & LF_TIMER_COUNT1_VALUE_MASK) >> LF_TIMER_COUNT1_VALUE_LSB)
+#define LF_TIMER_COUNT1_VALUE_SET(x)             (((x) << LF_TIMER_COUNT1_VALUE_LSB) & LF_TIMER_COUNT1_VALUE_MASK)
+
+#define LF_TIMER_CONTROL1_ADDRESS                0x00000060
+#define LF_TIMER_CONTROL1_OFFSET                 0x00000060
+#define LF_TIMER_CONTROL1_ENABLE_MSB             2
+#define LF_TIMER_CONTROL1_ENABLE_LSB             2
+#define LF_TIMER_CONTROL1_ENABLE_MASK            0x00000004
+#define LF_TIMER_CONTROL1_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL1_ENABLE_MASK) >> LF_TIMER_CONTROL1_ENABLE_LSB)
+#define LF_TIMER_CONTROL1_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL1_ENABLE_LSB) & LF_TIMER_CONTROL1_ENABLE_MASK)
+#define LF_TIMER_CONTROL1_AUTO_RESTART_MSB       1
+#define LF_TIMER_CONTROL1_AUTO_RESTART_LSB       1
+#define LF_TIMER_CONTROL1_AUTO_RESTART_MASK      0x00000002
+#define LF_TIMER_CONTROL1_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL1_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL1_AUTO_RESTART_LSB)
+#define LF_TIMER_CONTROL1_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL1_AUTO_RESTART_LSB) & LF_TIMER_CONTROL1_AUTO_RESTART_MASK)
+#define LF_TIMER_CONTROL1_RESET_MSB              0
+#define LF_TIMER_CONTROL1_RESET_LSB              0
+#define LF_TIMER_CONTROL1_RESET_MASK             0x00000001
+#define LF_TIMER_CONTROL1_RESET_GET(x)           (((x) & LF_TIMER_CONTROL1_RESET_MASK) >> LF_TIMER_CONTROL1_RESET_LSB)
+#define LF_TIMER_CONTROL1_RESET_SET(x)           (((x) << LF_TIMER_CONTROL1_RESET_LSB) & LF_TIMER_CONTROL1_RESET_MASK)
+
+#define LF_TIMER_STATUS1_ADDRESS                 0x00000064
+#define LF_TIMER_STATUS1_OFFSET                  0x00000064
+#define LF_TIMER_STATUS1_INTERRUPT_MSB           0
+#define LF_TIMER_STATUS1_INTERRUPT_LSB           0
+#define LF_TIMER_STATUS1_INTERRUPT_MASK          0x00000001
+#define LF_TIMER_STATUS1_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS1_INTERRUPT_MASK) >> LF_TIMER_STATUS1_INTERRUPT_LSB)
+#define LF_TIMER_STATUS1_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS1_INTERRUPT_LSB) & LF_TIMER_STATUS1_INTERRUPT_MASK)
+
+#define LF_TIMER2_ADDRESS                        0x00000068
+#define LF_TIMER2_OFFSET                         0x00000068
+#define LF_TIMER2_TARGET_MSB                     31
+#define LF_TIMER2_TARGET_LSB                     0
+#define LF_TIMER2_TARGET_MASK                    0xffffffff
+#define LF_TIMER2_TARGET_GET(x)                  (((x) & LF_TIMER2_TARGET_MASK) >> LF_TIMER2_TARGET_LSB)
+#define LF_TIMER2_TARGET_SET(x)                  (((x) << LF_TIMER2_TARGET_LSB) & LF_TIMER2_TARGET_MASK)
+
+#define LF_TIMER_COUNT2_ADDRESS                  0x0000006c
+#define LF_TIMER_COUNT2_OFFSET                   0x0000006c
+#define LF_TIMER_COUNT2_VALUE_MSB                31
+#define LF_TIMER_COUNT2_VALUE_LSB                0
+#define LF_TIMER_COUNT2_VALUE_MASK               0xffffffff
+#define LF_TIMER_COUNT2_VALUE_GET(x)             (((x) & LF_TIMER_COUNT2_VALUE_MASK) >> LF_TIMER_COUNT2_VALUE_LSB)
+#define LF_TIMER_COUNT2_VALUE_SET(x)             (((x) << LF_TIMER_COUNT2_VALUE_LSB) & LF_TIMER_COUNT2_VALUE_MASK)
+
+#define LF_TIMER_CONTROL2_ADDRESS                0x00000070
+#define LF_TIMER_CONTROL2_OFFSET                 0x00000070
+#define LF_TIMER_CONTROL2_ENABLE_MSB             2
+#define LF_TIMER_CONTROL2_ENABLE_LSB             2
+#define LF_TIMER_CONTROL2_ENABLE_MASK            0x00000004
+#define LF_TIMER_CONTROL2_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL2_ENABLE_MASK) >> LF_TIMER_CONTROL2_ENABLE_LSB)
+#define LF_TIMER_CONTROL2_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL2_ENABLE_LSB) & LF_TIMER_CONTROL2_ENABLE_MASK)
+#define LF_TIMER_CONTROL2_AUTO_RESTART_MSB       1
+#define LF_TIMER_CONTROL2_AUTO_RESTART_LSB       1
+#define LF_TIMER_CONTROL2_AUTO_RESTART_MASK      0x00000002
+#define LF_TIMER_CONTROL2_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL2_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL2_AUTO_RESTART_LSB)
+#define LF_TIMER_CONTROL2_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL2_AUTO_RESTART_LSB) & LF_TIMER_CONTROL2_AUTO_RESTART_MASK)
+#define LF_TIMER_CONTROL2_RESET_MSB              0
+#define LF_TIMER_CONTROL2_RESET_LSB              0
+#define LF_TIMER_CONTROL2_RESET_MASK             0x00000001
+#define LF_TIMER_CONTROL2_RESET_GET(x)           (((x) & LF_TIMER_CONTROL2_RESET_MASK) >> LF_TIMER_CONTROL2_RESET_LSB)
+#define LF_TIMER_CONTROL2_RESET_SET(x)           (((x) << LF_TIMER_CONTROL2_RESET_LSB) & LF_TIMER_CONTROL2_RESET_MASK)
+
+#define LF_TIMER_STATUS2_ADDRESS                 0x00000074
+#define LF_TIMER_STATUS2_OFFSET                  0x00000074
+#define LF_TIMER_STATUS2_INTERRUPT_MSB           0
+#define LF_TIMER_STATUS2_INTERRUPT_LSB           0
+#define LF_TIMER_STATUS2_INTERRUPT_MASK          0x00000001
+#define LF_TIMER_STATUS2_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS2_INTERRUPT_MASK) >> LF_TIMER_STATUS2_INTERRUPT_LSB)
+#define LF_TIMER_STATUS2_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS2_INTERRUPT_LSB) & LF_TIMER_STATUS2_INTERRUPT_MASK)
+
+#define LF_TIMER3_ADDRESS                        0x00000078
+#define LF_TIMER3_OFFSET                         0x00000078
+#define LF_TIMER3_TARGET_MSB                     31
+#define LF_TIMER3_TARGET_LSB                     0
+#define LF_TIMER3_TARGET_MASK                    0xffffffff
+#define LF_TIMER3_TARGET_GET(x)                  (((x) & LF_TIMER3_TARGET_MASK) >> LF_TIMER3_TARGET_LSB)
+#define LF_TIMER3_TARGET_SET(x)                  (((x) << LF_TIMER3_TARGET_LSB) & LF_TIMER3_TARGET_MASK)
+
+#define LF_TIMER_COUNT3_ADDRESS                  0x0000007c
+#define LF_TIMER_COUNT3_OFFSET                   0x0000007c
+#define LF_TIMER_COUNT3_VALUE_MSB                31
+#define LF_TIMER_COUNT3_VALUE_LSB                0
+#define LF_TIMER_COUNT3_VALUE_MASK               0xffffffff
+#define LF_TIMER_COUNT3_VALUE_GET(x)             (((x) & LF_TIMER_COUNT3_VALUE_MASK) >> LF_TIMER_COUNT3_VALUE_LSB)
+#define LF_TIMER_COUNT3_VALUE_SET(x)             (((x) << LF_TIMER_COUNT3_VALUE_LSB) & LF_TIMER_COUNT3_VALUE_MASK)
+
+#define LF_TIMER_CONTROL3_ADDRESS                0x00000080
+#define LF_TIMER_CONTROL3_OFFSET                 0x00000080
+#define LF_TIMER_CONTROL3_ENABLE_MSB             2
+#define LF_TIMER_CONTROL3_ENABLE_LSB             2
+#define LF_TIMER_CONTROL3_ENABLE_MASK            0x00000004
+#define LF_TIMER_CONTROL3_ENABLE_GET(x)          (((x) & LF_TIMER_CONTROL3_ENABLE_MASK) >> LF_TIMER_CONTROL3_ENABLE_LSB)
+#define LF_TIMER_CONTROL3_ENABLE_SET(x)          (((x) << LF_TIMER_CONTROL3_ENABLE_LSB) & LF_TIMER_CONTROL3_ENABLE_MASK)
+#define LF_TIMER_CONTROL3_AUTO_RESTART_MSB       1
+#define LF_TIMER_CONTROL3_AUTO_RESTART_LSB       1
+#define LF_TIMER_CONTROL3_AUTO_RESTART_MASK      0x00000002
+#define LF_TIMER_CONTROL3_AUTO_RESTART_GET(x)    (((x) & LF_TIMER_CONTROL3_AUTO_RESTART_MASK) >> LF_TIMER_CONTROL3_AUTO_RESTART_LSB)
+#define LF_TIMER_CONTROL3_AUTO_RESTART_SET(x)    (((x) << LF_TIMER_CONTROL3_AUTO_RESTART_LSB) & LF_TIMER_CONTROL3_AUTO_RESTART_MASK)
+#define LF_TIMER_CONTROL3_RESET_MSB              0
+#define LF_TIMER_CONTROL3_RESET_LSB              0
+#define LF_TIMER_CONTROL3_RESET_MASK             0x00000001
+#define LF_TIMER_CONTROL3_RESET_GET(x)           (((x) & LF_TIMER_CONTROL3_RESET_MASK) >> LF_TIMER_CONTROL3_RESET_LSB)
+#define LF_TIMER_CONTROL3_RESET_SET(x)           (((x) << LF_TIMER_CONTROL3_RESET_LSB) & LF_TIMER_CONTROL3_RESET_MASK)
+
+#define LF_TIMER_STATUS3_ADDRESS                 0x00000084
+#define LF_TIMER_STATUS3_OFFSET                  0x00000084
+#define LF_TIMER_STATUS3_INTERRUPT_MSB           0
+#define LF_TIMER_STATUS3_INTERRUPT_LSB           0
+#define LF_TIMER_STATUS3_INTERRUPT_MASK          0x00000001
+#define LF_TIMER_STATUS3_INTERRUPT_GET(x)        (((x) & LF_TIMER_STATUS3_INTERRUPT_MASK) >> LF_TIMER_STATUS3_INTERRUPT_LSB)
+#define LF_TIMER_STATUS3_INTERRUPT_SET(x)        (((x) << LF_TIMER_STATUS3_INTERRUPT_LSB) & LF_TIMER_STATUS3_INTERRUPT_MASK)
+
+#define HF_TIMER_ADDRESS                         0x00000088
+#define HF_TIMER_OFFSET                          0x00000088
+#define HF_TIMER_TARGET_MSB                      31
+#define HF_TIMER_TARGET_LSB                      12
+#define HF_TIMER_TARGET_MASK                     0xfffff000
+#define HF_TIMER_TARGET_GET(x)                   (((x) & HF_TIMER_TARGET_MASK) >> HF_TIMER_TARGET_LSB)
+#define HF_TIMER_TARGET_SET(x)                   (((x) << HF_TIMER_TARGET_LSB) & HF_TIMER_TARGET_MASK)
+
+#define HF_TIMER_COUNT_ADDRESS                   0x0000008c
+#define HF_TIMER_COUNT_OFFSET                    0x0000008c
+#define HF_TIMER_COUNT_VALUE_MSB                 31
+#define HF_TIMER_COUNT_VALUE_LSB                 12
+#define HF_TIMER_COUNT_VALUE_MASK                0xfffff000
+#define HF_TIMER_COUNT_VALUE_GET(x)              (((x) & HF_TIMER_COUNT_VALUE_MASK) >> HF_TIMER_COUNT_VALUE_LSB)
+#define HF_TIMER_COUNT_VALUE_SET(x)              (((x) << HF_TIMER_COUNT_VALUE_LSB) & HF_TIMER_COUNT_VALUE_MASK)
+
+#define HF_LF_COUNT_ADDRESS                      0x00000090
+#define HF_LF_COUNT_OFFSET                       0x00000090
+#define HF_LF_COUNT_VALUE_MSB                    31
+#define HF_LF_COUNT_VALUE_LSB                    0
+#define HF_LF_COUNT_VALUE_MASK                   0xffffffff
+#define HF_LF_COUNT_VALUE_GET(x)                 (((x) & HF_LF_COUNT_VALUE_MASK) >> HF_LF_COUNT_VALUE_LSB)
+#define HF_LF_COUNT_VALUE_SET(x)                 (((x) << HF_LF_COUNT_VALUE_LSB) & HF_LF_COUNT_VALUE_MASK)
+
+#define HF_TIMER_CONTROL_ADDRESS                 0x00000094
+#define HF_TIMER_CONTROL_OFFSET                  0x00000094
+#define HF_TIMER_CONTROL_ENABLE_MSB              3
+#define HF_TIMER_CONTROL_ENABLE_LSB              3
+#define HF_TIMER_CONTROL_ENABLE_MASK             0x00000008
+#define HF_TIMER_CONTROL_ENABLE_GET(x)           (((x) & HF_TIMER_CONTROL_ENABLE_MASK) >> HF_TIMER_CONTROL_ENABLE_LSB)
+#define HF_TIMER_CONTROL_ENABLE_SET(x)           (((x) << HF_TIMER_CONTROL_ENABLE_LSB) & HF_TIMER_CONTROL_ENABLE_MASK)
+#define HF_TIMER_CONTROL_ON_MSB                  2
+#define HF_TIMER_CONTROL_ON_LSB                  2
+#define HF_TIMER_CONTROL_ON_MASK                 0x00000004
+#define HF_TIMER_CONTROL_ON_GET(x)               (((x) & HF_TIMER_CONTROL_ON_MASK) >> HF_TIMER_CONTROL_ON_LSB)
+#define HF_TIMER_CONTROL_ON_SET(x)               (((x) << HF_TIMER_CONTROL_ON_LSB) & HF_TIMER_CONTROL_ON_MASK)
+#define HF_TIMER_CONTROL_AUTO_RESTART_MSB        1
+#define HF_TIMER_CONTROL_AUTO_RESTART_LSB        1
+#define HF_TIMER_CONTROL_AUTO_RESTART_MASK       0x00000002
+#define HF_TIMER_CONTROL_AUTO_RESTART_GET(x)     (((x) & HF_TIMER_CONTROL_AUTO_RESTART_MASK) >> HF_TIMER_CONTROL_AUTO_RESTART_LSB)
+#define HF_TIMER_CONTROL_AUTO_RESTART_SET(x)     (((x) << HF_TIMER_CONTROL_AUTO_RESTART_LSB) & HF_TIMER_CONTROL_AUTO_RESTART_MASK)
+#define HF_TIMER_CONTROL_RESET_MSB               0
+#define HF_TIMER_CONTROL_RESET_LSB               0
+#define HF_TIMER_CONTROL_RESET_MASK              0x00000001
+#define HF_TIMER_CONTROL_RESET_GET(x)            (((x) & HF_TIMER_CONTROL_RESET_MASK) >> HF_TIMER_CONTROL_RESET_LSB)
+#define HF_TIMER_CONTROL_RESET_SET(x)            (((x) << HF_TIMER_CONTROL_RESET_LSB) & HF_TIMER_CONTROL_RESET_MASK)
+
+#define HF_TIMER_STATUS_ADDRESS                  0x00000098
+#define HF_TIMER_STATUS_OFFSET                   0x00000098
+#define HF_TIMER_STATUS_INTERRUPT_MSB            0
+#define HF_TIMER_STATUS_INTERRUPT_LSB            0
+#define HF_TIMER_STATUS_INTERRUPT_MASK           0x00000001
+#define HF_TIMER_STATUS_INTERRUPT_GET(x)         (((x) & HF_TIMER_STATUS_INTERRUPT_MASK) >> HF_TIMER_STATUS_INTERRUPT_LSB)
+#define HF_TIMER_STATUS_INTERRUPT_SET(x)         (((x) << HF_TIMER_STATUS_INTERRUPT_LSB) & HF_TIMER_STATUS_INTERRUPT_MASK)
+
+#define RTC_CONTROL_ADDRESS                      0x0000009c
+#define RTC_CONTROL_OFFSET                       0x0000009c
+#define RTC_CONTROL_ENABLE_MSB                   2
+#define RTC_CONTROL_ENABLE_LSB                   2
+#define RTC_CONTROL_ENABLE_MASK                  0x00000004
+#define RTC_CONTROL_ENABLE_GET(x)                (((x) & RTC_CONTROL_ENABLE_MASK) >> RTC_CONTROL_ENABLE_LSB)
+#define RTC_CONTROL_ENABLE_SET(x)                (((x) << RTC_CONTROL_ENABLE_LSB) & RTC_CONTROL_ENABLE_MASK)
+#define RTC_CONTROL_LOAD_RTC_MSB                 1
+#define RTC_CONTROL_LOAD_RTC_LSB                 1
+#define RTC_CONTROL_LOAD_RTC_MASK                0x00000002
+#define RTC_CONTROL_LOAD_RTC_GET(x)              (((x) & RTC_CONTROL_LOAD_RTC_MASK) >> RTC_CONTROL_LOAD_RTC_LSB)
+#define RTC_CONTROL_LOAD_RTC_SET(x)              (((x) << RTC_CONTROL_LOAD_RTC_LSB) & RTC_CONTROL_LOAD_RTC_MASK)
+#define RTC_CONTROL_LOAD_ALARM_MSB               0
+#define RTC_CONTROL_LOAD_ALARM_LSB               0
+#define RTC_CONTROL_LOAD_ALARM_MASK              0x00000001
+#define RTC_CONTROL_LOAD_ALARM_GET(x)            (((x) & RTC_CONTROL_LOAD_ALARM_MASK) >> RTC_CONTROL_LOAD_ALARM_LSB)
+#define RTC_CONTROL_LOAD_ALARM_SET(x)            (((x) << RTC_CONTROL_LOAD_ALARM_LSB) & RTC_CONTROL_LOAD_ALARM_MASK)
+
+#define RTC_TIME_ADDRESS                         0x000000a0
+#define RTC_TIME_OFFSET                          0x000000a0
+#define RTC_TIME_WEEK_DAY_MSB                    26
+#define RTC_TIME_WEEK_DAY_LSB                    24
+#define RTC_TIME_WEEK_DAY_MASK                   0x07000000
+#define RTC_TIME_WEEK_DAY_GET(x)                 (((x) & RTC_TIME_WEEK_DAY_MASK) >> RTC_TIME_WEEK_DAY_LSB)
+#define RTC_TIME_WEEK_DAY_SET(x)                 (((x) << RTC_TIME_WEEK_DAY_LSB) & RTC_TIME_WEEK_DAY_MASK)
+#define RTC_TIME_HOUR_MSB                        21
+#define RTC_TIME_HOUR_LSB                        16
+#define RTC_TIME_HOUR_MASK                       0x003f0000
+#define RTC_TIME_HOUR_GET(x)                     (((x) & RTC_TIME_HOUR_MASK) >> RTC_TIME_HOUR_LSB)
+#define RTC_TIME_HOUR_SET(x)                     (((x) << RTC_TIME_HOUR_LSB) & RTC_TIME_HOUR_MASK)
+#define RTC_TIME_MINUTE_MSB                      14
+#define RTC_TIME_MINUTE_LSB                      8
+#define RTC_TIME_MINUTE_MASK                     0x00007f00
+#define RTC_TIME_MINUTE_GET(x)                   (((x) & RTC_TIME_MINUTE_MASK) >> RTC_TIME_MINUTE_LSB)
+#define RTC_TIME_MINUTE_SET(x)                   (((x) << RTC_TIME_MINUTE_LSB) & RTC_TIME_MINUTE_MASK)
+#define RTC_TIME_SECOND_MSB                      6
+#define RTC_TIME_SECOND_LSB                      0
+#define RTC_TIME_SECOND_MASK                     0x0000007f
+#define RTC_TIME_SECOND_GET(x)                   (((x) & RTC_TIME_SECOND_MASK) >> RTC_TIME_SECOND_LSB)
+#define RTC_TIME_SECOND_SET(x)                   (((x) << RTC_TIME_SECOND_LSB) & RTC_TIME_SECOND_MASK)
+
+#define RTC_DATE_ADDRESS                         0x000000a4
+#define RTC_DATE_OFFSET                          0x000000a4
+#define RTC_DATE_YEAR_MSB                        23
+#define RTC_DATE_YEAR_LSB                        16
+#define RTC_DATE_YEAR_MASK                       0x00ff0000
+#define RTC_DATE_YEAR_GET(x)                     (((x) & RTC_DATE_YEAR_MASK) >> RTC_DATE_YEAR_LSB)
+#define RTC_DATE_YEAR_SET(x)                     (((x) << RTC_DATE_YEAR_LSB) & RTC_DATE_YEAR_MASK)
+#define RTC_DATE_MONTH_MSB                       12
+#define RTC_DATE_MONTH_LSB                       8
+#define RTC_DATE_MONTH_MASK                      0x00001f00
+#define RTC_DATE_MONTH_GET(x)                    (((x) & RTC_DATE_MONTH_MASK) >> RTC_DATE_MONTH_LSB)
+#define RTC_DATE_MONTH_SET(x)                    (((x) << RTC_DATE_MONTH_LSB) & RTC_DATE_MONTH_MASK)
+#define RTC_DATE_MONTH_DAY_MSB                   5
+#define RTC_DATE_MONTH_DAY_LSB                   0
+#define RTC_DATE_MONTH_DAY_MASK                  0x0000003f
+#define RTC_DATE_MONTH_DAY_GET(x)                (((x) & RTC_DATE_MONTH_DAY_MASK) >> RTC_DATE_MONTH_DAY_LSB)
+#define RTC_DATE_MONTH_DAY_SET(x)                (((x) << RTC_DATE_MONTH_DAY_LSB) & RTC_DATE_MONTH_DAY_MASK)
+
+#define RTC_SET_TIME_ADDRESS                     0x000000a8
+#define RTC_SET_TIME_OFFSET                      0x000000a8
+#define RTC_SET_TIME_WEEK_DAY_MSB                26
+#define RTC_SET_TIME_WEEK_DAY_LSB                24
+#define RTC_SET_TIME_WEEK_DAY_MASK               0x07000000
+#define RTC_SET_TIME_WEEK_DAY_GET(x)             (((x) & RTC_SET_TIME_WEEK_DAY_MASK) >> RTC_SET_TIME_WEEK_DAY_LSB)
+#define RTC_SET_TIME_WEEK_DAY_SET(x)             (((x) << RTC_SET_TIME_WEEK_DAY_LSB) & RTC_SET_TIME_WEEK_DAY_MASK)
+#define RTC_SET_TIME_HOUR_MSB                    21
+#define RTC_SET_TIME_HOUR_LSB                    16
+#define RTC_SET_TIME_HOUR_MASK                   0x003f0000
+#define RTC_SET_TIME_HOUR_GET(x)                 (((x) & RTC_SET_TIME_HOUR_MASK) >> RTC_SET_TIME_HOUR_LSB)
+#define RTC_SET_TIME_HOUR_SET(x)                 (((x) << RTC_SET_TIME_HOUR_LSB) & RTC_SET_TIME_HOUR_MASK)
+#define RTC_SET_TIME_MINUTE_MSB                  14
+#define RTC_SET_TIME_MINUTE_LSB                  8
+#define RTC_SET_TIME_MINUTE_MASK                 0x00007f00
+#define RTC_SET_TIME_MINUTE_GET(x)               (((x) & RTC_SET_TIME_MINUTE_MASK) >> RTC_SET_TIME_MINUTE_LSB)
+#define RTC_SET_TIME_MINUTE_SET(x)               (((x) << RTC_SET_TIME_MINUTE_LSB) & RTC_SET_TIME_MINUTE_MASK)
+#define RTC_SET_TIME_SECOND_MSB                  6
+#define RTC_SET_TIME_SECOND_LSB                  0
+#define RTC_SET_TIME_SECOND_MASK                 0x0000007f
+#define RTC_SET_TIME_SECOND_GET(x)               (((x) & RTC_SET_TIME_SECOND_MASK) >> RTC_SET_TIME_SECOND_LSB)
+#define RTC_SET_TIME_SECOND_SET(x)               (((x) << RTC_SET_TIME_SECOND_LSB) & RTC_SET_TIME_SECOND_MASK)
+
+#define RTC_SET_DATE_ADDRESS                     0x000000ac
+#define RTC_SET_DATE_OFFSET                      0x000000ac
+#define RTC_SET_DATE_YEAR_MSB                    23
+#define RTC_SET_DATE_YEAR_LSB                    16
+#define RTC_SET_DATE_YEAR_MASK                   0x00ff0000
+#define RTC_SET_DATE_YEAR_GET(x)                 (((x) & RTC_SET_DATE_YEAR_MASK) >> RTC_SET_DATE_YEAR_LSB)
+#define RTC_SET_DATE_YEAR_SET(x)                 (((x) << RTC_SET_DATE_YEAR_LSB) & RTC_SET_DATE_YEAR_MASK)
+#define RTC_SET_DATE_MONTH_MSB                   12
+#define RTC_SET_DATE_MONTH_LSB                   8
+#define RTC_SET_DATE_MONTH_MASK                  0x00001f00
+#define RTC_SET_DATE_MONTH_GET(x)                (((x) & RTC_SET_DATE_MONTH_MASK) >> RTC_SET_DATE_MONTH_LSB)
+#define RTC_SET_DATE_MONTH_SET(x)                (((x) << RTC_SET_DATE_MONTH_LSB) & RTC_SET_DATE_MONTH_MASK)
+#define RTC_SET_DATE_MONTH_DAY_MSB               5
+#define RTC_SET_DATE_MONTH_DAY_LSB               0
+#define RTC_SET_DATE_MONTH_DAY_MASK              0x0000003f
+#define RTC_SET_DATE_MONTH_DAY_GET(x)            (((x) & RTC_SET_DATE_MONTH_DAY_MASK) >> RTC_SET_DATE_MONTH_DAY_LSB)
+#define RTC_SET_DATE_MONTH_DAY_SET(x)            (((x) << RTC_SET_DATE_MONTH_DAY_LSB) & RTC_SET_DATE_MONTH_DAY_MASK)
+
+#define RTC_SET_ALARM_ADDRESS                    0x000000b0
+#define RTC_SET_ALARM_OFFSET                     0x000000b0
+#define RTC_SET_ALARM_HOUR_MSB                   21
+#define RTC_SET_ALARM_HOUR_LSB                   16
+#define RTC_SET_ALARM_HOUR_MASK                  0x003f0000
+#define RTC_SET_ALARM_HOUR_GET(x)                (((x) & RTC_SET_ALARM_HOUR_MASK) >> RTC_SET_ALARM_HOUR_LSB)
+#define RTC_SET_ALARM_HOUR_SET(x)                (((x) << RTC_SET_ALARM_HOUR_LSB) & RTC_SET_ALARM_HOUR_MASK)
+#define RTC_SET_ALARM_MINUTE_MSB                 14
+#define RTC_SET_ALARM_MINUTE_LSB                 8
+#define RTC_SET_ALARM_MINUTE_MASK                0x00007f00
+#define RTC_SET_ALARM_MINUTE_GET(x)              (((x) & RTC_SET_ALARM_MINUTE_MASK) >> RTC_SET_ALARM_MINUTE_LSB)
+#define RTC_SET_ALARM_MINUTE_SET(x)              (((x) << RTC_SET_ALARM_MINUTE_LSB) & RTC_SET_ALARM_MINUTE_MASK)
+#define RTC_SET_ALARM_SECOND_MSB                 6
+#define RTC_SET_ALARM_SECOND_LSB                 0
+#define RTC_SET_ALARM_SECOND_MASK                0x0000007f
+#define RTC_SET_ALARM_SECOND_GET(x)              (((x) & RTC_SET_ALARM_SECOND_MASK) >> RTC_SET_ALARM_SECOND_LSB)
+#define RTC_SET_ALARM_SECOND_SET(x)              (((x) << RTC_SET_ALARM_SECOND_LSB) & RTC_SET_ALARM_SECOND_MASK)
+
+#define RTC_CONFIG_ADDRESS                       0x000000b4
+#define RTC_CONFIG_OFFSET                        0x000000b4
+#define RTC_CONFIG_BCD_MSB                       2
+#define RTC_CONFIG_BCD_LSB                       2
+#define RTC_CONFIG_BCD_MASK                      0x00000004
+#define RTC_CONFIG_BCD_GET(x)                    (((x) & RTC_CONFIG_BCD_MASK) >> RTC_CONFIG_BCD_LSB)
+#define RTC_CONFIG_BCD_SET(x)                    (((x) << RTC_CONFIG_BCD_LSB) & RTC_CONFIG_BCD_MASK)
+#define RTC_CONFIG_TWELVE_HOUR_MSB               1
+#define RTC_CONFIG_TWELVE_HOUR_LSB               1
+#define RTC_CONFIG_TWELVE_HOUR_MASK              0x00000002
+#define RTC_CONFIG_TWELVE_HOUR_GET(x)            (((x) & RTC_CONFIG_TWELVE_HOUR_MASK) >> RTC_CONFIG_TWELVE_HOUR_LSB)
+#define RTC_CONFIG_TWELVE_HOUR_SET(x)            (((x) << RTC_CONFIG_TWELVE_HOUR_LSB) & RTC_CONFIG_TWELVE_HOUR_MASK)
+#define RTC_CONFIG_DSE_MSB                       0
+#define RTC_CONFIG_DSE_LSB                       0
+#define RTC_CONFIG_DSE_MASK                      0x00000001
+#define RTC_CONFIG_DSE_GET(x)                    (((x) & RTC_CONFIG_DSE_MASK) >> RTC_CONFIG_DSE_LSB)
+#define RTC_CONFIG_DSE_SET(x)                    (((x) << RTC_CONFIG_DSE_LSB) & RTC_CONFIG_DSE_MASK)
+
+#define RTC_ALARM_STATUS_ADDRESS                 0x000000b8
+#define RTC_ALARM_STATUS_OFFSET                  0x000000b8
+#define RTC_ALARM_STATUS_ENABLE_MSB              1
+#define RTC_ALARM_STATUS_ENABLE_LSB              1
+#define RTC_ALARM_STATUS_ENABLE_MASK             0x00000002
+#define RTC_ALARM_STATUS_ENABLE_GET(x)           (((x) & RTC_ALARM_STATUS_ENABLE_MASK) >> RTC_ALARM_STATUS_ENABLE_LSB)
+#define RTC_ALARM_STATUS_ENABLE_SET(x)           (((x) << RTC_ALARM_STATUS_ENABLE_LSB) & RTC_ALARM_STATUS_ENABLE_MASK)
+#define RTC_ALARM_STATUS_INTERRUPT_MSB           0
+#define RTC_ALARM_STATUS_INTERRUPT_LSB           0
+#define RTC_ALARM_STATUS_INTERRUPT_MASK          0x00000001
+#define RTC_ALARM_STATUS_INTERRUPT_GET(x)        (((x) & RTC_ALARM_STATUS_INTERRUPT_MASK) >> RTC_ALARM_STATUS_INTERRUPT_LSB)
+#define RTC_ALARM_STATUS_INTERRUPT_SET(x)        (((x) << RTC_ALARM_STATUS_INTERRUPT_LSB) & RTC_ALARM_STATUS_INTERRUPT_MASK)
+
+#define UART_WAKEUP_ADDRESS                      0x000000bc
+#define UART_WAKEUP_OFFSET                       0x000000bc
+#define UART_WAKEUP_ENABLE_MSB                   0
+#define UART_WAKEUP_ENABLE_LSB                   0
+#define UART_WAKEUP_ENABLE_MASK                  0x00000001
+#define UART_WAKEUP_ENABLE_GET(x)                (((x) & UART_WAKEUP_ENABLE_MASK) >> UART_WAKEUP_ENABLE_LSB)
+#define UART_WAKEUP_ENABLE_SET(x)                (((x) << UART_WAKEUP_ENABLE_LSB) & UART_WAKEUP_ENABLE_MASK)
+
+#define RESET_CAUSE_ADDRESS                      0x000000c0
+#define RESET_CAUSE_OFFSET                       0x000000c0
+#define RESET_CAUSE_LAST_MSB                     2
+#define RESET_CAUSE_LAST_LSB                     0
+#define RESET_CAUSE_LAST_MASK                    0x00000007
+#define RESET_CAUSE_LAST_GET(x)                  (((x) & RESET_CAUSE_LAST_MASK) >> RESET_CAUSE_LAST_LSB)
+#define RESET_CAUSE_LAST_SET(x)                  (((x) << RESET_CAUSE_LAST_LSB) & RESET_CAUSE_LAST_MASK)
+
+#define SYSTEM_SLEEP_ADDRESS                     0x000000c4
+#define SYSTEM_SLEEP_OFFSET                      0x000000c4
+#define SYSTEM_SLEEP_HOST_IF_MSB                 4
+#define SYSTEM_SLEEP_HOST_IF_LSB                 4
+#define SYSTEM_SLEEP_HOST_IF_MASK                0x00000010
+#define SYSTEM_SLEEP_HOST_IF_GET(x)              (((x) & SYSTEM_SLEEP_HOST_IF_MASK) >> SYSTEM_SLEEP_HOST_IF_LSB)
+#define SYSTEM_SLEEP_HOST_IF_SET(x)              (((x) << SYSTEM_SLEEP_HOST_IF_LSB) & SYSTEM_SLEEP_HOST_IF_MASK)
+#define SYSTEM_SLEEP_MBOX_MSB                    3
+#define SYSTEM_SLEEP_MBOX_LSB                    3
+#define SYSTEM_SLEEP_MBOX_MASK                   0x00000008
+#define SYSTEM_SLEEP_MBOX_GET(x)                 (((x) & SYSTEM_SLEEP_MBOX_MASK) >> SYSTEM_SLEEP_MBOX_LSB)
+#define SYSTEM_SLEEP_MBOX_SET(x)                 (((x) << SYSTEM_SLEEP_MBOX_LSB) & SYSTEM_SLEEP_MBOX_MASK)
+#define SYSTEM_SLEEP_MAC_IF_MSB                  2
+#define SYSTEM_SLEEP_MAC_IF_LSB                  2
+#define SYSTEM_SLEEP_MAC_IF_MASK                 0x00000004
+#define SYSTEM_SLEEP_MAC_IF_GET(x)               (((x) & SYSTEM_SLEEP_MAC_IF_MASK) >> SYSTEM_SLEEP_MAC_IF_LSB)
+#define SYSTEM_SLEEP_MAC_IF_SET(x)               (((x) << SYSTEM_SLEEP_MAC_IF_LSB) & SYSTEM_SLEEP_MAC_IF_MASK)
+#define SYSTEM_SLEEP_LIGHT_MSB                   1
+#define SYSTEM_SLEEP_LIGHT_LSB                   1
+#define SYSTEM_SLEEP_LIGHT_MASK                  0x00000002
+#define SYSTEM_SLEEP_LIGHT_GET(x)                (((x) & SYSTEM_SLEEP_LIGHT_MASK) >> SYSTEM_SLEEP_LIGHT_LSB)
+#define SYSTEM_SLEEP_LIGHT_SET(x)                (((x) << SYSTEM_SLEEP_LIGHT_LSB) & SYSTEM_SLEEP_LIGHT_MASK)
+#define SYSTEM_SLEEP_DISABLE_MSB                 0
+#define SYSTEM_SLEEP_DISABLE_LSB                 0
+#define SYSTEM_SLEEP_DISABLE_MASK                0x00000001
+#define SYSTEM_SLEEP_DISABLE_GET(x)              (((x) & SYSTEM_SLEEP_DISABLE_MASK) >> SYSTEM_SLEEP_DISABLE_LSB)
+#define SYSTEM_SLEEP_DISABLE_SET(x)              (((x) << SYSTEM_SLEEP_DISABLE_LSB) & SYSTEM_SLEEP_DISABLE_MASK)
+
+#define SDIO_WRAPPER_ADDRESS                     0x000000c8
+#define SDIO_WRAPPER_OFFSET                      0x000000c8
+#define SDIO_WRAPPER_SLEEP_MSB                   3
+#define SDIO_WRAPPER_SLEEP_LSB                   3
+#define SDIO_WRAPPER_SLEEP_MASK                  0x00000008
+#define SDIO_WRAPPER_SLEEP_GET(x)                (((x) & SDIO_WRAPPER_SLEEP_MASK) >> SDIO_WRAPPER_SLEEP_LSB)
+#define SDIO_WRAPPER_SLEEP_SET(x)                (((x) << SDIO_WRAPPER_SLEEP_LSB) & SDIO_WRAPPER_SLEEP_MASK)
+#define SDIO_WRAPPER_WAKEUP_MSB                  2
+#define SDIO_WRAPPER_WAKEUP_LSB                  2
+#define SDIO_WRAPPER_WAKEUP_MASK                 0x00000004
+#define SDIO_WRAPPER_WAKEUP_GET(x)               (((x) & SDIO_WRAPPER_WAKEUP_MASK) >> SDIO_WRAPPER_WAKEUP_LSB)
+#define SDIO_WRAPPER_WAKEUP_SET(x)               (((x) << SDIO_WRAPPER_WAKEUP_LSB) & SDIO_WRAPPER_WAKEUP_MASK)
+#define SDIO_WRAPPER_SOC_ON_MSB                  1
+#define SDIO_WRAPPER_SOC_ON_LSB                  1
+#define SDIO_WRAPPER_SOC_ON_MASK                 0x00000002
+#define SDIO_WRAPPER_SOC_ON_GET(x)               (((x) & SDIO_WRAPPER_SOC_ON_MASK) >> SDIO_WRAPPER_SOC_ON_LSB)
+#define SDIO_WRAPPER_SOC_ON_SET(x)               (((x) << SDIO_WRAPPER_SOC_ON_LSB) & SDIO_WRAPPER_SOC_ON_MASK)
+#define SDIO_WRAPPER_ON_MSB                      0
+#define SDIO_WRAPPER_ON_LSB                      0
+#define SDIO_WRAPPER_ON_MASK                     0x00000001
+#define SDIO_WRAPPER_ON_GET(x)                   (((x) & SDIO_WRAPPER_ON_MASK) >> SDIO_WRAPPER_ON_LSB)
+#define SDIO_WRAPPER_ON_SET(x)                   (((x) << SDIO_WRAPPER_ON_LSB) & SDIO_WRAPPER_ON_MASK)
+
+#define MAC_SLEEP_CONTROL_ADDRESS                0x000000cc
+#define MAC_SLEEP_CONTROL_OFFSET                 0x000000cc
+#define MAC_SLEEP_CONTROL_ENABLE_MSB             1
+#define MAC_SLEEP_CONTROL_ENABLE_LSB             0
+#define MAC_SLEEP_CONTROL_ENABLE_MASK            0x00000003
+#define MAC_SLEEP_CONTROL_ENABLE_GET(x)          (((x) & MAC_SLEEP_CONTROL_ENABLE_MASK) >> MAC_SLEEP_CONTROL_ENABLE_LSB)
+#define MAC_SLEEP_CONTROL_ENABLE_SET(x)          (((x) << MAC_SLEEP_CONTROL_ENABLE_LSB) & MAC_SLEEP_CONTROL_ENABLE_MASK)
+
+#define KEEP_AWAKE_ADDRESS                       0x000000d0
+#define KEEP_AWAKE_OFFSET                        0x000000d0
+#define KEEP_AWAKE_COUNT_MSB                     7
+#define KEEP_AWAKE_COUNT_LSB                     0
+#define KEEP_AWAKE_COUNT_MASK                    0x000000ff
+#define KEEP_AWAKE_COUNT_GET(x)                  (((x) & KEEP_AWAKE_COUNT_MASK) >> KEEP_AWAKE_COUNT_LSB)
+#define KEEP_AWAKE_COUNT_SET(x)                  (((x) << KEEP_AWAKE_COUNT_LSB) & KEEP_AWAKE_COUNT_MASK)
+
+#define LPO_CAL_TIME_ADDRESS                     0x000000d4
+#define LPO_CAL_TIME_OFFSET                      0x000000d4
+#define LPO_CAL_TIME_LENGTH_MSB                  13
+#define LPO_CAL_TIME_LENGTH_LSB                  0
+#define LPO_CAL_TIME_LENGTH_MASK                 0x00003fff
+#define LPO_CAL_TIME_LENGTH_GET(x)               (((x) & LPO_CAL_TIME_LENGTH_MASK) >> LPO_CAL_TIME_LENGTH_LSB)
+#define LPO_CAL_TIME_LENGTH_SET(x)               (((x) << LPO_CAL_TIME_LENGTH_LSB) & LPO_CAL_TIME_LENGTH_MASK)
+
+#define LPO_INIT_DIVIDEND_INT_ADDRESS            0x000000d8
+#define LPO_INIT_DIVIDEND_INT_OFFSET             0x000000d8
+#define LPO_INIT_DIVIDEND_INT_VALUE_MSB          23
+#define LPO_INIT_DIVIDEND_INT_VALUE_LSB          0
+#define LPO_INIT_DIVIDEND_INT_VALUE_MASK         0x00ffffff
+#define LPO_INIT_DIVIDEND_INT_VALUE_GET(x)       (((x) & LPO_INIT_DIVIDEND_INT_VALUE_MASK) >> LPO_INIT_DIVIDEND_INT_VALUE_LSB)
+#define LPO_INIT_DIVIDEND_INT_VALUE_SET(x)       (((x) << LPO_INIT_DIVIDEND_INT_VALUE_LSB) & LPO_INIT_DIVIDEND_INT_VALUE_MASK)
+
+#define LPO_INIT_DIVIDEND_FRACTION_ADDRESS       0x000000dc
+#define LPO_INIT_DIVIDEND_FRACTION_OFFSET        0x000000dc
+#define LPO_INIT_DIVIDEND_FRACTION_VALUE_MSB     10
+#define LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB     0
+#define LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK    0x000007ff
+#define LPO_INIT_DIVIDEND_FRACTION_VALUE_GET(x)  (((x) & LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK) >> LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB)
+#define LPO_INIT_DIVIDEND_FRACTION_VALUE_SET(x)  (((x) << LPO_INIT_DIVIDEND_FRACTION_VALUE_LSB) & LPO_INIT_DIVIDEND_FRACTION_VALUE_MASK)
+
+#define LPO_CAL_ADDRESS                          0x000000e0
+#define LPO_CAL_OFFSET                           0x000000e0
+#define LPO_CAL_ENABLE_MSB                       20
+#define LPO_CAL_ENABLE_LSB                       20
+#define LPO_CAL_ENABLE_MASK                      0x00100000
+#define LPO_CAL_ENABLE_GET(x)                    (((x) & LPO_CAL_ENABLE_MASK) >> LPO_CAL_ENABLE_LSB)
+#define LPO_CAL_ENABLE_SET(x)                    (((x) << LPO_CAL_ENABLE_LSB) & LPO_CAL_ENABLE_MASK)
+#define LPO_CAL_COUNT_MSB                        19
+#define LPO_CAL_COUNT_LSB                        0
+#define LPO_CAL_COUNT_MASK                       0x000fffff
+#define LPO_CAL_COUNT_GET(x)                     (((x) & LPO_CAL_COUNT_MASK) >> LPO_CAL_COUNT_LSB)
+#define LPO_CAL_COUNT_SET(x)                     (((x) << LPO_CAL_COUNT_LSB) & LPO_CAL_COUNT_MASK)
+
+#define LPO_CAL_TEST_CONTROL_ADDRESS             0x000000e4
+#define LPO_CAL_TEST_CONTROL_OFFSET              0x000000e4
+#define LPO_CAL_TEST_CONTROL_ENABLE_MSB          5
+#define LPO_CAL_TEST_CONTROL_ENABLE_LSB          5
+#define LPO_CAL_TEST_CONTROL_ENABLE_MASK         0x00000020
+#define LPO_CAL_TEST_CONTROL_ENABLE_GET(x)       (((x) & LPO_CAL_TEST_CONTROL_ENABLE_MASK) >> LPO_CAL_TEST_CONTROL_ENABLE_LSB)
+#define LPO_CAL_TEST_CONTROL_ENABLE_SET(x)       (((x) << LPO_CAL_TEST_CONTROL_ENABLE_LSB) & LPO_CAL_TEST_CONTROL_ENABLE_MASK)
+#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_MSB      4
+#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB      0
+#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK     0x0000001f
+#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_GET(x)   (((x) & LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK) >> LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB)
+#define LPO_CAL_TEST_CONTROL_RTC_CYCLES_SET(x)   (((x) << LPO_CAL_TEST_CONTROL_RTC_CYCLES_LSB) & LPO_CAL_TEST_CONTROL_RTC_CYCLES_MASK)
+
+#define LPO_CAL_TEST_STATUS_ADDRESS              0x000000e8
+#define LPO_CAL_TEST_STATUS_OFFSET               0x000000e8
+#define LPO_CAL_TEST_STATUS_READY_MSB            16
+#define LPO_CAL_TEST_STATUS_READY_LSB            16
+#define LPO_CAL_TEST_STATUS_READY_MASK           0x00010000
+#define LPO_CAL_TEST_STATUS_READY_GET(x)         (((x) & LPO_CAL_TEST_STATUS_READY_MASK) >> LPO_CAL_TEST_STATUS_READY_LSB)
+#define LPO_CAL_TEST_STATUS_READY_SET(x)         (((x) << LPO_CAL_TEST_STATUS_READY_LSB) & LPO_CAL_TEST_STATUS_READY_MASK)
+#define LPO_CAL_TEST_STATUS_COUNT_MSB            15
+#define LPO_CAL_TEST_STATUS_COUNT_LSB            0
+#define LPO_CAL_TEST_STATUS_COUNT_MASK           0x0000ffff
+#define LPO_CAL_TEST_STATUS_COUNT_GET(x)         (((x) & LPO_CAL_TEST_STATUS_COUNT_MASK) >> LPO_CAL_TEST_STATUS_COUNT_LSB)
+#define LPO_CAL_TEST_STATUS_COUNT_SET(x)         (((x) << LPO_CAL_TEST_STATUS_COUNT_LSB) & LPO_CAL_TEST_STATUS_COUNT_MASK)
+
+#define CHIP_ID_ADDRESS                          0x000000ec
+#define CHIP_ID_OFFSET                           0x000000ec
+#define CHIP_ID_DEVICE_ID_MSB                    31
+#define CHIP_ID_DEVICE_ID_LSB                    16
+#define CHIP_ID_DEVICE_ID_MASK                   0xffff0000
+#define CHIP_ID_DEVICE_ID_GET(x)                 (((x) & CHIP_ID_DEVICE_ID_MASK) >> CHIP_ID_DEVICE_ID_LSB)
+#define CHIP_ID_DEVICE_ID_SET(x)                 (((x) << CHIP_ID_DEVICE_ID_LSB) & CHIP_ID_DEVICE_ID_MASK)
+#define CHIP_ID_CONFIG_ID_MSB                    15
+#define CHIP_ID_CONFIG_ID_LSB                    4
+#define CHIP_ID_CONFIG_ID_MASK                   0x0000fff0
+#define CHIP_ID_CONFIG_ID_GET(x)                 (((x) & CHIP_ID_CONFIG_ID_MASK) >> CHIP_ID_CONFIG_ID_LSB)
+#define CHIP_ID_CONFIG_ID_SET(x)                 (((x) << CHIP_ID_CONFIG_ID_LSB) & CHIP_ID_CONFIG_ID_MASK)
+#define CHIP_ID_VERSION_ID_MSB                   3
+#define CHIP_ID_VERSION_ID_LSB                   0
+#define CHIP_ID_VERSION_ID_MASK                  0x0000000f
+#define CHIP_ID_VERSION_ID_GET(x)                (((x) & CHIP_ID_VERSION_ID_MASK) >> CHIP_ID_VERSION_ID_LSB)
+#define CHIP_ID_VERSION_ID_SET(x)                (((x) << CHIP_ID_VERSION_ID_LSB) & CHIP_ID_VERSION_ID_MASK)
+
+#define DERIVED_RTC_CLK_ADDRESS                  0x000000f0
+#define DERIVED_RTC_CLK_OFFSET                   0x000000f0
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MSB   20
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB   20
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK  0x00100000
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_GET(x) (((x) & DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK) >> DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB)
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_SET(x) (((x) << DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_LSB) & DERIVED_RTC_CLK_EXTERNAL_DETECT_EN_MASK)
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_MSB      18
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB      18
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK     0x00040000
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_GET(x)   (((x) & DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK) >> DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB)
+#define DERIVED_RTC_CLK_EXTERNAL_DETECT_SET(x)   (((x) << DERIVED_RTC_CLK_EXTERNAL_DETECT_LSB) & DERIVED_RTC_CLK_EXTERNAL_DETECT_MASK)
+#define DERIVED_RTC_CLK_FORCE_MSB                17
+#define DERIVED_RTC_CLK_FORCE_LSB                16
+#define DERIVED_RTC_CLK_FORCE_MASK               0x00030000
+#define DERIVED_RTC_CLK_FORCE_GET(x)             (((x) & DERIVED_RTC_CLK_FORCE_MASK) >> DERIVED_RTC_CLK_FORCE_LSB)
+#define DERIVED_RTC_CLK_FORCE_SET(x)             (((x) << DERIVED_RTC_CLK_FORCE_LSB) & DERIVED_RTC_CLK_FORCE_MASK)
+#define DERIVED_RTC_CLK_PERIOD_MSB               15
+#define DERIVED_RTC_CLK_PERIOD_LSB               1
+#define DERIVED_RTC_CLK_PERIOD_MASK              0x0000fffe
+#define DERIVED_RTC_CLK_PERIOD_GET(x)            (((x) & DERIVED_RTC_CLK_PERIOD_MASK) >> DERIVED_RTC_CLK_PERIOD_LSB)
+#define DERIVED_RTC_CLK_PERIOD_SET(x)            (((x) << DERIVED_RTC_CLK_PERIOD_LSB) & DERIVED_RTC_CLK_PERIOD_MASK)
+
+#define MAC_PCU_SLP32_MODE_ADDRESS               0x000000f4
+#define MAC_PCU_SLP32_MODE_OFFSET                0x000000f4
+#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MSB 21
+#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB 21
+#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK 0x00200000
+#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_GET(x) (((x) & MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK) >> MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB)
+#define MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_SET(x) (((x) << MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_LSB) & MAC_PCU_SLP32_MODE_TSF_WRITE_PENDING_MASK)
+#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MSB  19
+#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB  0
+#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK 0x000fffff
+#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_GET(x) (((x) & MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK) >> MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB)
+#define MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_SET(x) (((x) << MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_LSB) & MAC_PCU_SLP32_MODE_HALF_CLK_LATENCY_MASK)
+
+#define MAC_PCU_SLP32_WAKE_ADDRESS               0x000000f8
+#define MAC_PCU_SLP32_WAKE_OFFSET                0x000000f8
+#define MAC_PCU_SLP32_WAKE_XTL_TIME_MSB          15
+#define MAC_PCU_SLP32_WAKE_XTL_TIME_LSB          0
+#define MAC_PCU_SLP32_WAKE_XTL_TIME_MASK         0x0000ffff
+#define MAC_PCU_SLP32_WAKE_XTL_TIME_GET(x)       (((x) & MAC_PCU_SLP32_WAKE_XTL_TIME_MASK) >> MAC_PCU_SLP32_WAKE_XTL_TIME_LSB)
+#define MAC_PCU_SLP32_WAKE_XTL_TIME_SET(x)       (((x) << MAC_PCU_SLP32_WAKE_XTL_TIME_LSB) & MAC_PCU_SLP32_WAKE_XTL_TIME_MASK)
+
+#define MAC_PCU_SLP32_INC_ADDRESS                0x000000fc
+#define MAC_PCU_SLP32_INC_OFFSET                 0x000000fc
+#define MAC_PCU_SLP32_INC_TSF_INC_MSB            19
+#define MAC_PCU_SLP32_INC_TSF_INC_LSB            0
+#define MAC_PCU_SLP32_INC_TSF_INC_MASK           0x000fffff
+#define MAC_PCU_SLP32_INC_TSF_INC_GET(x)         (((x) & MAC_PCU_SLP32_INC_TSF_INC_MASK) >> MAC_PCU_SLP32_INC_TSF_INC_LSB)
+#define MAC_PCU_SLP32_INC_TSF_INC_SET(x)         (((x) << MAC_PCU_SLP32_INC_TSF_INC_LSB) & MAC_PCU_SLP32_INC_TSF_INC_MASK)
+
+#define MAC_PCU_SLP_MIB1_ADDRESS                 0x00000100
+#define MAC_PCU_SLP_MIB1_OFFSET                  0x00000100
+#define MAC_PCU_SLP_MIB1_SLEEP_CNT_MSB           31
+#define MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB           0
+#define MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK          0xffffffff
+#define MAC_PCU_SLP_MIB1_SLEEP_CNT_GET(x)        (((x) & MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK) >> MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB)
+#define MAC_PCU_SLP_MIB1_SLEEP_CNT_SET(x)        (((x) << MAC_PCU_SLP_MIB1_SLEEP_CNT_LSB) & MAC_PCU_SLP_MIB1_SLEEP_CNT_MASK)
+
+#define MAC_PCU_SLP_MIB2_ADDRESS                 0x00000104
+#define MAC_PCU_SLP_MIB2_OFFSET                  0x00000104
+#define MAC_PCU_SLP_MIB2_CYCLE_CNT_MSB           31
+#define MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB           0
+#define MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK          0xffffffff
+#define MAC_PCU_SLP_MIB2_CYCLE_CNT_GET(x)        (((x) & MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK) >> MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB)
+#define MAC_PCU_SLP_MIB2_CYCLE_CNT_SET(x)        (((x) << MAC_PCU_SLP_MIB2_CYCLE_CNT_LSB) & MAC_PCU_SLP_MIB2_CYCLE_CNT_MASK)
+
+#define MAC_PCU_SLP_MIB3_ADDRESS                 0x00000108
+#define MAC_PCU_SLP_MIB3_OFFSET                  0x00000108
+#define MAC_PCU_SLP_MIB3_PENDING_MSB             1
+#define MAC_PCU_SLP_MIB3_PENDING_LSB             1
+#define MAC_PCU_SLP_MIB3_PENDING_MASK            0x00000002
+#define MAC_PCU_SLP_MIB3_PENDING_GET(x)          (((x) & MAC_PCU_SLP_MIB3_PENDING_MASK) >> MAC_PCU_SLP_MIB3_PENDING_LSB)
+#define MAC_PCU_SLP_MIB3_PENDING_SET(x)          (((x) << MAC_PCU_SLP_MIB3_PENDING_LSB) & MAC_PCU_SLP_MIB3_PENDING_MASK)
+#define MAC_PCU_SLP_MIB3_CLR_CNT_MSB             0
+#define MAC_PCU_SLP_MIB3_CLR_CNT_LSB             0
+#define MAC_PCU_SLP_MIB3_CLR_CNT_MASK            0x00000001
+#define MAC_PCU_SLP_MIB3_CLR_CNT_GET(x)          (((x) & MAC_PCU_SLP_MIB3_CLR_CNT_MASK) >> MAC_PCU_SLP_MIB3_CLR_CNT_LSB)
+#define MAC_PCU_SLP_MIB3_CLR_CNT_SET(x)          (((x) << MAC_PCU_SLP_MIB3_CLR_CNT_LSB) & MAC_PCU_SLP_MIB3_CLR_CNT_MASK)
+
+#define MAC_PCU_SLP_BEACON_ADDRESS               0x0000010c
+#define MAC_PCU_SLP_BEACON_OFFSET                0x0000010c
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MSB 24
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB 24
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK 0x01000000
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_GET(x) (((x) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK) >> MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB)
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_SET(x) (((x) << MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_LSB) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_ENABLE_MASK)
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MSB     23
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB     0
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK    0x00ffffff
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_GET(x)  (((x) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK) >> MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB)
+#define MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_SET(x)  (((x) << MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_LSB) & MAC_PCU_SLP_BEACON_BMISS_TIMEOUT_MASK)
+
+#define POWER_REG_ADDRESS                        0x00000110
+#define POWER_REG_OFFSET                         0x00000110
+#define POWER_REG_VLVL_MSB                       11
+#define POWER_REG_VLVL_LSB                       8
+#define POWER_REG_VLVL_MASK                      0x00000f00
+#define POWER_REG_VLVL_GET(x)                    (((x) & POWER_REG_VLVL_MASK) >> POWER_REG_VLVL_LSB)
+#define POWER_REG_VLVL_SET(x)                    (((x) << POWER_REG_VLVL_LSB) & POWER_REG_VLVL_MASK)
+#define POWER_REG_CPU_INT_ENABLE_MSB             7
+#define POWER_REG_CPU_INT_ENABLE_LSB             7
+#define POWER_REG_CPU_INT_ENABLE_MASK            0x00000080
+#define POWER_REG_CPU_INT_ENABLE_GET(x)          (((x) & POWER_REG_CPU_INT_ENABLE_MASK) >> POWER_REG_CPU_INT_ENABLE_LSB)
+#define POWER_REG_CPU_INT_ENABLE_SET(x)          (((x) << POWER_REG_CPU_INT_ENABLE_LSB) & POWER_REG_CPU_INT_ENABLE_MASK)
+#define POWER_REG_WLAN_ISO_DIS_MSB               6
+#define POWER_REG_WLAN_ISO_DIS_LSB               6
+#define POWER_REG_WLAN_ISO_DIS_MASK              0x00000040
+#define POWER_REG_WLAN_ISO_DIS_GET(x)            (((x) & POWER_REG_WLAN_ISO_DIS_MASK) >> POWER_REG_WLAN_ISO_DIS_LSB)
+#define POWER_REG_WLAN_ISO_DIS_SET(x)            (((x) << POWER_REG_WLAN_ISO_DIS_LSB) & POWER_REG_WLAN_ISO_DIS_MASK)
+#define POWER_REG_WLAN_ISO_CNTL_MSB              5
+#define POWER_REG_WLAN_ISO_CNTL_LSB              5
+#define POWER_REG_WLAN_ISO_CNTL_MASK             0x00000020
+#define POWER_REG_WLAN_ISO_CNTL_GET(x)           (((x) & POWER_REG_WLAN_ISO_CNTL_MASK) >> POWER_REG_WLAN_ISO_CNTL_LSB)
+#define POWER_REG_WLAN_ISO_CNTL_SET(x)           (((x) << POWER_REG_WLAN_ISO_CNTL_LSB) & POWER_REG_WLAN_ISO_CNTL_MASK)
+#define POWER_REG_RADIO_PWD_EN_MSB               4
+#define POWER_REG_RADIO_PWD_EN_LSB               4
+#define POWER_REG_RADIO_PWD_EN_MASK              0x00000010
+#define POWER_REG_RADIO_PWD_EN_GET(x)            (((x) & POWER_REG_RADIO_PWD_EN_MASK) >> POWER_REG_RADIO_PWD_EN_LSB)
+#define POWER_REG_RADIO_PWD_EN_SET(x)            (((x) << POWER_REG_RADIO_PWD_EN_LSB) & POWER_REG_RADIO_PWD_EN_MASK)
+#define POWER_REG_SOC_SCALE_EN_MSB               3
+#define POWER_REG_SOC_SCALE_EN_LSB               3
+#define POWER_REG_SOC_SCALE_EN_MASK              0x00000008
+#define POWER_REG_SOC_SCALE_EN_GET(x)            (((x) & POWER_REG_SOC_SCALE_EN_MASK) >> POWER_REG_SOC_SCALE_EN_LSB)
+#define POWER_REG_SOC_SCALE_EN_SET(x)            (((x) << POWER_REG_SOC_SCALE_EN_LSB) & POWER_REG_SOC_SCALE_EN_MASK)
+#define POWER_REG_WLAN_SCALE_EN_MSB              2
+#define POWER_REG_WLAN_SCALE_EN_LSB              2
+#define POWER_REG_WLAN_SCALE_EN_MASK             0x00000004
+#define POWER_REG_WLAN_SCALE_EN_GET(x)           (((x) & POWER_REG_WLAN_SCALE_EN_MASK) >> POWER_REG_WLAN_SCALE_EN_LSB)
+#define POWER_REG_WLAN_SCALE_EN_SET(x)           (((x) << POWER_REG_WLAN_SCALE_EN_LSB) & POWER_REG_WLAN_SCALE_EN_MASK)
+#define POWER_REG_WLAN_PWD_EN_MSB                1
+#define POWER_REG_WLAN_PWD_EN_LSB                1
+#define POWER_REG_WLAN_PWD_EN_MASK               0x00000002
+#define POWER_REG_WLAN_PWD_EN_GET(x)             (((x) & POWER_REG_WLAN_PWD_EN_MASK) >> POWER_REG_WLAN_PWD_EN_LSB)
+#define POWER_REG_WLAN_PWD_EN_SET(x)             (((x) << POWER_REG_WLAN_PWD_EN_LSB) & POWER_REG_WLAN_PWD_EN_MASK)
+#define POWER_REG_POWER_EN_MSB                   0
+#define POWER_REG_POWER_EN_LSB                   0
+#define POWER_REG_POWER_EN_MASK                  0x00000001
+#define POWER_REG_POWER_EN_GET(x)                (((x) & POWER_REG_POWER_EN_MASK) >> POWER_REG_POWER_EN_LSB)
+#define POWER_REG_POWER_EN_SET(x)                (((x) << POWER_REG_POWER_EN_LSB) & POWER_REG_POWER_EN_MASK)
+
+#define CORE_CLK_CTRL_ADDRESS                    0x00000114
+#define CORE_CLK_CTRL_OFFSET                     0x00000114
+#define CORE_CLK_CTRL_DIV_MSB                    2
+#define CORE_CLK_CTRL_DIV_LSB                    0
+#define CORE_CLK_CTRL_DIV_MASK                   0x00000007
+#define CORE_CLK_CTRL_DIV_GET(x)                 (((x) & CORE_CLK_CTRL_DIV_MASK) >> CORE_CLK_CTRL_DIV_LSB)
+#define CORE_CLK_CTRL_DIV_SET(x)                 (((x) << CORE_CLK_CTRL_DIV_LSB) & CORE_CLK_CTRL_DIV_MASK)
+
+#define SDIO_SETUP_CIRCUIT_ADDRESS               0x00000120
+#define SDIO_SETUP_CIRCUIT_OFFSET                0x00000120
+#define SDIO_SETUP_CIRCUIT_VECTOR_MSB            7
+#define SDIO_SETUP_CIRCUIT_VECTOR_LSB            0
+#define SDIO_SETUP_CIRCUIT_VECTOR_MASK           0x000000ff
+#define SDIO_SETUP_CIRCUIT_VECTOR_GET(x)         (((x) & SDIO_SETUP_CIRCUIT_VECTOR_MASK) >> SDIO_SETUP_CIRCUIT_VECTOR_LSB)
+#define SDIO_SETUP_CIRCUIT_VECTOR_SET(x)         (((x) << SDIO_SETUP_CIRCUIT_VECTOR_LSB) & SDIO_SETUP_CIRCUIT_VECTOR_MASK)
+
+#define SDIO_SETUP_CONFIG_ADDRESS                0x00000140
+#define SDIO_SETUP_CONFIG_OFFSET                 0x00000140
+#define SDIO_SETUP_CONFIG_ENABLE_MSB             1
+#define SDIO_SETUP_CONFIG_ENABLE_LSB             1
+#define SDIO_SETUP_CONFIG_ENABLE_MASK            0x00000002
+#define SDIO_SETUP_CONFIG_ENABLE_GET(x)          (((x) & SDIO_SETUP_CONFIG_ENABLE_MASK) >> SDIO_SETUP_CONFIG_ENABLE_LSB)
+#define SDIO_SETUP_CONFIG_ENABLE_SET(x)          (((x) << SDIO_SETUP_CONFIG_ENABLE_LSB) & SDIO_SETUP_CONFIG_ENABLE_MASK)
+#define SDIO_SETUP_CONFIG_CLEAR_MSB              0
+#define SDIO_SETUP_CONFIG_CLEAR_LSB              0
+#define SDIO_SETUP_CONFIG_CLEAR_MASK             0x00000001
+#define SDIO_SETUP_CONFIG_CLEAR_GET(x)           (((x) & SDIO_SETUP_CONFIG_CLEAR_MASK) >> SDIO_SETUP_CONFIG_CLEAR_LSB)
+#define SDIO_SETUP_CONFIG_CLEAR_SET(x)           (((x) << SDIO_SETUP_CONFIG_CLEAR_LSB) & SDIO_SETUP_CONFIG_CLEAR_MASK)
+
+#define CPU_SETUP_CONFIG_ADDRESS                 0x00000144
+#define CPU_SETUP_CONFIG_OFFSET                  0x00000144
+#define CPU_SETUP_CONFIG_ENABLE_MSB              1
+#define CPU_SETUP_CONFIG_ENABLE_LSB              1
+#define CPU_SETUP_CONFIG_ENABLE_MASK             0x00000002
+#define CPU_SETUP_CONFIG_ENABLE_GET(x)           (((x) & CPU_SETUP_CONFIG_ENABLE_MASK) >> CPU_SETUP_CONFIG_ENABLE_LSB)
+#define CPU_SETUP_CONFIG_ENABLE_SET(x)           (((x) << CPU_SETUP_CONFIG_ENABLE_LSB) & CPU_SETUP_CONFIG_ENABLE_MASK)
+#define CPU_SETUP_CONFIG_CLEAR_MSB               0
+#define CPU_SETUP_CONFIG_CLEAR_LSB               0
+#define CPU_SETUP_CONFIG_CLEAR_MASK              0x00000001
+#define CPU_SETUP_CONFIG_CLEAR_GET(x)            (((x) & CPU_SETUP_CONFIG_CLEAR_MASK) >> CPU_SETUP_CONFIG_CLEAR_LSB)
+#define CPU_SETUP_CONFIG_CLEAR_SET(x)            (((x) << CPU_SETUP_CONFIG_CLEAR_LSB) & CPU_SETUP_CONFIG_CLEAR_MASK)
+
+#define CPU_SETUP_CIRCUIT_ADDRESS                0x00000160
+#define CPU_SETUP_CIRCUIT_OFFSET                 0x00000160
+#define CPU_SETUP_CIRCUIT_VECTOR_MSB             7
+#define CPU_SETUP_CIRCUIT_VECTOR_LSB             0
+#define CPU_SETUP_CIRCUIT_VECTOR_MASK            0x000000ff
+#define CPU_SETUP_CIRCUIT_VECTOR_GET(x)          (((x) & CPU_SETUP_CIRCUIT_VECTOR_MASK) >> CPU_SETUP_CIRCUIT_VECTOR_LSB)
+#define CPU_SETUP_CIRCUIT_VECTOR_SET(x)          (((x) << CPU_SETUP_CIRCUIT_VECTOR_LSB) & CPU_SETUP_CIRCUIT_VECTOR_MASK)
+
+#define BB_SETUP_CONFIG_ADDRESS                  0x00000180
+#define BB_SETUP_CONFIG_OFFSET                   0x00000180
+#define BB_SETUP_CONFIG_ENABLE_MSB               1
+#define BB_SETUP_CONFIG_ENABLE_LSB               1
+#define BB_SETUP_CONFIG_ENABLE_MASK              0x00000002
+#define BB_SETUP_CONFIG_ENABLE_GET(x)            (((x) & BB_SETUP_CONFIG_ENABLE_MASK) >> BB_SETUP_CONFIG_ENABLE_LSB)
+#define BB_SETUP_CONFIG_ENABLE_SET(x)            (((x) << BB_SETUP_CONFIG_ENABLE_LSB) & BB_SETUP_CONFIG_ENABLE_MASK)
+#define BB_SETUP_CONFIG_CLEAR_MSB                0
+#define BB_SETUP_CONFIG_CLEAR_LSB                0
+#define BB_SETUP_CONFIG_CLEAR_MASK               0x00000001
+#define BB_SETUP_CONFIG_CLEAR_GET(x)             (((x) & BB_SETUP_CONFIG_CLEAR_MASK) >> BB_SETUP_CONFIG_CLEAR_LSB)
+#define BB_SETUP_CONFIG_CLEAR_SET(x)             (((x) << BB_SETUP_CONFIG_CLEAR_LSB) & BB_SETUP_CONFIG_CLEAR_MASK)
+
+#define BB_SETUP_CIRCUIT_ADDRESS                 0x000001a0
+#define BB_SETUP_CIRCUIT_OFFSET                  0x000001a0
+#define BB_SETUP_CIRCUIT_VECTOR_MSB              7
+#define BB_SETUP_CIRCUIT_VECTOR_LSB              0
+#define BB_SETUP_CIRCUIT_VECTOR_MASK             0x000000ff
+#define BB_SETUP_CIRCUIT_VECTOR_GET(x)           (((x) & BB_SETUP_CIRCUIT_VECTOR_MASK) >> BB_SETUP_CIRCUIT_VECTOR_LSB)
+#define BB_SETUP_CIRCUIT_VECTOR_SET(x)           (((x) << BB_SETUP_CIRCUIT_VECTOR_LSB) & BB_SETUP_CIRCUIT_VECTOR_MASK)
+
+#define GPIO_WAKEUP_CONTROL_ADDRESS              0x000001c0
+#define GPIO_WAKEUP_CONTROL_OFFSET               0x000001c0
+#define GPIO_WAKEUP_CONTROL_ENABLE_MSB           0
+#define GPIO_WAKEUP_CONTROL_ENABLE_LSB           0
+#define GPIO_WAKEUP_CONTROL_ENABLE_MASK          0x00000001
+#define GPIO_WAKEUP_CONTROL_ENABLE_GET(x)        (((x) & GPIO_WAKEUP_CONTROL_ENABLE_MASK) >> GPIO_WAKEUP_CONTROL_ENABLE_LSB)
+#define GPIO_WAKEUP_CONTROL_ENABLE_SET(x)        (((x) << GPIO_WAKEUP_CONTROL_ENABLE_LSB) & GPIO_WAKEUP_CONTROL_ENABLE_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct rtc_reg_reg_s {
+  volatile unsigned int reset_control;
+  volatile unsigned int xtal_control;
+  volatile unsigned int tcxo_detect;
+  volatile unsigned int xtal_test;
+  volatile unsigned int quadrature;
+  volatile unsigned int pll_control;
+  volatile unsigned int pll_settle;
+  volatile unsigned int xtal_settle;
+  volatile unsigned int cpu_clock;
+  volatile unsigned int clock_out;
+  volatile unsigned int clock_control;
+  volatile unsigned int bias_override;
+  volatile unsigned int wdt_control;
+  volatile unsigned int wdt_status;
+  volatile unsigned int wdt;
+  volatile unsigned int wdt_count;
+  volatile unsigned int wdt_reset;
+  volatile unsigned int int_status;
+  volatile unsigned int lf_timer0;
+  volatile unsigned int lf_timer_count0;
+  volatile unsigned int lf_timer_control0;
+  volatile unsigned int lf_timer_status0;
+  volatile unsigned int lf_timer1;
+  volatile unsigned int lf_timer_count1;
+  volatile unsigned int lf_timer_control1;
+  volatile unsigned int lf_timer_status1;
+  volatile unsigned int lf_timer2;
+  volatile unsigned int lf_timer_count2;
+  volatile unsigned int lf_timer_control2;
+  volatile unsigned int lf_timer_status2;
+  volatile unsigned int lf_timer3;
+  volatile unsigned int lf_timer_count3;
+  volatile unsigned int lf_timer_control3;
+  volatile unsigned int lf_timer_status3;
+  volatile unsigned int hf_timer;
+  volatile unsigned int hf_timer_count;
+  volatile unsigned int hf_lf_count;
+  volatile unsigned int hf_timer_control;
+  volatile unsigned int hf_timer_status;
+  volatile unsigned int rtc_control;
+  volatile unsigned int rtc_time;
+  volatile unsigned int rtc_date;
+  volatile unsigned int rtc_set_time;
+  volatile unsigned int rtc_set_date;
+  volatile unsigned int rtc_set_alarm;
+  volatile unsigned int rtc_config;
+  volatile unsigned int rtc_alarm_status;
+  volatile unsigned int uart_wakeup;
+  volatile unsigned int reset_cause;
+  volatile unsigned int system_sleep;
+  volatile unsigned int sdio_wrapper;
+  volatile unsigned int mac_sleep_control;
+  volatile unsigned int keep_awake;
+  volatile unsigned int lpo_cal_time;
+  volatile unsigned int lpo_init_dividend_int;
+  volatile unsigned int lpo_init_dividend_fraction;
+  volatile unsigned int lpo_cal;
+  volatile unsigned int lpo_cal_test_control;
+  volatile unsigned int lpo_cal_test_status;
+  volatile unsigned int chip_id;
+  volatile unsigned int derived_rtc_clk;
+  volatile unsigned int mac_pcu_slp32_mode;
+  volatile unsigned int mac_pcu_slp32_wake;
+  volatile unsigned int mac_pcu_slp32_inc;
+  volatile unsigned int mac_pcu_slp_mib1;
+  volatile unsigned int mac_pcu_slp_mib2;
+  volatile unsigned int mac_pcu_slp_mib3;
+  volatile unsigned int mac_pcu_slp_beacon;
+  volatile unsigned int power_reg;
+  volatile unsigned int core_clk_ctrl;
+  unsigned char pad0[8]; /* pad to 0x120 */
+  volatile unsigned int sdio_setup_circuit[8];
+  volatile unsigned int sdio_setup_config;
+  volatile unsigned int cpu_setup_config;
+  unsigned char pad1[24]; /* pad to 0x160 */
+  volatile unsigned int cpu_setup_circuit[8];
+  volatile unsigned int bb_setup_config;
+  unsigned char pad2[28]; /* pad to 0x1a0 */
+  volatile unsigned int bb_setup_circuit[8];
+  volatile unsigned int gpio_wakeup_control;
+} rtc_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _RTC_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
new file mode 100644
index 0000000..16fb99c
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
@@ -0,0 +1,186 @@
+#ifndef _SI_REG_REG_H_
+#define _SI_REG_REG_H_
+
+#define SI_CONFIG_ADDRESS                        0x00000000
+#define SI_CONFIG_OFFSET                         0x00000000
+#define SI_CONFIG_ERR_INT_MSB                    19
+#define SI_CONFIG_ERR_INT_LSB                    19
+#define SI_CONFIG_ERR_INT_MASK                   0x00080000
+#define SI_CONFIG_ERR_INT_GET(x)                 (((x) & SI_CONFIG_ERR_INT_MASK) >> SI_CONFIG_ERR_INT_LSB)
+#define SI_CONFIG_ERR_INT_SET(x)                 (((x) << SI_CONFIG_ERR_INT_LSB) & SI_CONFIG_ERR_INT_MASK)
+#define SI_CONFIG_BIDIR_OD_DATA_MSB              18
+#define SI_CONFIG_BIDIR_OD_DATA_LSB              18
+#define SI_CONFIG_BIDIR_OD_DATA_MASK             0x00040000
+#define SI_CONFIG_BIDIR_OD_DATA_GET(x)           (((x) & SI_CONFIG_BIDIR_OD_DATA_MASK) >> SI_CONFIG_BIDIR_OD_DATA_LSB)
+#define SI_CONFIG_BIDIR_OD_DATA_SET(x)           (((x) << SI_CONFIG_BIDIR_OD_DATA_LSB) & SI_CONFIG_BIDIR_OD_DATA_MASK)
+#define SI_CONFIG_I2C_MSB                        16
+#define SI_CONFIG_I2C_LSB                        16
+#define SI_CONFIG_I2C_MASK                       0x00010000
+#define SI_CONFIG_I2C_GET(x)                     (((x) & SI_CONFIG_I2C_MASK) >> SI_CONFIG_I2C_LSB)
+#define SI_CONFIG_I2C_SET(x)                     (((x) << SI_CONFIG_I2C_LSB) & SI_CONFIG_I2C_MASK)
+#define SI_CONFIG_POS_SAMPLE_MSB                 7
+#define SI_CONFIG_POS_SAMPLE_LSB                 7
+#define SI_CONFIG_POS_SAMPLE_MASK                0x00000080
+#define SI_CONFIG_POS_SAMPLE_GET(x)              (((x) & SI_CONFIG_POS_SAMPLE_MASK) >> SI_CONFIG_POS_SAMPLE_LSB)
+#define SI_CONFIG_POS_SAMPLE_SET(x)              (((x) << SI_CONFIG_POS_SAMPLE_LSB) & SI_CONFIG_POS_SAMPLE_MASK)
+#define SI_CONFIG_POS_DRIVE_MSB                  6
+#define SI_CONFIG_POS_DRIVE_LSB                  6
+#define SI_CONFIG_POS_DRIVE_MASK                 0x00000040
+#define SI_CONFIG_POS_DRIVE_GET(x)               (((x) & SI_CONFIG_POS_DRIVE_MASK) >> SI_CONFIG_POS_DRIVE_LSB)
+#define SI_CONFIG_POS_DRIVE_SET(x)               (((x) << SI_CONFIG_POS_DRIVE_LSB) & SI_CONFIG_POS_DRIVE_MASK)
+#define SI_CONFIG_INACTIVE_DATA_MSB              5
+#define SI_CONFIG_INACTIVE_DATA_LSB              5
+#define SI_CONFIG_INACTIVE_DATA_MASK             0x00000020
+#define SI_CONFIG_INACTIVE_DATA_GET(x)           (((x) & SI_CONFIG_INACTIVE_DATA_MASK) >> SI_CONFIG_INACTIVE_DATA_LSB)
+#define SI_CONFIG_INACTIVE_DATA_SET(x)           (((x) << SI_CONFIG_INACTIVE_DATA_LSB) & SI_CONFIG_INACTIVE_DATA_MASK)
+#define SI_CONFIG_INACTIVE_CLK_MSB               4
+#define SI_CONFIG_INACTIVE_CLK_LSB               4
+#define SI_CONFIG_INACTIVE_CLK_MASK              0x00000010
+#define SI_CONFIG_INACTIVE_CLK_GET(x)            (((x) & SI_CONFIG_INACTIVE_CLK_MASK) >> SI_CONFIG_INACTIVE_CLK_LSB)
+#define SI_CONFIG_INACTIVE_CLK_SET(x)            (((x) << SI_CONFIG_INACTIVE_CLK_LSB) & SI_CONFIG_INACTIVE_CLK_MASK)
+#define SI_CONFIG_DIVIDER_MSB                    3
+#define SI_CONFIG_DIVIDER_LSB                    0
+#define SI_CONFIG_DIVIDER_MASK                   0x0000000f
+#define SI_CONFIG_DIVIDER_GET(x)                 (((x) & SI_CONFIG_DIVIDER_MASK) >> SI_CONFIG_DIVIDER_LSB)
+#define SI_CONFIG_DIVIDER_SET(x)                 (((x) << SI_CONFIG_DIVIDER_LSB) & SI_CONFIG_DIVIDER_MASK)
+
+#define SI_CS_ADDRESS                            0x00000004
+#define SI_CS_OFFSET                             0x00000004
+#define SI_CS_BIT_CNT_IN_LAST_BYTE_MSB           13
+#define SI_CS_BIT_CNT_IN_LAST_BYTE_LSB           11
+#define SI_CS_BIT_CNT_IN_LAST_BYTE_MASK          0x00003800
+#define SI_CS_BIT_CNT_IN_LAST_BYTE_GET(x)        (((x) & SI_CS_BIT_CNT_IN_LAST_BYTE_MASK) >> SI_CS_BIT_CNT_IN_LAST_BYTE_LSB)
+#define SI_CS_BIT_CNT_IN_LAST_BYTE_SET(x)        (((x) << SI_CS_BIT_CNT_IN_LAST_BYTE_LSB) & SI_CS_BIT_CNT_IN_LAST_BYTE_MASK)
+#define SI_CS_DONE_ERR_MSB                       10
+#define SI_CS_DONE_ERR_LSB                       10
+#define SI_CS_DONE_ERR_MASK                      0x00000400
+#define SI_CS_DONE_ERR_GET(x)                    (((x) & SI_CS_DONE_ERR_MASK) >> SI_CS_DONE_ERR_LSB)
+#define SI_CS_DONE_ERR_SET(x)                    (((x) << SI_CS_DONE_ERR_LSB) & SI_CS_DONE_ERR_MASK)
+#define SI_CS_DONE_INT_MSB                       9
+#define SI_CS_DONE_INT_LSB                       9
+#define SI_CS_DONE_INT_MASK                      0x00000200
+#define SI_CS_DONE_INT_GET(x)                    (((x) & SI_CS_DONE_INT_MASK) >> SI_CS_DONE_INT_LSB)
+#define SI_CS_DONE_INT_SET(x)                    (((x) << SI_CS_DONE_INT_LSB) & SI_CS_DONE_INT_MASK)
+#define SI_CS_START_MSB                          8
+#define SI_CS_START_LSB                          8
+#define SI_CS_START_MASK                         0x00000100
+#define SI_CS_START_GET(x)                       (((x) & SI_CS_START_MASK) >> SI_CS_START_LSB)
+#define SI_CS_START_SET(x)                       (((x) << SI_CS_START_LSB) & SI_CS_START_MASK)
+#define SI_CS_RX_CNT_MSB                         7
+#define SI_CS_RX_CNT_LSB                         4
+#define SI_CS_RX_CNT_MASK                        0x000000f0
+#define SI_CS_RX_CNT_GET(x)                      (((x) & SI_CS_RX_CNT_MASK) >> SI_CS_RX_CNT_LSB)
+#define SI_CS_RX_CNT_SET(x)                      (((x) << SI_CS_RX_CNT_LSB) & SI_CS_RX_CNT_MASK)
+#define SI_CS_TX_CNT_MSB                         3
+#define SI_CS_TX_CNT_LSB                         0
+#define SI_CS_TX_CNT_MASK                        0x0000000f
+#define SI_CS_TX_CNT_GET(x)                      (((x) & SI_CS_TX_CNT_MASK) >> SI_CS_TX_CNT_LSB)
+#define SI_CS_TX_CNT_SET(x)                      (((x) << SI_CS_TX_CNT_LSB) & SI_CS_TX_CNT_MASK)
+
+#define SI_TX_DATA0_ADDRESS                      0x00000008
+#define SI_TX_DATA0_OFFSET                       0x00000008
+#define SI_TX_DATA0_DATA3_MSB                    31
+#define SI_TX_DATA0_DATA3_LSB                    24
+#define SI_TX_DATA0_DATA3_MASK                   0xff000000
+#define SI_TX_DATA0_DATA3_GET(x)                 (((x) & SI_TX_DATA0_DATA3_MASK) >> SI_TX_DATA0_DATA3_LSB)
+#define SI_TX_DATA0_DATA3_SET(x)                 (((x) << SI_TX_DATA0_DATA3_LSB) & SI_TX_DATA0_DATA3_MASK)
+#define SI_TX_DATA0_DATA2_MSB                    23
+#define SI_TX_DATA0_DATA2_LSB                    16
+#define SI_TX_DATA0_DATA2_MASK                   0x00ff0000
+#define SI_TX_DATA0_DATA2_GET(x)                 (((x) & SI_TX_DATA0_DATA2_MASK) >> SI_TX_DATA0_DATA2_LSB)
+#define SI_TX_DATA0_DATA2_SET(x)                 (((x) << SI_TX_DATA0_DATA2_LSB) & SI_TX_DATA0_DATA2_MASK)
+#define SI_TX_DATA0_DATA1_MSB                    15
+#define SI_TX_DATA0_DATA1_LSB                    8
+#define SI_TX_DATA0_DATA1_MASK                   0x0000ff00
+#define SI_TX_DATA0_DATA1_GET(x)                 (((x) & SI_TX_DATA0_DATA1_MASK) >> SI_TX_DATA0_DATA1_LSB)
+#define SI_TX_DATA0_DATA1_SET(x)                 (((x) << SI_TX_DATA0_DATA1_LSB) & SI_TX_DATA0_DATA1_MASK)
+#define SI_TX_DATA0_DATA0_MSB                    7
+#define SI_TX_DATA0_DATA0_LSB                    0
+#define SI_TX_DATA0_DATA0_MASK                   0x000000ff
+#define SI_TX_DATA0_DATA0_GET(x)                 (((x) & SI_TX_DATA0_DATA0_MASK) >> SI_TX_DATA0_DATA0_LSB)
+#define SI_TX_DATA0_DATA0_SET(x)                 (((x) << SI_TX_DATA0_DATA0_LSB) & SI_TX_DATA0_DATA0_MASK)
+
+#define SI_TX_DATA1_ADDRESS                      0x0000000c
+#define SI_TX_DATA1_OFFSET                       0x0000000c
+#define SI_TX_DATA1_DATA7_MSB                    31
+#define SI_TX_DATA1_DATA7_LSB                    24
+#define SI_TX_DATA1_DATA7_MASK                   0xff000000
+#define SI_TX_DATA1_DATA7_GET(x)                 (((x) & SI_TX_DATA1_DATA7_MASK) >> SI_TX_DATA1_DATA7_LSB)
+#define SI_TX_DATA1_DATA7_SET(x)                 (((x) << SI_TX_DATA1_DATA7_LSB) & SI_TX_DATA1_DATA7_MASK)
+#define SI_TX_DATA1_DATA6_MSB                    23
+#define SI_TX_DATA1_DATA6_LSB                    16
+#define SI_TX_DATA1_DATA6_MASK                   0x00ff0000
+#define SI_TX_DATA1_DATA6_GET(x)                 (((x) & SI_TX_DATA1_DATA6_MASK) >> SI_TX_DATA1_DATA6_LSB)
+#define SI_TX_DATA1_DATA6_SET(x)                 (((x) << SI_TX_DATA1_DATA6_LSB) & SI_TX_DATA1_DATA6_MASK)
+#define SI_TX_DATA1_DATA5_MSB                    15
+#define SI_TX_DATA1_DATA5_LSB                    8
+#define SI_TX_DATA1_DATA5_MASK                   0x0000ff00
+#define SI_TX_DATA1_DATA5_GET(x)                 (((x) & SI_TX_DATA1_DATA5_MASK) >> SI_TX_DATA1_DATA5_LSB)
+#define SI_TX_DATA1_DATA5_SET(x)                 (((x) << SI_TX_DATA1_DATA5_LSB) & SI_TX_DATA1_DATA5_MASK)
+#define SI_TX_DATA1_DATA4_MSB                    7
+#define SI_TX_DATA1_DATA4_LSB                    0
+#define SI_TX_DATA1_DATA4_MASK                   0x000000ff
+#define SI_TX_DATA1_DATA4_GET(x)                 (((x) & SI_TX_DATA1_DATA4_MASK) >> SI_TX_DATA1_DATA4_LSB)
+#define SI_TX_DATA1_DATA4_SET(x)                 (((x) << SI_TX_DATA1_DATA4_LSB) & SI_TX_DATA1_DATA4_MASK)
+
+#define SI_RX_DATA0_ADDRESS                      0x00000010
+#define SI_RX_DATA0_OFFSET                       0x00000010
+#define SI_RX_DATA0_DATA3_MSB                    31
+#define SI_RX_DATA0_DATA3_LSB                    24
+#define SI_RX_DATA0_DATA3_MASK                   0xff000000
+#define SI_RX_DATA0_DATA3_GET(x)                 (((x) & SI_RX_DATA0_DATA3_MASK) >> SI_RX_DATA0_DATA3_LSB)
+#define SI_RX_DATA0_DATA3_SET(x)                 (((x) << SI_RX_DATA0_DATA3_LSB) & SI_RX_DATA0_DATA3_MASK)
+#define SI_RX_DATA0_DATA2_MSB                    23
+#define SI_RX_DATA0_DATA2_LSB                    16
+#define SI_RX_DATA0_DATA2_MASK                   0x00ff0000
+#define SI_RX_DATA0_DATA2_GET(x)                 (((x) & SI_RX_DATA0_DATA2_MASK) >> SI_RX_DATA0_DATA2_LSB)
+#define SI_RX_DATA0_DATA2_SET(x)                 (((x) << SI_RX_DATA0_DATA2_LSB) & SI_RX_DATA0_DATA2_MASK)
+#define SI_RX_DATA0_DATA1_MSB                    15
+#define SI_RX_DATA0_DATA1_LSB                    8
+#define SI_RX_DATA0_DATA1_MASK                   0x0000ff00
+#define SI_RX_DATA0_DATA1_GET(x)                 (((x) & SI_RX_DATA0_DATA1_MASK) >> SI_RX_DATA0_DATA1_LSB)
+#define SI_RX_DATA0_DATA1_SET(x)                 (((x) << SI_RX_DATA0_DATA1_LSB) & SI_RX_DATA0_DATA1_MASK)
+#define SI_RX_DATA0_DATA0_MSB                    7
+#define SI_RX_DATA0_DATA0_LSB                    0
+#define SI_RX_DATA0_DATA0_MASK                   0x000000ff
+#define SI_RX_DATA0_DATA0_GET(x)                 (((x) & SI_RX_DATA0_DATA0_MASK) >> SI_RX_DATA0_DATA0_LSB)
+#define SI_RX_DATA0_DATA0_SET(x)                 (((x) << SI_RX_DATA0_DATA0_LSB) & SI_RX_DATA0_DATA0_MASK)
+
+#define SI_RX_DATA1_ADDRESS                      0x00000014
+#define SI_RX_DATA1_OFFSET                       0x00000014
+#define SI_RX_DATA1_DATA7_MSB                    31
+#define SI_RX_DATA1_DATA7_LSB                    24
+#define SI_RX_DATA1_DATA7_MASK                   0xff000000
+#define SI_RX_DATA1_DATA7_GET(x)                 (((x) & SI_RX_DATA1_DATA7_MASK) >> SI_RX_DATA1_DATA7_LSB)
+#define SI_RX_DATA1_DATA7_SET(x)                 (((x) << SI_RX_DATA1_DATA7_LSB) & SI_RX_DATA1_DATA7_MASK)
+#define SI_RX_DATA1_DATA6_MSB                    23
+#define SI_RX_DATA1_DATA6_LSB                    16
+#define SI_RX_DATA1_DATA6_MASK                   0x00ff0000
+#define SI_RX_DATA1_DATA6_GET(x)                 (((x) & SI_RX_DATA1_DATA6_MASK) >> SI_RX_DATA1_DATA6_LSB)
+#define SI_RX_DATA1_DATA6_SET(x)                 (((x) << SI_RX_DATA1_DATA6_LSB) & SI_RX_DATA1_DATA6_MASK)
+#define SI_RX_DATA1_DATA5_MSB                    15
+#define SI_RX_DATA1_DATA5_LSB                    8
+#define SI_RX_DATA1_DATA5_MASK                   0x0000ff00
+#define SI_RX_DATA1_DATA5_GET(x)                 (((x) & SI_RX_DATA1_DATA5_MASK) >> SI_RX_DATA1_DATA5_LSB)
+#define SI_RX_DATA1_DATA5_SET(x)                 (((x) << SI_RX_DATA1_DATA5_LSB) & SI_RX_DATA1_DATA5_MASK)
+#define SI_RX_DATA1_DATA4_MSB                    7
+#define SI_RX_DATA1_DATA4_LSB                    0
+#define SI_RX_DATA1_DATA4_MASK                   0x000000ff
+#define SI_RX_DATA1_DATA4_GET(x)                 (((x) & SI_RX_DATA1_DATA4_MASK) >> SI_RX_DATA1_DATA4_LSB)
+#define SI_RX_DATA1_DATA4_SET(x)                 (((x) << SI_RX_DATA1_DATA4_LSB) & SI_RX_DATA1_DATA4_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct si_reg_reg_s {
+  volatile unsigned int si_config;
+  volatile unsigned int si_cs;
+  volatile unsigned int si_tx_data0;
+  volatile unsigned int si_tx_data1;
+  volatile unsigned int si_rx_data0;
+  volatile unsigned int si_rx_data1;
+} si_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _SI_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
new file mode 100644
index 0000000..5db321b
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
@@ -0,0 +1,327 @@
+#ifndef _UART_REG_REG_H_
+#define _UART_REG_REG_H_
+
+#define RBR_ADDRESS                              0x00000000
+#define RBR_OFFSET                               0x00000000
+#define RBR_RBR_MSB                              7
+#define RBR_RBR_LSB                              0
+#define RBR_RBR_MASK                             0x000000ff
+#define RBR_RBR_GET(x)                           (((x) & RBR_RBR_MASK) >> RBR_RBR_LSB)
+#define RBR_RBR_SET(x)                           (((x) << RBR_RBR_LSB) & RBR_RBR_MASK)
+
+#define THR_ADDRESS                              0x00000000
+#define THR_OFFSET                               0x00000000
+#define THR_THR_MSB                              7
+#define THR_THR_LSB                              0
+#define THR_THR_MASK                             0x000000ff
+#define THR_THR_GET(x)                           (((x) & THR_THR_MASK) >> THR_THR_LSB)
+#define THR_THR_SET(x)                           (((x) << THR_THR_LSB) & THR_THR_MASK)
+
+#define DLL_ADDRESS                              0x00000000
+#define DLL_OFFSET                               0x00000000
+#define DLL_DLL_MSB                              7
+#define DLL_DLL_LSB                              0
+#define DLL_DLL_MASK                             0x000000ff
+#define DLL_DLL_GET(x)                           (((x) & DLL_DLL_MASK) >> DLL_DLL_LSB)
+#define DLL_DLL_SET(x)                           (((x) << DLL_DLL_LSB) & DLL_DLL_MASK)
+
+#define DLH_ADDRESS                              0x00000004
+#define DLH_OFFSET                               0x00000004
+#define DLH_DLH_MSB                              7
+#define DLH_DLH_LSB                              0
+#define DLH_DLH_MASK                             0x000000ff
+#define DLH_DLH_GET(x)                           (((x) & DLH_DLH_MASK) >> DLH_DLH_LSB)
+#define DLH_DLH_SET(x)                           (((x) << DLH_DLH_LSB) & DLH_DLH_MASK)
+
+#define IER_ADDRESS                              0x00000004
+#define IER_OFFSET                               0x00000004
+#define IER_EDDSI_MSB                            3
+#define IER_EDDSI_LSB                            3
+#define IER_EDDSI_MASK                           0x00000008
+#define IER_EDDSI_GET(x)                         (((x) & IER_EDDSI_MASK) >> IER_EDDSI_LSB)
+#define IER_EDDSI_SET(x)                         (((x) << IER_EDDSI_LSB) & IER_EDDSI_MASK)
+#define IER_ELSI_MSB                             2
+#define IER_ELSI_LSB                             2
+#define IER_ELSI_MASK                            0x00000004
+#define IER_ELSI_GET(x)                          (((x) & IER_ELSI_MASK) >> IER_ELSI_LSB)
+#define IER_ELSI_SET(x)                          (((x) << IER_ELSI_LSB) & IER_ELSI_MASK)
+#define IER_ETBEI_MSB                            1
+#define IER_ETBEI_LSB                            1
+#define IER_ETBEI_MASK                           0x00000002
+#define IER_ETBEI_GET(x)                         (((x) & IER_ETBEI_MASK) >> IER_ETBEI_LSB)
+#define IER_ETBEI_SET(x)                         (((x) << IER_ETBEI_LSB) & IER_ETBEI_MASK)
+#define IER_ERBFI_MSB                            0
+#define IER_ERBFI_LSB                            0
+#define IER_ERBFI_MASK                           0x00000001
+#define IER_ERBFI_GET(x)                         (((x) & IER_ERBFI_MASK) >> IER_ERBFI_LSB)
+#define IER_ERBFI_SET(x)                         (((x) << IER_ERBFI_LSB) & IER_ERBFI_MASK)
+
+#define IIR_ADDRESS                              0x00000008
+#define IIR_OFFSET                               0x00000008
+#define IIR_FIFO_STATUS_MSB                      7
+#define IIR_FIFO_STATUS_LSB                      6
+#define IIR_FIFO_STATUS_MASK                     0x000000c0
+#define IIR_FIFO_STATUS_GET(x)                   (((x) & IIR_FIFO_STATUS_MASK) >> IIR_FIFO_STATUS_LSB)
+#define IIR_FIFO_STATUS_SET(x)                   (((x) << IIR_FIFO_STATUS_LSB) & IIR_FIFO_STATUS_MASK)
+#define IIR_IID_MSB                              3
+#define IIR_IID_LSB                              0
+#define IIR_IID_MASK                             0x0000000f
+#define IIR_IID_GET(x)                           (((x) & IIR_IID_MASK) >> IIR_IID_LSB)
+#define IIR_IID_SET(x)                           (((x) << IIR_IID_LSB) & IIR_IID_MASK)
+
+#define FCR_ADDRESS                              0x00000008
+#define FCR_OFFSET                               0x00000008
+#define FCR_RCVR_TRIG_MSB                        7
+#define FCR_RCVR_TRIG_LSB                        6
+#define FCR_RCVR_TRIG_MASK                       0x000000c0
+#define FCR_RCVR_TRIG_GET(x)                     (((x) & FCR_RCVR_TRIG_MASK) >> FCR_RCVR_TRIG_LSB)
+#define FCR_RCVR_TRIG_SET(x)                     (((x) << FCR_RCVR_TRIG_LSB) & FCR_RCVR_TRIG_MASK)
+#define FCR_DMA_MODE_MSB                         3
+#define FCR_DMA_MODE_LSB                         3
+#define FCR_DMA_MODE_MASK                        0x00000008
+#define FCR_DMA_MODE_GET(x)                      (((x) & FCR_DMA_MODE_MASK) >> FCR_DMA_MODE_LSB)
+#define FCR_DMA_MODE_SET(x)                      (((x) << FCR_DMA_MODE_LSB) & FCR_DMA_MODE_MASK)
+#define FCR_XMIT_FIFO_RST_MSB                    2
+#define FCR_XMIT_FIFO_RST_LSB                    2
+#define FCR_XMIT_FIFO_RST_MASK                   0x00000004
+#define FCR_XMIT_FIFO_RST_GET(x)                 (((x) & FCR_XMIT_FIFO_RST_MASK) >> FCR_XMIT_FIFO_RST_LSB)
+#define FCR_XMIT_FIFO_RST_SET(x)                 (((x) << FCR_XMIT_FIFO_RST_LSB) & FCR_XMIT_FIFO_RST_MASK)
+#define FCR_RCVR_FIFO_RST_MSB                    1
+#define FCR_RCVR_FIFO_RST_LSB                    1
+#define FCR_RCVR_FIFO_RST_MASK                   0x00000002
+#define FCR_RCVR_FIFO_RST_GET(x)                 (((x) & FCR_RCVR_FIFO_RST_MASK) >> FCR_RCVR_FIFO_RST_LSB)
+#define FCR_RCVR_FIFO_RST_SET(x)                 (((x) << FCR_RCVR_FIFO_RST_LSB) & FCR_RCVR_FIFO_RST_MASK)
+#define FCR_FIFO_EN_MSB                          0
+#define FCR_FIFO_EN_LSB                          0
+#define FCR_FIFO_EN_MASK                         0x00000001
+#define FCR_FIFO_EN_GET(x)                       (((x) & FCR_FIFO_EN_MASK) >> FCR_FIFO_EN_LSB)
+#define FCR_FIFO_EN_SET(x)                       (((x) << FCR_FIFO_EN_LSB) & FCR_FIFO_EN_MASK)
+
+#define LCR_ADDRESS                              0x0000000c
+#define LCR_OFFSET                               0x0000000c
+#define LCR_DLAB_MSB                             7
+#define LCR_DLAB_LSB                             7
+#define LCR_DLAB_MASK                            0x00000080
+#define LCR_DLAB_GET(x)                          (((x) & LCR_DLAB_MASK) >> LCR_DLAB_LSB)
+#define LCR_DLAB_SET(x)                          (((x) << LCR_DLAB_LSB) & LCR_DLAB_MASK)
+#define LCR_BREAK_MSB                            6
+#define LCR_BREAK_LSB                            6
+#define LCR_BREAK_MASK                           0x00000040
+#define LCR_BREAK_GET(x)                         (((x) & LCR_BREAK_MASK) >> LCR_BREAK_LSB)
+#define LCR_BREAK_SET(x)                         (((x) << LCR_BREAK_LSB) & LCR_BREAK_MASK)
+#define LCR_EPS_MSB                              4
+#define LCR_EPS_LSB                              4
+#define LCR_EPS_MASK                             0x00000010
+#define LCR_EPS_GET(x)                           (((x) & LCR_EPS_MASK) >> LCR_EPS_LSB)
+#define LCR_EPS_SET(x)                           (((x) << LCR_EPS_LSB) & LCR_EPS_MASK)
+#define LCR_PEN_MSB                              3
+#define LCR_PEN_LSB                              3
+#define LCR_PEN_MASK                             0x00000008
+#define LCR_PEN_GET(x)                           (((x) & LCR_PEN_MASK) >> LCR_PEN_LSB)
+#define LCR_PEN_SET(x)                           (((x) << LCR_PEN_LSB) & LCR_PEN_MASK)
+#define LCR_STOP_MSB                             2
+#define LCR_STOP_LSB                             2
+#define LCR_STOP_MASK                            0x00000004
+#define LCR_STOP_GET(x)                          (((x) & LCR_STOP_MASK) >> LCR_STOP_LSB)
+#define LCR_STOP_SET(x)                          (((x) << LCR_STOP_LSB) & LCR_STOP_MASK)
+#define LCR_CLS_MSB                              1
+#define LCR_CLS_LSB                              0
+#define LCR_CLS_MASK                             0x00000003
+#define LCR_CLS_GET(x)                           (((x) & LCR_CLS_MASK) >> LCR_CLS_LSB)
+#define LCR_CLS_SET(x)                           (((x) << LCR_CLS_LSB) & LCR_CLS_MASK)
+
+#define MCR_ADDRESS                              0x00000010
+#define MCR_OFFSET                               0x00000010
+#define MCR_LOOPBACK_MSB                         5
+#define MCR_LOOPBACK_LSB                         5
+#define MCR_LOOPBACK_MASK                        0x00000020
+#define MCR_LOOPBACK_GET(x)                      (((x) & MCR_LOOPBACK_MASK) >> MCR_LOOPBACK_LSB)
+#define MCR_LOOPBACK_SET(x)                      (((x) << MCR_LOOPBACK_LSB) & MCR_LOOPBACK_MASK)
+#define MCR_OUT2_MSB                             3
+#define MCR_OUT2_LSB                             3
+#define MCR_OUT2_MASK                            0x00000008
+#define MCR_OUT2_GET(x)                          (((x) & MCR_OUT2_MASK) >> MCR_OUT2_LSB)
+#define MCR_OUT2_SET(x)                          (((x) << MCR_OUT2_LSB) & MCR_OUT2_MASK)
+#define MCR_OUT1_MSB                             2
+#define MCR_OUT1_LSB                             2
+#define MCR_OUT1_MASK                            0x00000004
+#define MCR_OUT1_GET(x)                          (((x) & MCR_OUT1_MASK) >> MCR_OUT1_LSB)
+#define MCR_OUT1_SET(x)                          (((x) << MCR_OUT1_LSB) & MCR_OUT1_MASK)
+#define MCR_RTS_MSB                              1
+#define MCR_RTS_LSB                              1
+#define MCR_RTS_MASK                             0x00000002
+#define MCR_RTS_GET(x)                           (((x) & MCR_RTS_MASK) >> MCR_RTS_LSB)
+#define MCR_RTS_SET(x)                           (((x) << MCR_RTS_LSB) & MCR_RTS_MASK)
+#define MCR_DTR_MSB                              0
+#define MCR_DTR_LSB                              0
+#define MCR_DTR_MASK                             0x00000001
+#define MCR_DTR_GET(x)                           (((x) & MCR_DTR_MASK) >> MCR_DTR_LSB)
+#define MCR_DTR_SET(x)                           (((x) << MCR_DTR_LSB) & MCR_DTR_MASK)
+
+#define LSR_ADDRESS                              0x00000014
+#define LSR_OFFSET                               0x00000014
+#define LSR_FERR_MSB                             7
+#define LSR_FERR_LSB                             7
+#define LSR_FERR_MASK                            0x00000080
+#define LSR_FERR_GET(x)                          (((x) & LSR_FERR_MASK) >> LSR_FERR_LSB)
+#define LSR_FERR_SET(x)                          (((x) << LSR_FERR_LSB) & LSR_FERR_MASK)
+#define LSR_TEMT_MSB                             6
+#define LSR_TEMT_LSB                             6
+#define LSR_TEMT_MASK                            0x00000040
+#define LSR_TEMT_GET(x)                          (((x) & LSR_TEMT_MASK) >> LSR_TEMT_LSB)
+#define LSR_TEMT_SET(x)                          (((x) << LSR_TEMT_LSB) & LSR_TEMT_MASK)
+#define LSR_THRE_MSB                             5
+#define LSR_THRE_LSB                             5
+#define LSR_THRE_MASK                            0x00000020
+#define LSR_THRE_GET(x)                          (((x) & LSR_THRE_MASK) >> LSR_THRE_LSB)
+#define LSR_THRE_SET(x)                          (((x) << LSR_THRE_LSB) & LSR_THRE_MASK)
+#define LSR_BI_MSB                               4
+#define LSR_BI_LSB                               4
+#define LSR_BI_MASK                              0x00000010
+#define LSR_BI_GET(x)                            (((x) & LSR_BI_MASK) >> LSR_BI_LSB)
+#define LSR_BI_SET(x)                            (((x) << LSR_BI_LSB) & LSR_BI_MASK)
+#define LSR_FE_MSB                               3
+#define LSR_FE_LSB                               3
+#define LSR_FE_MASK                              0x00000008
+#define LSR_FE_GET(x)                            (((x) & LSR_FE_MASK) >> LSR_FE_LSB)
+#define LSR_FE_SET(x)                            (((x) << LSR_FE_LSB) & LSR_FE_MASK)
+#define LSR_PE_MSB                               2
+#define LSR_PE_LSB                               2
+#define LSR_PE_MASK                              0x00000004
+#define LSR_PE_GET(x)                            (((x) & LSR_PE_MASK) >> LSR_PE_LSB)
+#define LSR_PE_SET(x)                            (((x) << LSR_PE_LSB) & LSR_PE_MASK)
+#define LSR_OE_MSB                               1
+#define LSR_OE_LSB                               1
+#define LSR_OE_MASK                              0x00000002
+#define LSR_OE_GET(x)                            (((x) & LSR_OE_MASK) >> LSR_OE_LSB)
+#define LSR_OE_SET(x)                            (((x) << LSR_OE_LSB) & LSR_OE_MASK)
+#define LSR_DR_MSB                               0
+#define LSR_DR_LSB                               0
+#define LSR_DR_MASK                              0x00000001
+#define LSR_DR_GET(x)                            (((x) & LSR_DR_MASK) >> LSR_DR_LSB)
+#define LSR_DR_SET(x)                            (((x) << LSR_DR_LSB) & LSR_DR_MASK)
+
+#define MSR_ADDRESS                              0x00000018
+#define MSR_OFFSET                               0x00000018
+#define MSR_DCD_MSB                              7
+#define MSR_DCD_LSB                              7
+#define MSR_DCD_MASK                             0x00000080
+#define MSR_DCD_GET(x)                           (((x) & MSR_DCD_MASK) >> MSR_DCD_LSB)
+#define MSR_DCD_SET(x)                           (((x) << MSR_DCD_LSB) & MSR_DCD_MASK)
+#define MSR_RI_MSB                               6
+#define MSR_RI_LSB                               6
+#define MSR_RI_MASK                              0x00000040
+#define MSR_RI_GET(x)                            (((x) & MSR_RI_MASK) >> MSR_RI_LSB)
+#define MSR_RI_SET(x)                            (((x) << MSR_RI_LSB) & MSR_RI_MASK)
+#define MSR_DSR_MSB                              5
+#define MSR_DSR_LSB                              5
+#define MSR_DSR_MASK                             0x00000020
+#define MSR_DSR_GET(x)                           (((x) & MSR_DSR_MASK) >> MSR_DSR_LSB)
+#define MSR_DSR_SET(x)                           (((x) << MSR_DSR_LSB) & MSR_DSR_MASK)
+#define MSR_CTS_MSB                              4
+#define MSR_CTS_LSB                              4
+#define MSR_CTS_MASK                             0x00000010
+#define MSR_CTS_GET(x)                           (((x) & MSR_CTS_MASK) >> MSR_CTS_LSB)
+#define MSR_CTS_SET(x)                           (((x) << MSR_CTS_LSB) & MSR_CTS_MASK)
+#define MSR_DDCD_MSB                             3
+#define MSR_DDCD_LSB                             3
+#define MSR_DDCD_MASK                            0x00000008
+#define MSR_DDCD_GET(x)                          (((x) & MSR_DDCD_MASK) >> MSR_DDCD_LSB)
+#define MSR_DDCD_SET(x)                          (((x) << MSR_DDCD_LSB) & MSR_DDCD_MASK)
+#define MSR_TERI_MSB                             2
+#define MSR_TERI_LSB                             2
+#define MSR_TERI_MASK                            0x00000004
+#define MSR_TERI_GET(x)                          (((x) & MSR_TERI_MASK) >> MSR_TERI_LSB)
+#define MSR_TERI_SET(x)                          (((x) << MSR_TERI_LSB) & MSR_TERI_MASK)
+#define MSR_DDSR_MSB                             1
+#define MSR_DDSR_LSB                             1
+#define MSR_DDSR_MASK                            0x00000002
+#define MSR_DDSR_GET(x)                          (((x) & MSR_DDSR_MASK) >> MSR_DDSR_LSB)
+#define MSR_DDSR_SET(x)                          (((x) << MSR_DDSR_LSB) & MSR_DDSR_MASK)
+#define MSR_DCTS_MSB                             0
+#define MSR_DCTS_LSB                             0
+#define MSR_DCTS_MASK                            0x00000001
+#define MSR_DCTS_GET(x)                          (((x) & MSR_DCTS_MASK) >> MSR_DCTS_LSB)
+#define MSR_DCTS_SET(x)                          (((x) << MSR_DCTS_LSB) & MSR_DCTS_MASK)
+
+#define SCR_ADDRESS                              0x0000001c
+#define SCR_OFFSET                               0x0000001c
+#define SCR_SCR_MSB                              7
+#define SCR_SCR_LSB                              0
+#define SCR_SCR_MASK                             0x000000ff
+#define SCR_SCR_GET(x)                           (((x) & SCR_SCR_MASK) >> SCR_SCR_LSB)
+#define SCR_SCR_SET(x)                           (((x) << SCR_SCR_LSB) & SCR_SCR_MASK)
+
+#define SRBR_ADDRESS                             0x00000020
+#define SRBR_OFFSET                              0x00000020
+#define SRBR_SRBR_MSB                            7
+#define SRBR_SRBR_LSB                            0
+#define SRBR_SRBR_MASK                           0x000000ff
+#define SRBR_SRBR_GET(x)                         (((x) & SRBR_SRBR_MASK) >> SRBR_SRBR_LSB)
+#define SRBR_SRBR_SET(x)                         (((x) << SRBR_SRBR_LSB) & SRBR_SRBR_MASK)
+
+#define SIIR_ADDRESS                             0x00000028
+#define SIIR_OFFSET                              0x00000028
+#define SIIR_SIIR_MSB                            7
+#define SIIR_SIIR_LSB                            0
+#define SIIR_SIIR_MASK                           0x000000ff
+#define SIIR_SIIR_GET(x)                         (((x) & SIIR_SIIR_MASK) >> SIIR_SIIR_LSB)
+#define SIIR_SIIR_SET(x)                         (((x) << SIIR_SIIR_LSB) & SIIR_SIIR_MASK)
+
+#define MWR_ADDRESS                              0x0000002c
+#define MWR_OFFSET                               0x0000002c
+#define MWR_MWR_MSB                              31
+#define MWR_MWR_LSB                              0
+#define MWR_MWR_MASK                             0xffffffff
+#define MWR_MWR_GET(x)                           (((x) & MWR_MWR_MASK) >> MWR_MWR_LSB)
+#define MWR_MWR_SET(x)                           (((x) << MWR_MWR_LSB) & MWR_MWR_MASK)
+
+#define SLSR_ADDRESS                             0x00000034
+#define SLSR_OFFSET                              0x00000034
+#define SLSR_SLSR_MSB                            7
+#define SLSR_SLSR_LSB                            0
+#define SLSR_SLSR_MASK                           0x000000ff
+#define SLSR_SLSR_GET(x)                         (((x) & SLSR_SLSR_MASK) >> SLSR_SLSR_LSB)
+#define SLSR_SLSR_SET(x)                         (((x) << SLSR_SLSR_LSB) & SLSR_SLSR_MASK)
+
+#define SMSR_ADDRESS                             0x00000038
+#define SMSR_OFFSET                              0x00000038
+#define SMSR_SMSR_MSB                            7
+#define SMSR_SMSR_LSB                            0
+#define SMSR_SMSR_MASK                           0x000000ff
+#define SMSR_SMSR_GET(x)                         (((x) & SMSR_SMSR_MASK) >> SMSR_SMSR_LSB)
+#define SMSR_SMSR_SET(x)                         (((x) << SMSR_SMSR_LSB) & SMSR_SMSR_MASK)
+
+#define MRR_ADDRESS                              0x0000003c
+#define MRR_OFFSET                               0x0000003c
+#define MRR_MRR_MSB                              31
+#define MRR_MRR_LSB                              0
+#define MRR_MRR_MASK                             0xffffffff
+#define MRR_MRR_GET(x)                           (((x) & MRR_MRR_MASK) >> MRR_MRR_LSB)
+#define MRR_MRR_SET(x)                           (((x) << MRR_MRR_LSB) & MRR_MRR_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct uart_reg_reg_s {
+  volatile unsigned int rbr;
+  volatile unsigned int dlh;
+  volatile unsigned int iir;
+  volatile unsigned int lcr;
+  volatile unsigned int mcr;
+  volatile unsigned int lsr;
+  volatile unsigned int msr;
+  volatile unsigned int scr;
+  volatile unsigned int srbr;
+  unsigned char pad0[4]; /* pad to 0x28 */
+  volatile unsigned int siir;
+  volatile unsigned int mwr;
+  unsigned char pad1[4]; /* pad to 0x34 */
+  volatile unsigned int slsr;
+  volatile unsigned int smsr;
+  volatile unsigned int mrr;
+} uart_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _UART_REG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
new file mode 100644
index 0000000..932ec51
--- /dev/null
+++ b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
@@ -0,0 +1,76 @@
+#ifndef _VMC_REG_REG_H_
+#define _VMC_REG_REG_H_
+
+#define MC_TCAM_VALID_ADDRESS                    0x00000000
+#define MC_TCAM_VALID_OFFSET                     0x00000000
+#define MC_TCAM_VALID_BIT_MSB                    0
+#define MC_TCAM_VALID_BIT_LSB                    0
+#define MC_TCAM_VALID_BIT_MASK                   0x00000001
+#define MC_TCAM_VALID_BIT_GET(x)                 (((x) & MC_TCAM_VALID_BIT_MASK) >> MC_TCAM_VALID_BIT_LSB)
+#define MC_TCAM_VALID_BIT_SET(x)                 (((x) << MC_TCAM_VALID_BIT_LSB) & MC_TCAM_VALID_BIT_MASK)
+
+#define MC_TCAM_MASK_ADDRESS                     0x00000080
+#define MC_TCAM_MASK_OFFSET                      0x00000080
+#define MC_TCAM_MASK_SIZE_MSB                    2
+#define MC_TCAM_MASK_SIZE_LSB                    0
+#define MC_TCAM_MASK_SIZE_MASK                   0x00000007
+#define MC_TCAM_MASK_SIZE_GET(x)                 (((x) & MC_TCAM_MASK_SIZE_MASK) >> MC_TCAM_MASK_SIZE_LSB)
+#define MC_TCAM_MASK_SIZE_SET(x)                 (((x) << MC_TCAM_MASK_SIZE_LSB) & MC_TCAM_MASK_SIZE_MASK)
+
+#define MC_TCAM_COMPARE_ADDRESS                  0x00000100
+#define MC_TCAM_COMPARE_OFFSET                   0x00000100
+#define MC_TCAM_COMPARE_KEY_MSB                  21
+#define MC_TCAM_COMPARE_KEY_LSB                  5
+#define MC_TCAM_COMPARE_KEY_MASK                 0x003fffe0
+#define MC_TCAM_COMPARE_KEY_GET(x)               (((x) & MC_TCAM_COMPARE_KEY_MASK) >> MC_TCAM_COMPARE_KEY_LSB)
+#define MC_TCAM_COMPARE_KEY_SET(x)               (((x) << MC_TCAM_COMPARE_KEY_LSB) & MC_TCAM_COMPARE_KEY_MASK)
+
+#define MC_TCAM_TARGET_ADDRESS                   0x00000180
+#define MC_TCAM_TARGET_OFFSET                    0x00000180
+#define MC_TCAM_TARGET_ADDR_MSB                  21
+#define MC_TCAM_TARGET_ADDR_LSB                  5
+#define MC_TCAM_TARGET_ADDR_MASK                 0x003fffe0
+#define MC_TCAM_TARGET_ADDR_GET(x)               (((x) & MC_TCAM_TARGET_ADDR_MASK) >> MC_TCAM_TARGET_ADDR_LSB)
+#define MC_TCAM_TARGET_ADDR_SET(x)               (((x) << MC_TCAM_TARGET_ADDR_LSB) & MC_TCAM_TARGET_ADDR_MASK)
+
+#define ADDR_ERROR_CONTROL_ADDRESS               0x00000200
+#define ADDR_ERROR_CONTROL_OFFSET                0x00000200
+#define ADDR_ERROR_CONTROL_QUAL_ENABLE_MSB       1
+#define ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB       1
+#define ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK      0x00000002
+#define ADDR_ERROR_CONTROL_QUAL_ENABLE_GET(x)    (((x) & ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK) >> ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB)
+#define ADDR_ERROR_CONTROL_QUAL_ENABLE_SET(x)    (((x) << ADDR_ERROR_CONTROL_QUAL_ENABLE_LSB) & ADDR_ERROR_CONTROL_QUAL_ENABLE_MASK)
+#define ADDR_ERROR_CONTROL_ENABLE_MSB            0
+#define ADDR_ERROR_CONTROL_ENABLE_LSB            0
+#define ADDR_ERROR_CONTROL_ENABLE_MASK           0x00000001
+#define ADDR_ERROR_CONTROL_ENABLE_GET(x)         (((x) & ADDR_ERROR_CONTROL_ENABLE_MASK) >> ADDR_ERROR_CONTROL_ENABLE_LSB)
+#define ADDR_ERROR_CONTROL_ENABLE_SET(x)         (((x) << ADDR_ERROR_CONTROL_ENABLE_LSB) & ADDR_ERROR_CONTROL_ENABLE_MASK)
+
+#define ADDR_ERROR_STATUS_ADDRESS                0x00000204
+#define ADDR_ERROR_STATUS_OFFSET                 0x00000204
+#define ADDR_ERROR_STATUS_WRITE_MSB              25
+#define ADDR_ERROR_STATUS_WRITE_LSB              25
+#define ADDR_ERROR_STATUS_WRITE_MASK             0x02000000
+#define ADDR_ERROR_STATUS_WRITE_GET(x)           (((x) & ADDR_ERROR_STATUS_WRITE_MASK) >> ADDR_ERROR_STATUS_WRITE_LSB)
+#define ADDR_ERROR_STATUS_WRITE_SET(x)           (((x) << ADDR_ERROR_STATUS_WRITE_LSB) & ADDR_ERROR_STATUS_WRITE_MASK)
+#define ADDR_ERROR_STATUS_ADDRESS_MSB            24
+#define ADDR_ERROR_STATUS_ADDRESS_LSB            0
+#define ADDR_ERROR_STATUS_ADDRESS_MASK           0x01ffffff
+#define ADDR_ERROR_STATUS_ADDRESS_GET(x)         (((x) & ADDR_ERROR_STATUS_ADDRESS_MASK) >> ADDR_ERROR_STATUS_ADDRESS_LSB)
+#define ADDR_ERROR_STATUS_ADDRESS_SET(x)         (((x) << ADDR_ERROR_STATUS_ADDRESS_LSB) & ADDR_ERROR_STATUS_ADDRESS_MASK)
+
+
+#ifndef __ASSEMBLER__
+
+typedef struct vmc_reg_reg_s {
+  volatile unsigned int mc_tcam_valid[32];
+  volatile unsigned int mc_tcam_mask[32];
+  volatile unsigned int mc_tcam_compare[32];
+  volatile unsigned int mc_tcam_target[32];
+  volatile unsigned int addr_error_control;
+  volatile unsigned int addr_error_status;
+} vmc_reg_reg_t;
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _VMC_REG_H_ */
-- 
1.6.3.3

