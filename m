Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:21736
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965749AbbJVVBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 17:01:11 -0400
From: Yan Bellavance <ybellavance@tamaggo.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>,
	"c_manoha@qca.qualcomm.com" <c_manoha@qca.qualcomm.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: QCA6174, is it ath6kl or ath10k?
Date: Thu, 22 Oct 2015 21:01:06 +0000
Message-ID: <BLUPR15MB01957142BACE26716CCB0841A3270@BLUPR15MB0195.namprd15.prod.outlook.com> (sfid-20151022_230116_844106_E2731CB3)
References: <BY2PR15MB0197D5CFB773E0A3F4B6062FA3380@BY2PR15MB0197.namprd15.prod.outlook.com>,<87wpuf8l94.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wpuf8l94.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

Thanks for prompt reply.  Frankly, I'm still trying to figure what driver we have really.  It's called qcaqcld2.0 but I see references to ath6kl in the various folders relating to the wifi. So that is why I presumed it was based on a ath6kl driver. What exactly is the qcaqcld2.0 driver?



1) Here is the list of files and folders in 
	/msm8994-la-1-3_amss_oem_standard/LINUX/android/kernel/drivers/net/wireless/ath:

		drwxrwxr-x ar5523
		drwxrwxr-x ath5k
		drwxrwxr-x ath6kl
		drwxrwxr-x ath9k
		-rw-rw-r-- ath.h
		drwxrwxr-x carl9170
		-rw-rw-r-- debug.c
		-rw-rw-r-- hw.c
		-rw-rw-r-- Kconfig
		-rw-rw-r-- key.c
		-rw-rw-r-- main.c
		-rw-rw-r-- Makefile
		-rw-rw-r-- regd.c
		-rw-rw-r-- regd_common.h
		-rw-rw-r-- regd.h
		-rw-rw-r-- reg.h
		drwxrwxr-x wil6210

As you can see there is no ath10k folder.



2) Here is the list of folders in 
	/msm8994-la-1-3_amss_oem_standard/LINUX/android/vendor/qcom/proprietary/wlan

		drwxrwxr-x ath6kl-utils
		drwxrwxr-x cnss-daemon
		drwxrwxr-x utils

As you can see it contains an ath6kl-utils folder.



3) When I look in
	/msm8994-la-1-3_amss_oem_standard/LINUX/android/vendor/qcom/proprietary/ftm/Android.mk

		I see references to BOARD_HAS_ATH_WLAN_AR6320 only, which is useless to us.


		
4) When I look at athdiag.c, a file inside the qcacld2.0 tools folder, I get the following target info for the register set:

	/LINUX/android/vendor/qcom/opensource/wlan/qcacld-2.0/tools/athdiag

		static const struct ath_target_info target_info[] = {
			{"AR9888_v2", reg_ar9888_v2},
			{"AR6320_v1", reg_ar6320_v1},
			{"AR6320_v2", reg_ar6320_v2},
			{"AR6320_v3", reg_ar6320_v3},
		};

5) I will spare you the list of all the other details I have found which raises questions.
		
I know support for ath10k starts with kernel 4.0 and we have kernel 3.10 but I don't see anything that would tell me that a backport has been applied.  And we've been having some issues so that is how I got here.


Regards,

Yan

________________________________________
From: Kalle Valo <kvalo@qca.qualcomm.com>
Sent: Thursday, October 22, 2015 2:34 AM
To: Yan Bellavance
Cc: ath6kl-devel@qca.qualcomm.com; c_manoha@qca.qualcomm.com; Bartosz Markowski; Janusz Dziedzic; Marek Kwaczynski; Marek Puzyniak; Michal Kazior; ath6kl@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: Re: QCA6174, is it ath6kl or ath10k?

Yan Bellavance <ybellavance@tamaggo.com> writes:

> I would like to know if the QCA6174 should be driven by ath6kl driver or
> ath10k.  I'm working with snapdragon 810 devkit and it looks like it's using
> ath6kl based driver but official linux documentation and github point out that
> it should be driven by ath10k.

What makes you think you should use ath6kl with QCA6174? Please provide
details.

> Could someone explain to me what are the differences between the two(briefly
> and in the context of QCA61x4) and if there are drawbacks to using the ath6kl
> one?

ath10k and ath6kl are drivers for different chipsets, you cannot just
choose with one to use. I don't understand why you think you can choose
as you can't.

> Why are we not using ath10k driver?

With QCA6174 you have to use ath10k.

--
Kalle Valo