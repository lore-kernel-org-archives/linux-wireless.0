Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:19401 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbYLKT7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 14:59:33 -0500
Received: by wf-out-1314.google.com with SMTP id 27so903674wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 11:59:33 -0800 (PST)
Message-ID: <b6c5339f0812111159m71e6bcb7x9f74e3df056daf5@mail.gmail.com> (sfid-20081211_205937_743365_65CE1DC6)
Date: Thu, 11 Dec 2008 14:59:33 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [RFC]: atk5k: fix FCS corruption for ACKs
Cc: linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	mickflemm@gmail.com, mcgrof@gmail.com
In-Reply-To: <20081210132440.GA12873@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <493F4DC5.9090801@trash.net> <20081210132440.GA12873@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 8:24 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Dec 10, 2008 at 06:04:05AM +0100, Patrick McHardy wrote:
>> This might not be fully correct or not handle other cases where
>> this can occur, but it doesn't seem too hackish and fixes the
>> problem for me :)
>
>> -             if (hdrlen & 3) {
>> +             if (hdrlen & 3 && hdrlen != rs.rs_datalen - FCS_LEN) {
>>                       pad = hdrlen % 4;
>>                       memmove(skb->data + pad, skb->data, hdrlen);
>>                       skb_pull(skb, pad);
>
> It seems very plausible to me.  Though, why doesn't ath9k also have this
> problem?

So, I guess ath9k did too.  This patch gets my ack, though we should probably
do the hdrlen check the same way as Jouni's patch for consistency, and switch
to hdrlen & 3 when computing pad.

-- 
Bob Copeland %% www.bobcopeland.com
