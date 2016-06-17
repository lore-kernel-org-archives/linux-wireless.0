Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52212 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbcFQOf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 10:35:59 -0400
Subject: Re: [PATCH 1/2] ath9k: use mac80211 intermediate software queues
To: Tim Shepard <shep@alum.mit.edu>
References: <E1bDu1d-0007mR-00@www.xplot.org>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b6a2f65f-193b-755a-0781-d7eaeb0354dc@nbd.name> (sfid-20160617_163602_361266_2CF479B5)
Date: Fri, 17 Jun 2016 16:35:50 +0200
MIME-Version: 1.0
In-Reply-To: <E1bDu1d-0007mR-00@www.xplot.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-17 15:41, Tim Shepard wrote:
>> > diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>> > index 93b3793..caeae10 100644
>> > --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> > +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> > @@ -145,8 +145,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
>> >  #define BAW_WITHIN(_start, _bawsz, _seqno) \
>> >  	((((_seqno) - (_start)) & 4095) < (_bawsz))
>> >  
>> > -#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
>> > -
>> >  #define IS_HT_RATE(rate)   (rate & 0x80)
>> >  #define IS_CCK_RATE(rate)  ((rate >= 0x18) && (rate <= 0x1e))
>> >  #define IS_OFDM_RATE(rate) ((rate >= 0x8) && (rate <= 0xf))
>> > @@ -232,8 +230,10 @@ struct ath_buf {
>> >  
>> >  struct ath_atx_tid {
>> >  	struct list_head list;
>> > +	struct sk_buff_head i_q;
>> Do we really need a third queue here? Instead of adding yet another
>> layer of queueing here, I think we should even get rid of buf_q.
>> 
>> Channel context based queue handling can be dealt with by
>> stopping/starting relevant queues on channel context changes.
>> 
>> buf_q becomes unnecessary when you remove all code in the drv_tx
>> codepath that moves frames to the intermediate queue.
>> 
>> Any frame that was pulled from the intermediate queue and prepared for
>> tx, but which can't be sent right now can simply be queued to retry_q.
>> 
>> This will also help with getting the diffstat insertion/deletion ratio
>> under control ;)
>> 
>> >  	struct sk_buff_head buf_q;
>> >  	struct sk_buff_head retry_q;
>> > +	struct ieee80211_txq *swq;
>> No need for this pointer, you can use container_of.
> 
> 
> Felix, great to hear from you and thanks for your feedback.  I will
> try to work on this.
> 
> I was struggling to understand the channel context stuff, and I have
> no idea how to test it.  (Is there anyone else listening who might be
> able to help with testing the channel context stuff as we improve this
> patch and simplify the ath9k driver's use of the new mac80211
> intermediate queues?)
> 
> 
> Felix, do you have any thoughts on the renaming of txq to hwx that I
> had done in my original version of this patch?  I had a good e-mail
> discussion with Toke a week or two ago (cc these same various lists)
> and I believe he came to understand that perhaps the renaming I had
> done in the original version of this patch was worth doing.
> 
> Now in Toke's version of my patch he calls the ieee80211 txq a "swq"
> and the ath9k hardware queue is called a "txq".  (I had called the
> ieee80211 txq a "txq" and I renamed the ath9k hardware queue "hwq"
> throught all the ath9k driver code.    This also made ath9k's names of
> things more similar to mt76 which I was looking at as an example of a
> driver that uses your new ieee80211 txq mechanism.
> 
> I think the renaming is worth doing, but I also understand the
> renaming can be disruptive to others actively working on ath9k.
> It would be nice to have another opinion on this.
I think we should finish intermediate queues support first and then look
into the rename later.

- Felix
