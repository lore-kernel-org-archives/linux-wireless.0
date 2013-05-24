Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:37330 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab3EXTbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 15:31:34 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	"Ismail\, Rahman" <abdul.r.ismail@intel.com>,
	"Wallick\, Stephanie S" <stephanie.s.wallick@intel.com>
Subject: Re: Mobile Broadband Interface Model (MBIM) support?
References: <20130524170915.GA15788@xanatos> <87zjvkdwlf.fsf@nemi.mork.no>
Date: Fri, 24 May 2013 21:31:23 +0200
In-Reply-To: <87zjvkdwlf.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Fri, 24
	May 2013 21:08:44 +0200")
Message-ID: <87txlsdvjo.fsf@nemi.mork.no> (sfid-20130524_213139_704843_316A8E74)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjørn Mork <bjorn@mork.no> writes:

>> http://www.usb.org/developers/devclass_docs/MBIM10Errata1.zip
>
> Thanks for that pointer.  I haven't seen the errata before. Will study
> it, but fortunately we are protected against anything involving
> management protocol updates.

Yuck.  When did the USB-IF start publishing the erratas merged with the
original with absolutely no indication about what they changed?  This
sucks.

And the changes I notice also suck.  WTF do they need another functional
descriptor for?  For these two numbers? :

 bMaxOutstandingCommand - Max number of outstanding Command Messages the
    device can handle simultaneously. Shall be greater than 0.
 wMTU - Operator preferred MTU for home network. wMTU applies to IP Data
    Streams.

This is just plain stupid.  Sorry.  I don't know how else to describe
it. They already have an extensible management protocol.  These numbers
could easily have been published through that.   And "Operator preferred
MTU for home network" cannot possibly be a device specific attribute.
That's obviously a network attribute.  How the heck can you put that
into a functional descriptor?  It may change with the SIM card.

And then there are the things they didn't correct.  I've been looking
for the "MBIMRegistry" they refer to ever since the initial version was
published.  AFAICS there is none.  I tried mailing admin@usb.org about
it in February, but haven't received any replies. As expected.

There are already several vendor specific UUIDs in use.  The registry is
needed if we are expected to support any of these. Microsoft is the only
one documenting theirs AFAIK:
 http://msdn.microsoft.com/en-us/library/windows/hardware/jj248720.aspx
 http://msdn.microsoft.com/en-us/library/windows/hardware/jj248721.aspx
 http://msdn.microsoft.com/en-us/library/windows/hardware/jj149393.aspx

But I've also seen vendor specific services from Qualcomm, AT&T,
Ericsson, Huawei and MediaTek.  All completely undocumented wrt open
source implementations, although I have successfully guessed how to use
the Qualcomm service (it embeds Qualcomms proprietary, but partly openly
documented, QMI protocol in MBIM).


Bjørn
