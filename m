Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52480 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1EYE03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 00:26:29 -0400
Received: by bwz15 with SMTP id 15so6201949bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 21:26:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Initial automatic channel selection implementation
Date: Wed, 25 May 2011 06:24:32 +0200
Cc: "Cristian Ionescu-Idbohrn" <cristian.ionescu-idbohrn@axis.com>,
	hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> <1105241841310.6936@somehost> <4DDBE538.1090902@gnu.org>
In-Reply-To: <4DDBE538.1090902@gnu.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201105250624.32360.helmut.schaa@googlemail.com> (sfid-20110525_062636_652356_CDB0D36B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 24. Mai 2011 schrieb Pavel Roskin:
> On 05/24/2011 12:44 PM, Cristian Ionescu-Idbohrn wrote:
> > On Tue, 24 May 2011, Pavel Roskin wrote:
> >>
> >> Speaking of channels, I think only some channels should be eligible for
> >> automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).
> >
> > May I ask what the rationale behind that may be?
> 
> That's a safe distance between channels.  That's why channels 1, 6 and 
> 11 are used more often than others.
> 
> Our algorithm make select, say, channel 3.  That may be the most quiet 
> channel at the moment.  We may use absolutely the best algorithm to 
> determine that.  However, it is likely that APs operating on channels 1 
> and 6 would eventually appear in vicinity, and out AP would interfere 
> with both of them instead of just one of them.
> 
> Using a car analogy, consider channels 1, 6 and 11 like lanes on a 
> highway.  Using other channels would be like driving between lanes.  It 
> may seem safe, but only in absence of other traffic.
> 
> It's possible that the list of autoselectable channels could be country 
> specific.  I would hate to add complexity to CRDA.  Hopefully we could 
> device a simple algorithm to find the autoselectable channels based on 
> the CRDA data.

Why not use a channel list as input to the algorithm (in whatever form).
Hence, it would work for all channels (if the user wishes to do so) but it
can be limited to a list of preferred channels (1,6,11).

Helmut
