Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:36005 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932175AbeDWTKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 15:10:54 -0400
Subject: mac80211: db3bdcb9c3ffc628c5284d7ed03a704295ba1214 breaks wds
 operation
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180419091738.9068-1-toke@toke.dk>
 <8ced0b02-af10-4d9d-9a68-cc08643a5cda@web.de>
 <1524207356.23123.8.camel@sipsolutions.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <63b208b0-ee8f-4c49-5c49-4378fc4de36c@dd-wrt.com> (sfid-20180423_211104_077370_9A6F2AD6)
Date: Mon, 23 Apr 2018 21:10:56 +0200
MIME-Version: 1.0
In-Reply-To: <1524207356.23123.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just for your information. while testing your latest mac80211 tree i 
found out that
db3bdcb9c3ffc628c5284d7ed03a704295ba1214
will break wds sta / ap support (tested in ath10k)
i understand what this patch does. but this patch should not find its 
way into mac80211 without a patch to all affected drivers
i'm pretty sure that problem will not just belong to ath10k. basicly all 
SW_CRYPTO_CONTROL enabled devices wont support wds anymore with that patch
beside this your patch description is wrong. ap_vlan which is used for 
wds sta / ap operation works with encryption in ath10k and is not 
related in any way to sw_crypto support

Sebastian



Am 20.04.2018 um 08:55 schrieb Johannes Berg:
> On Fri, 2018-04-20 at 00:32 +0200, Bernhard Gabler wrote:
>
>> looking at the patch, I see more occurences of the outdated "IE" in a
>> constant name and function name:
>>
>>           case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>> or
>>           reg_process_hint_country_ie()
>
> Right. I searched for further strings that would show up to the user,
> but didn't see any, but the code still refers to it in many places.
>
>> Would it make sense to likewise fix these (and possibly more)
>> occurrences too, to match the spec from 2016?
>> For the sake of readability and consistency of code ...
> I dunno. Country IE isn't the only place where "IE" is used, it's even
> used in struct names (struct ieee80211_tim_ie, and many others), so I
> would think that people who actually work on the code will have to be
> aware of the previous wording of "Information Element" (and the
> abbreviation IE) anyway. Changing *everything* here to be just _element
> instead of _ie or then probably the shorter _elem would IMHO be too much
> code churn.
>
> johannes
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
