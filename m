Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48741 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab0FDOKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 10:10:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OKXb1-0006RQ-OD
	for linux-wireless@vger.kernel.org; Fri, 04 Jun 2010 16:10:03 +0200
Received: from 193.206.22.97 ([193.206.22.97])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 16:10:03 +0200
Received: from roberto.riggio by 193.206.22.97 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 16:10:03 +0200
To: linux-wireless@vger.kernel.org
From: Roberto Riggio <roberto.riggio@gmail.com>
Subject: Re: Strange ACK Behaviour with ath9k
Date: Fri, 4 Jun 2010 13:59:55 +0000 (UTC)
Message-ID: <loom.20100604T153747-904@post.gmane.org>
References: <4BEC2318.5050701@create-net.org> <AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com> <4BEE684F.2070707@create-net.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 05/14/2010 01:15 AM, Björn Smedman wrote:
> > Hi Roberto,
> >
> > When I've seen this it has been caused by a mismatch between the
> > addresses in the injected frame and that configured in the hardware.
> > The transmitting radio doesn't understand it is the intended recipient
> > of the ack and continues retrying.

It seems that the problem is related to the ack timeout. The strange thing is 
that if is use (on the transmitter)

iw phy phy0 set distance 600

everything works fine

however if I use:

iw phy phy0 set distance 300

ack are ignored. 

R.

