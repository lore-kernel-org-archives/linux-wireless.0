Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:62333 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZLATSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 14:18:33 -0500
Received: by iwn1 with SMTP id 1so3313483iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 11:18:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259692053.32171.98.camel@johannes.local>
References: <1259688582.32171.97.camel@johannes.local> <1259691446.4806.12.camel@mj>
	<1259692053.32171.98.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Dec 2009 11:18:20 -0800
Message-ID: <43e72e890912011118w535781a4id4e4572df16267f4@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 1, 2009 at 10:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-12-01 at 13:17 -0500, Pavel Roskin wrote:
>> On Tue, 2009-12-01 at 18:29 +0100, Johannes Berg wrote:
>> > In some situations it is required that a system be
>> > configured with no support for 40 MHz channels in
>> > the 2.4 GHz band. Rather than imposing any such
>> > restrictions on everybody, allow configuration a
>> > system like that with a module parameter. It is
>> > writable at runtime but only takes effect at the
>> > time of the next association.
>>
>> That looks like a hack to me.
>>
>> Maybe it should be treated like other CRDA flags?  In fact, you can find
>> this in dbparse.py in the wireless-regdb sources:
>>
>>     # hole at bit 9. FIXME: Where is NO-HT40 defined?
>>     'NO-HT40':          1<<10,
>>
>> However, there are no other references to NO-HT40 in the wireless-regdb
>> or CRDA sources.  I assume it's not implemented.
>
> It's not a regulatory requirement, it's a coexistence requirement.

To extend this text a little more, me and Johannes had reviewed usage
of a NO-HT40 flag for regulatory purposes a while back. It was used
mainly on the old Atheros HAL regulatory code and upon a lot of review
even with our own regulatory folks determined that in fact there was
no specific rules about disallowing 40 MHz, but that when this was
disallowed it can be implied by the frequency range not fitting a 40
MHz channel. This is currently computed dynamically now on cfg80211
and its results are outputed through the file:

/sys/kernel/debug/ieee80211/phy0/ht40allow_map

Countries that do not allow HT40 were working on allowing it anyway so
as of now I don't think there are countries that disallow it unless
its implied by the frequency ranges allowed.

  Luis
