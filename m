Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:53596 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbZAZUvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:51:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.cosetrain.com (Postfix) with ESMTP id 6D249A18BC7
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 21:22:41 +0100 (CET)
Received: from [192.168.30.40] (ppp-93-104-122-51.dynamic.mnet-online.de [93.104.122.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.cosetrain.com (Postfix) with ESMTP id 42784A18BC6
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 21:22:41 +0100 (CET)
Message-ID: <497E1B90.4060803@cosetrain.com> (sfid-20090126_215126_101930_ED89AC85)
Date: Mon, 26 Jan 2009 21:22:40 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT] mac80211 / mesh: Modularize Path Selection Protocol
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

As I mentioned some time ago on linux-wireless [1], I am trying to
extend o11s so I can include Scalable Source Routing. Towards that goal,
I first need a method to be able to exchange the used mesh path
selection protocol.

In this patch series, you can see my first approach to an API that
enables users to exchange the path selection protocol at runtime.

What I have done so far is mostly borrowing source code from
block/elevator.c for most of the registration, finding and inserting
glue code. Also, I have wrapped mesh_hwmp into an own module and written
a test module (pptest) so the module switching can be tried out. To that
end, I also have patched iw.

For completeness, I will post the patch to iw in reply to this eMail on
this list, as it is quite simple, short and affects only two files
(compared to 14 or so for the API in the kernel).

This is my first patch not only to the kernel, but to any open source
project, so please be gentle ;) I am open to suggestions for
improvement; please also remind me on any coding style or other errors
you may find.

I would be very glad if some of the experts here could review it and
give me advice on:

 * If my selection of functions for the abstraction ops-struct is
somewhat sane or if I am missing critical parts (this is most important
to me)

 * Which is the best location for the path selection protocol ID
(cfg80211 and iw suggest having the value in struct mesh_params. o11s
currently stores it in ieee80211_if_mesh->mesh_pp_id, which is in use at
least by mesh_matches_local. And finally it obviously needs to be stored
in the path selection protocol modules.)

Greetings from Munich!

Florian


[1] http://marc.info/?l=linux-wireless&m=122600107811517&w=2

