Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38719 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750886AbdEBL4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 07:56:30 -0400
From: Shikha SINGH <shikha.singh@st.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        Manoj KUMAR <manoj.kumar@st.com>,
        Sylvain FIDELIS <sylvain.fidelis@st.com>,
        Raphael COLLADO <Raphael.COLLADO@st.com>,
        MMS_MMY_Applications_SW <MMS_MMY_Applications_SW@list.st.com>,
        Rob Herring <robh@kernel.org>
Subject: RE: [linux-nfc] [[PATCH v1] 0/6] Support of ST NFC Transceiver
Date: Tue, 2 May 2017 11:56:15 +0000
Message-ID: <3260c82d59654367af19f7c41ec09db1@SFHDAG2NODE3.st.com> (sfid-20170502_135634_107726_FE6C88A8)
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
 <C4E99B67-D95D-46E6-828A-49FFE447272B@holtmann.org>
In-Reply-To: <C4E99B67-D95D-46E6-828A-49FFE447272B@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Marcel,
          Thanks for making me aware of this new concept of serdev.

Samuel,
	You can pick my release selectively only for SPI interface.

You can skip below 2 patches which were only for UART support -
Patch#1 : A generic Digital NFC UART framework.
Patch#3 : An ST NFC UART LDisc driver ...

 I will make new release for UART support based on serdev.

Thanks & Regards,
Shikha

>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Tuesday, May 02, 2017 12:29 PM
>To: Shikha SINGH <shikha.singh@st.com>
>Cc: Samuel Ortiz <sameo@linux.intel.com>; linux-wireless <linux-
>wireless@vger.kernel.org>; linux-nfc@lists.01.org; Manoj KUMAR
><manoj.kumar@st.com>; Sylvain FIDELIS <sylvain.fidelis@st.com>; Raphael
>COLLADO <Raphael.COLLADO@st.com>; MMS_MMY_Applications_SW
><MMS_MMY_Applications_SW@list.st.com>; Rob Herring
><robh@kernel.org>
>Subject: Re: [linux-nfc] [[PATCH v1] 0/6] Support of ST NFC Transceiver
>
>Hi Shikha,
>
>> *** V1.0 ***
>> This patch series is generated on top of latest code available on
>> nfc-next.
>>
>> This patch series introduces the following features:
>>
>> (a) A generic Digital NFC UART framework.
>> The framework itself is an LDISC registered with the tty core. Any NFC
>> transciever implementing the digital specs and connected on an UART
>> (or on an emulated tty, such as /dev/ttyUSBx, /dev/ttyACMx) interface
>> with the host, will require this support.
>>
>> (b) An ST NFC Transciever core framework. This implements the required
>> digital ops and exposes an interface for the underlying phy drivers
>> (UART/ SPI). The services of the phy drivers are required when the
>> core wants to transmit/receive frames.
>> Also it provides helper functions for the phy drivers, for example phy
>> drivers registers with the core when it detects a Transciever
>> connected on the corresponding interface.
>> The framework currently supports NFC Type 2, Type 4A, Type 4B, Type 5
>> tag read/write.
>>
>> (c) An ST NFC UART LDisc driver that registers with the Digital NFC
>> UART framework, and with the ST NFC Transciever core framework as the
>> UART Phy driver.
>
>lets stop this please and move towards serdev support. We really do not need
>more line disciplines for this.
>
>Regards
>
>Marcel
