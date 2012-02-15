Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:41334 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab2BOQqK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:46:10 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id u2so1702794lag.33
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:46:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XznrwGRXWKqHaiYqZ0f_e6OkYxK1Ft7ZqeLVy_yF0EKQ@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-7-git-send-email-victorg@ti.com>
	<CAB=NE6XznrwGRXWKqHaiYqZ0f_e6OkYxK1Ft7ZqeLVy_yF0EKQ@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:46:08 +0200
Message-ID: <CAK80WHbazpO8kGOLt=Z8JvR2DG3Js4gv37xM+=G=Tm77jL_mFg@mail.gmail.com> (sfid-20120215_174642_711424_F84BBBE9)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 1:06 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Thu, Jan 26, 2012 at 4:38 AM, Victor Goldenshtein <victorg@ti.com> wrote:
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index d08b808..b0f4e67 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -841,12 +841,16 @@ struct ieee80211_conf {
>>  *     the driver passed into mac80211.
>>  * @block_tx: Indicates whether transmission must be blocked before the
>>  *     scheduled channel switch, as indicated by the AP.
>> + * @post_switch_block_tx: Indicates whether transmission must be blocked after
>> + *     the scheduled channel switch, this should be set if the target channel
>> + *     is DFS channel.
>
> Here you say that post_switch_block_tx is required for DFS channels
> but yet you do not check for this. You should instead clarify that
> this is required on the nl80211.h command, and also add the sanity
> check there.
>
>  Luis

The AP channel switch functionality is not only for DFS, in the future
other usermode applications/clients might also use it (e.g. ACS ;)).
 In addition even the DFS-Master may switch to a non DFS channel - so
this post_switch_block_tx won't be set.


-- 
Thanks,
Victor.
