Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.129.253]:56163 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCMLKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 07:10:00 -0400
Received: from mx51.mymxserver.com (unknown [172.16.51.1])
	by emita2.mittwald.de (Postfix) with ESMTP id 7F28A5FE2F4
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 11:49:19 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Which APs to disregards from in inputting into the bss list
Date: Fri, 13 Mar 2009 11:48:30 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
In-Reply-To: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903131148.30236.hs4233@mail.mn-solutions.de> (sfid-20090313_121008_268854_AD3AB687)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Do we want to ignore certain APs if we determine they are
> bogus?

I don't have problems with discarding bss entries for the work 
case of association. For sure should the association logic check 
if it can associate at all.


However, if I do "iwlist XXX scan" or the equivalent "iw" 
command, I don't want that mac80211 silently discards entries. 
After all, I want to see "what is in the air", e.g. to find out 
why I cannot connect.

If we would simply delete entries from the list you'd get 
complaints from users "I cannot see AP xyz, but it must be 
there, because my laptop with operating system ABC can connect 
to it".


Okay, I could probably run kismet or wireshark to see "what is in 
the air", but I can imagine a fair number of users that would 
see this as intimidating.
