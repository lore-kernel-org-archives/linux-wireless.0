Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:52319 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934329AbXC2T2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 15:28:07 -0400
Message-ID: <460C1340.7040700@warmcat.com>
Date: Thu, 29 Mar 2007 20:28:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] Meddled with by Andy Green since signed-off: made  it apply to current wireless-dev, took out comments for radiotap types not  in current wireless-dev
References: <20070329133114.569947199@warmcat.com>	 <20070329133123.323900095@warmcat.com> <1175195559.12052.14.camel@dv>
In-Reply-To: <1175195559.12052.14.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Thu, 2007-03-29 at 14:31 +0100, andy@warmcat.com wrote:
>> plain text document attachment
>> (mac80211-sparse-annotate-radiotap-header-pavel-roskin.diff)
>> Document that all fields must be little endian.  Use annotated types
>> even in the comments.  Consistently use shorter type names (u8, s8). 
>> Realign the comments.
> 
> I don't know what it means, but I think wireless-dev should just copy
> include/net/ieee80211_radiotap.h from wireless-2.6.  The later has more
> fields, and it turns out they are approved by David Young, the radiotap
> maintainer.

Just to clear up some confusion about the title, I sent myself the 
patchset first to make sure it would go out okay, and it surpised me by 
sending Pavel a copy because his email is in the patch.  The title is 
what I wrote in the first line of the patch comment at that time.

> There is no reason mac80211 would need to change that file.

I included it because I wanted the __le stuff your patch added to the 
ieee80211_radiotap_header definition and the documentation that the args 
are __le* as well.

The file in wireless-2.6 does not seem to have the __le stuff in it?  Am 
I looking in the right place at 
http://ftp.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git?

>>   *
>> - * IEEE80211_RADIOTAP_FCS           	u32       data
>> + * IEEE80211_RADIOTAP_FCS           	__le32          data
>>   *
>>   *	FCS from frame in network byte order.
> 
> I sent a patch yesterday that removes this part altogether.

Okay well I will remove it here from my patch too in case it goes on.

> I'm fine with this patch, I'm just saying that adjusting the patch is
> more work than copying the file.

I don't mind using another version that has later fields instead, but I 
think your idea to put the right types in and document it needs keeping 
one way or another.  It's pretty unusual that the struct and args are 
little-endian and it is big clue when you see the types talked about 
with __le.

-Andy
