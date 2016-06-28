Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37544 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbcF1Gsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 02:48:41 -0400
Received: by mail-wm0-f51.google.com with SMTP id a66so12260230wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 23:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627143600.GA5292@atheros-ThinkPad-T61>
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
 <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
 <CA+BoTQnUvF2Zy7_WuEi0V+KjByRghVmoeR6yrs6hu6ag=KmBqQ@mail.gmail.com> <20160627143600.GA5292@atheros-ThinkPad-T61>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 28 Jun 2016 08:48:38 +0200
Message-ID: <CA+BoTQn+HeishCMf4hjpWjLBmvFG2r0gosBv77RTyk7+uOAvPA@mail.gmail.com> (sfid-20160628_084848_067106_EF43D503)
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 June 2016 at 16:36, Mohammed Shafi Shajakhan
<mohammed@codeaurora.org> wrote:
> Hi Michal,
>
> thanks for the review ..
>
> On Mon, Jun 27, 2016 at 11:27:27AM +0200, Michal Kazior wrote:
>> On 23 June 2016 at 18:40, Mohammed Shafi Shajakhan
>> <mohammed@qti.qualcomm.com> wrote:
>> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>> >
>> > For chipsets like QCA99X0, IPQ4019 and later we are not getting proper
>> > NULL func status (always acked/successs !!) when hostapd does a
>> > PROBE_CLIENT via nullfunc frames when the station is powered off
>> > abruptly (inactive timer probes client via null func after the inactive
>> > time reaches beyond the threshold). Fix this by disabling the workaround
>> > (getting the ACK status of NULL func frames by sending via HTT mgmt-tx
>> >  path) introduced by the change ("ath10k: fix beacon loss handling ")
>> > for QCA99X0 and later chipsets. The normal tx path provides the proper
>> > ACK status for NULL data frames. As of now disable this workaround for
>> > chipsets QCA99X0 and later, once the 10.1 firmware is obselete we can
>> > completely get rid of this workaround for all the chipsets
>> >
>> > Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
>> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>> > ---
>> >  drivers/net/wireless/ath/ath10k/core.c | 3 +++
>> >  drivers/net/wireless/ath/ath10k/core.h | 6 ++++++
>> >  drivers/net/wireless/ath/ath10k/mac.c  | 1 +
>> >  3 files changed, 10 insertions(+)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> > index 689d6ce..9978e4a 100644
>> > --- a/drivers/net/wireless/ath/ath10k/core.c
>> > +++ b/drivers/net/wireless/ath/ath10k/core.c
>> > @@ -181,6 +181,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>> >                         .board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
>> >                         .board_size = QCA99X0_BOARD_DATA_SZ,
>> >                         .board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
>> > +                       .disable_null_func_workaround = true,
>>
>> Tx completion (bugs) are firmware specific, not hardware. This should
>> be expressed via features bits in ath10k FW API, no?
>>
>>
> [shafi] Are you suggesting me to introduce something like
> "ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT" ? Kalle any suggestions ?
>
> Also how about getting this workaround completely if Ben had fixed this in his tree,
> will this affect older 10.2.4 ?

There's still 636.

We could probably get rid of this as long as:
 - ath10k can express the need to use Probe Requests for AP probing
(in client mode) and beacon loss handling purposes instead of NullFunc
to mac80211
 - everyone uses hostapd with disassoc_low_ack=1 with affected
firmware revisions
 - supplicant uses disassoc_low_ack=1 for p2p go
 - I have no idea about mesh/ibss but they might require some work as well

Otherwise you'll introduce regressions.


Michał
