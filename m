Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47304 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2FEUL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 16:11:27 -0400
Received: by bkcji2 with SMTP id ji2so4987936bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 13:11:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd9MDk3noOH0ivH3=4Y6X_Mk4oMmttJEm40Rn2KDDQA2pw@mail.gmail.com>
References: <1338877544-12827-1-git-send-email-qasimj@gmail.com>
	<CAPjQAd_BcCDQiGNMa3uP+dgTwLhBmFRERSR6uqp227JWAOZc0g@mail.gmail.com>
	<CAPjQAd9MDk3noOH0ivH3=4Y6X_Mk4oMmttJEm40Rn2KDDQA2pw@mail.gmail.com>
Date: Tue, 5 Jun 2012 15:11:25 -0500
Message-ID: <CAJivULpUU9ffcmdaLzOsRHQ0GTN0r62Zo_XR0W53H-2A3fp-gQ@mail.gmail.com> (sfid-20120605_221131_012607_0B5F956E)
Subject: Re: [PATCH] mac80211_hwsim: Set IEEE80211_STAT_ACK flag when
 userspace indicates that the frame has been acknowledged.
From: Qasim Javed <qasimj@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Lopez <jlopex@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier,

wmediumd is not honoring HWSIM_TX_CTL_REQ_TX_STATUS right now, I can
send a separate wmediumd patch for that. This flag does not need to be
converted back to  IEEE80211_TX_CTL_REQ_TX_STATUS since we request the
status of transmission using this flag and its only relevant to
wmediumd for deciding whether to send TX information back to hwsim or
not.

HWSIM_TX_CTL_NO_ACK could be used to disable the generation of an ACK
(currently just "inserted" in to the hwsim monitor interface) for
unicast frames. Of course normally you would need an ACK, but someone
might want to test a scenario without ACKs. In that case, we should
not insert an ACK on the hwsim monitor interface when
HWSIM_TX_CTL_NO_ACK is set. Still, in this case we do not need to
convert back to IEEE80211_TX_CTL_NO_ACK.

So, basically converting back to IEEE80211_* flags is not required
(according to my understanding). This also implies that rate control
and the fail average will not be impacted by not converting the flags.

Rate control is interested in the number of retries which is already
being conveyed through TX info sent from the userspace to
mac80211_hwsim and further utilized by ieee80211_tx_status. Failed
average is only impacted by IEEE80211_STAT_ACK which has already been
set properly by the proposed patch.

-Qasim

On Tue, Jun 5, 2012 at 11:42 AM, Javier Cardona <javier@cozybit.com> wrote:
> Qasim,
>
> While reviewing your patch I also noticed that the flags
> HWSIM_TX_CTL_NO_ACK and HWSIM_TX_CTL_REQ_TX_STATUS are not converted
> back to IEEE80211_TX_CTL_NO_ACK and IEEE80211_TX_CTL_REQ_TX_STATUS on
> frames received from userspace.  Do you think that might affect rate
> adaptation or the failed average?
>
> Cheers,
>
> Javier
>
>
>
> On Tue, Jun 5, 2012 at 9:39 AM, Javier Cardona <javier@cozybit.com> wrote:
>> On Mon, Jun 4, 2012 at 11:25 PM, Qasim Javed <qasimj@gmail.com> wrote:
>>> The station fail average is not updated correctly since the IEEE80211_STAT_ACK flag is not set when using wmediumd with mac80211_hwsim. Set this flag when wmediumd indicates that the frame was successfully transmitted (eventually).
>>>
>>> Signed-off-by: Qasim Javed <qasimj@gmail.com>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>>
>>> ---
>>>  drivers/net/wireless/mac80211_hwsim.c |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
>>> index 4c9336c..a0b7cfd 100644
>>> --- a/drivers/net/wireless/mac80211_hwsim.c
>>> +++ b/drivers/net/wireless/mac80211_hwsim.c
>>> @@ -1555,6 +1555,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
>>>                        hdr = (struct ieee80211_hdr *) skb->data;
>>>                        mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
>>>                }
>>> +               txi->flags |= IEEE80211_TX_STAT_ACK;
>>>        }
>>>        ieee80211_tx_status_irqsafe(data2->hw, skb);
>>>        return 0;
>>> --
>>> 1.7.1
>>>
>>
>>
>>
>> --
>> Javier Cardona
>> cozybit Inc.
>> http://www.cozybit.com
>
>
>
> --
> Javier Cardona
> cozybit Inc.
> http://www.cozybit.com
