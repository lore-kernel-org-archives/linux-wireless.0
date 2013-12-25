Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57032 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3LYI2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Dec 2013 03:28:00 -0500
MIME-Version: 1.0
In-Reply-To: <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
	<CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
	<52828364.6080103@gmail.com>
	<CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
	<CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
	<CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
	<CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
	<CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
	<CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
	<CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
	<CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com>
	<5285E028.20906@gmail.com>
	<CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
Date: Wed, 25 Dec 2013 10:27:58 +0200
Message-ID: <CANUX_P1j9QNGQ2n02KpXsuMQcZo9uOsSN-zZ8yNS1e5+Y9bJOA@mail.gmail.com> (sfid-20131225_093313_151802_513B4E09)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"Bj?rn Mork" <bjorn@mork.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 11:04 AM, wzyboy <wzyboy@wzyboy.org> wrote:
> Thanks a lot for explaination, Emmanuel!
>
> Now I finally know why this is a "catch-22" situation: Disabling those
> features with OS/drvier cannot be as neat as disabling them directly
> in BIOS. And there may be chance, that disabling them at a bad timing
> may cause G3...
>
> --

Back to you.
Can you please try not to do the setpci and add this:


diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c
b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 079a511..e8a52f3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -707,6 +707,8 @@ void iwl_pcie_tx_start(struct iwl_trans *trans,
u32 scd_base_addr)
        iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
                           reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);

+        iwl_set_bits_prph(trans, 0xa04068, 0x8);
+
        /* Enable L1-Active */
        iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
                            APMG_PCIDEV_STT_VAL_L1_ACT_DIS);


thanks
