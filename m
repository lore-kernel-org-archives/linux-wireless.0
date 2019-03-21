Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB32FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 09:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 829D120850
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 09:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qlx8TKPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfCUJLA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:11:00 -0400
Received: from nbd.name ([46.4.11.11]:46374 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfCUJLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 05:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mCmdKeW64nzm+VwE6V0VXH4DmSA8Be8S7CaZ+spN+qQ=; b=qlx8TKPD68CIdUkhjfOZM9qGmp
        xaZgNnI83M9ERfn7Nk1sEO+mp+khuv+ZaWff1YKt6a2msfxersGT7FsFPTRyewUm7AJbvOEgFxMQJ
        N+DEWA3B4RLeobuyi9Lc5VvhAVBo7wKhluUASDIRo6eQcb2irtMBxQHrtFWMTYmM5AtE=;
Received: from p4ff13c7c.dip0.t-ipconnect.de ([79.241.60.124] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h6tj0-0007bX-FS; Thu, 21 Mar 2019 10:10:58 +0100
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
 <20190319110708.GA5360@redhat.com>
 <20190319125812.GA21821@localhost.localdomain>
 <20190319160426.GA15616@redhat.com>
 <20190319162324.GB21821@localhost.localdomain>
 <20190320081127.GA17841@redhat.com>
 <20190321090243.GA15941@localhost.localdomain>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <36aaa871-47bc-f822-d259-adbf472ddf71@nbd.name>
Date:   Thu, 21 Mar 2019 10:10:57 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190321090243.GA15941@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-21 10:02, Lorenzo Bianconi wrote:
>> On Tue, Mar 19, 2019 at 05:23:25PM +0100, Lorenzo Bianconi wrote:
>> > > On Tue, Mar 19, 2019 at 01:58:13PM +0100, Lorenzo Bianconi wrote:
>> > > > > On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
>> > > > > > Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
>> > > > > > q->head is managed just in mt76u_tx_tasklet and q->queued is updated
>> > > > > > holding q->lock
>> > > > > > 
>> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> > > > > > ---
>> > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
>> > > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
>> > > > > > 
>> > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
>> > > > > > index ac03acdae279..8cd70c32d77a 100644
>> > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
>> > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
>> > > > > > @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long data)
>> > > > > >  	int i;
>> > > > > >  
>> > > > > >  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
>> > > > > > +		u32 n_queued = 0, n_sw_queued = 0;
>> > > > > > +
>> > > > > >  		sq = &dev->q_tx[i];
>> > > > > >  		q = sq->q;
>> > > > > >  
>> > > > > > -		spin_lock_bh(&q->lock);
>> > > > > > -		while (true) {
>> > > > > > +		while (q->queued > n_queued) {
>> > > > > >  			buf = &q->entry[q->head].ubuf;
>> > > > > > -			if (!buf->done || !q->queued)
>> > > > > > +			if (!buf->done)
>> > > > > >  				break;
>> > > > > 
>> > > > > I'm still thinking if this is safe or not. Is somewhat tricky to
>> > > > > read variable outside the lock because in such case there is no time
>> > > > > guarantee when variable written on one CPU gets updated value on
>> > > > > different CPU. And for USB is not only q->queued but also buf->done.
>> > > > 
>> > > > Hi Stanislaw,
>> > > > 
>> > > > I was wondering if this is safe as well, but q->queued is updated holding q->lock
>> > > > and I guess it will ensure to not overlap tx and status code path.
>> > > 
>> > > Overlap will not happen, at worst what can happen is q->queued will be
>> > > smaller on tx_tasklet than on tx_queue_skb.
>> > 
>> > Yes, that is the point :)
>> > 
>> > > 
>> > > > Regarding buf->done, it is already updated without holding the lock in mt76u_complete_tx
>> > > 
>> > > That's actually a bug, but it's not important, if tx_tasklet will not
>> > > see updated buf->done <- true value by mt76u_complete_tx on different
>> > > cpu, it will not complete skb. It will be done on next tx_tasklet iteration.
>> > > Worse thing would be opposite situation.
>> > 
>> > Can this really occur?
>> I was thinking about that and yes it can occur. If q->queued and
>> buf->done writes/read will be reordered by CPUs. To prevent that you 
>> will need to use smp_wmb/smp_rmb pair, but it's just simpler and more
>> convenient to use lock.
> 
> good point, I will go through it.
Another simple solution would be to set buf->done = false in
mt76u_tx_tasklet after tx_complete_skb instead of doing it at enqueue time.

- Felix
