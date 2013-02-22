Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48606 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BVRmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 12:42:45 -0500
Received: by mail-wi0-f169.google.com with SMTP id l13so2447011wie.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 09:42:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5127A4E0.8080101@openwrt.org>
References: <20130215171938.GA4140@pandem0nium>
	<51279AFA.3000608@openwrt.org>
	<20130222163643.GB3757@open-mesh.com>
	<5127A4E0.8080101@openwrt.org>
Date: Fri, 22 Feb 2013 09:42:43 -0800
Message-ID: <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com> (sfid-20130222_184250_001930_DB7537BA)
Subject: Re: [RFC] design discussion: Collecting information for (non-peer) stations
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. considering I do radiotap inspection in promiscuous mode all the
time (on laptops and embedded MIPS boards alike), I'm kinda interested
in why you're seeing such high CPU utilisation.

Are you trying to capture the whole frame? Or are you only capturing
the header? It sounds like you only need the header, right?

I agree with Felix - this is the kind of thing that it makes sense to
define an API for so you can write in-kernel monitoring plugins. Then
your monitoring plugin can decide how to aggregate and pass up the
data.



Adrian
