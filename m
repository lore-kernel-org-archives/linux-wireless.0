Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40283 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbYKFTvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 14:51:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.cosetrain.com (Postfix) with ESMTP id 78413A18BB9
	for <linux-wireless@vger.kernel.org>; Thu,  6 Nov 2008 20:27:15 +0100 (CET)
Received: from [192.168.42.23] (ppp-88-217-76-138.dynamic.mnet-online.de [88.217.76.138])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.cosetrain.com (Postfix) with ESMTP id 3C120A189E3
	for <linux-wireless@vger.kernel.org>; Thu,  6 Nov 2008 20:27:15 +0100 (CET)
Message-ID: <49134511.6060106@cosetrain.com> (sfid-20081106_205113_882167_5D337335)
Date: Thu, 06 Nov 2008 20:27:13 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Newbie question about including own routing algorithm (SSR) into
 o11s: Where to begin?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone!

I'm studying CS at the Technical University of Munich. I want to try
extending Open80211s mesh networking to include Scalable Source Routing
(SSR), a routing algorithm conceived by Prof. Thomas Fuhrmann
(Karlsruhe/Munich) [1].

SSR [2] is in some ways similar to the chord overlay network, and is
based on the idea to "push chord into the underlay". It features some
very promising performance characteristics [3]. (At least in our
simulations, that is.)

As far as the draft standard is concerned, extending 802.11s to include
own path selection code and link metrics should be very possible. If I'm
not mistaken, at present the implementation doesn't quite feature a lot
of API to make this possible.

Now, where should I begin?

My plan is to first extend the open80211s code in linux-wireless to have
some path selection/link metric switching capability which should be
controlled by iw. Then I'll port the SSR code base (C++) to ANSI C and
include it in linux-wireless (man, that sounds easy. let's see... ;) ).
(then I will need an OUI, well, ... maybe first test it w/ some own
value and care about that if my stuff works)

1. Any comments and/or tips on my plan of attack?

2. Linux kernel noob literature has it that i should post my stuff early
and often. I'm not very experienced, but if you are interested, i'll try
to follow the plan and post patches that help me reach my goal (which is
mostly the path link / link metric switching stuff).

3. Rather a motivational question, but anyways: Maybe after having
tested the code in a real setup (if I'm lucky I can use the wifi testbed
of the TU Berlin), do you give my (or a related, that is) project any
chance of being included in the official (vanilla linux) distribution?
That would totally rock my world. And my grade, probably, too ^^ But
after all it's just 'proprietary' (as the standard puts it) routing
code. (of course it will be GPL'd)

Thanks!

Flo

[1] http://www.net.in.tum.de/de/mitarbeiter/fuhrmann/ and
http://i30www.ira.uka.de/aboutus/people/personal/fuhrmann?lid=en&publ=y

[2] Linyphi is a user-space implementation of SSR done in C++, see
http://linyphi.net/ and also for a good introduction to SSR in general
the paper
http://i30www.ira.uka.de/research/documents/p2p/2006/di06linyphi.pdf

[3] On the performance of SSR:
http://i30www.ira.uka.de/research/documents/p2p/2007/fuhrmann07wons.pdf
