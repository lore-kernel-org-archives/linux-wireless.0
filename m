Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:46039 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab0AZOuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 09:50:10 -0500
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 15:43:01 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
In-Reply-To: <87my01m0zm.fsf@purkki.valot.fi>
References: <877hr5nkx0.fsf@purkki.valot.fi> <20100126.041610.226004766.davem@davemloft.net> <87wrz5m3cd.fsf@purkki.valot.fi> <20100126.050645.184040277.davem@davemloft.net> <87my01m0zm.fsf@purkki.valot.fi>
Message-ID: <39575e70388bb2ea58dd36b9061d5055@chewa.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 26 Jan 2010 15:47:41 +0200, Kalle Valo <kalle.valo@iki.fi> wrote:

> But that's just because of mistakes with DiffServ and other QoS

> "frameworks". They didn't bother to specify how applications should

> use these. And what matters here IMHO.



TOS lets the application specify whether they want low-delay (interactive

low bandwidth traffic), high bandwidth (bulk traffic), high reliability or

low cost. It's surely vague, but anything "uniform" solution is bound to be

vague. Some applications *do* set those fields, or provide options to set

them up. And contrary to SO_PRIORITY, it *can* be made to work for

non-local queues, if the applications are trusted.



I am afraid it's too late for anything more uniform at the socket API

level. Even fewer developers would bother to support Linux>=2.6.3x-specific

options, than TOS/TCLASS.



-- 

Rémi Denis-Courmont

http://www.remlab.net

http://fi.linkedin.com/in/remidenis

