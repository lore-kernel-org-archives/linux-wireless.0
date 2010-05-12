Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0ELQqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 12:46:49 -0400
Subject: Re: Packet injection with ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4BEADA79.5050000@create-net.org>
References: <4BE43C18.2030806@create-net.org>
	 <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com>
	 <4BE46584.5060304@create-net.org>
	 <r2y69e28c911005091324sbff07538i28babb432e6751db@mail.gmail.com>
	 <4BEADA79.5050000@create-net.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 18:46:46 +0200
Message-ID: <1273682806.3979.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-12 at 18:42 +0200, Roberto Riggio wrote:
> On 05/09/2010 10:24 PM, Gábor Stefanik wrote:
> >>     u_int16_t       it_len;
> >>     u_int32_t       it_present;
> >>      
> > AFAIK these 2 fields need to be little-endian even on big-endian
> > machines. If your system is big-endian, this can cause problems.
> >    
> 
> Thanks, that was indeed the issue. I totally missed this info
> in the radiotap website. Everything is working fine now.

I'd make it more prominent, but ... this is what it says now:

Important Radiotap Characteristics

      * Fields are strictly ordered; The developer can specify any
        combination of fields, but the data must appear following the
        radiotap header in the order they are specified in the
        it_present bitmask (or more accurately, in the order the bit
        numbers for the it_present bitmask are defined).
      * Data is specified in little endian byte-order, all data fields
        including the it_version, it_len and it_present fields in the
        radiotap header are to be specified in little endian byte-order.
        This wiki has adopted the Linux convention of using __le64,
        __le32 and __le16 for 64-, 32- and 16-bit little endian
        quantities.

johannes

