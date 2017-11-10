Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdKJGQt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 01:16:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
        <20171103082725.GB25372@aremote01.aus.cypress.com>
        <9773ee9a-90d3-a303-54b0-9893503190f9@broadcom.com>
        <20171103094016.GA51515@aremote01.aus.cypress.com>
        <87efpflbtu.fsf@codeaurora.org>
        <20171110025126.GA193831@aremote01.aus.cypress.com>
Date: Fri, 10 Nov 2017 08:16:43 +0200
In-Reply-To: <20171110025126.GA193831@aremote01.aus.cypress.com> (Chung-Hsien
        Hsu's message of "Thu, 9 Nov 2017 20:51:27 -0600")
Message-ID: <87inei8xpw.fsf@codeaurora.org> (sfid-20171110_071652_767370_F6802EF2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chung-Hsien Hsu <stanley.hsu@cypress.com> writes:

> On Fri, Nov 03, 2017 at 03:40:45PM +0200, Kalle Valo wrote:
>> Chung-Hsien Hsu <stanley.hsu@cypress.com> writes:
>> 
>> > On Fri, Nov 03, 2017 at 10:20:07AM +0100, Arend van Spriel wrote:
>> >> On 03-11-17 09:27, Chung-Hsien Hsu wrote:
>> >> >On Thu, Oct 05, 2017 at 03:31:18PM +0800, Wright Feng wrote:
>> >> >>From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>> >> >>
>> >> >>The firmware for brcmfmac devices includes information regarding
>> >> >>regulatory constraints. For certain devices this information is kept
>> >> >>separately in a binary form that needs to be downloaded to the device.
>> >> >>This patch adds support to download this so-called CLM blob file. It
>> >> >>uses the same naming scheme as the other firmware files with extension
>> >> >>of .clm_blob.
>> >> >>
>> >> >>The CLM blob file is optional. If the file does not exist, the download
>> >> >>process will be bypassed. It will not affect the driver loading.
>> >> >>
>> >> >>Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>> >> >>---
>> >> >>v2: Revise commit message to describe in more detail
>> >> >>v3: Add error handling in brcmf_c_get_clm_name function
>> >> >>v4: Correct the length of dload_buf in brcmf_c_download function
>> >> >>v5: Remove unnecessary cast and alignment
>> >> >>v6: Add debug log for the case of no CLM file present
>> >> >>---
>> >> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 162 +++++++++++++++++++++
>> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>> >> >>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>> >> >>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>> >> >>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>> >> >>  8 files changed, 263 insertions(+)
>> >> >
>> >> >Any comments or feedback about this? I'm hoping to have it in v4.15.
>> 
>> This might not necessary make it to v4.15, it depends if Linus releases
>> the final v4.14 on Sunday or not.
>
> Since the final v4.14 was not released last Sunday, is it possible to get this to v4.15?

Thanks for reminding, apparently I had forgotten to change the state of
the patch from Deferred to New. But unfortunately the patch failed to
apply so you need to rebase and submit v7.

-- 
Kalle Valo
