Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3IJOpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:45:32 -0400
Message-ID: <1378824594.6741.2.camel@dcbw.foobar.com> (sfid-20130910_164534_992147_16F30979)
Subject: Re: Always send management frames at MCS-0??
From: Dan Williams <dcbw@redhat.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Sep 2013 09:49:54 -0500
In-Reply-To: <CABPxzYKcVyomdXaDxT3mLXQb0sYfM=UdoZwpbsb4qohTkPU3Cw@mail.gmail.com>
References: <522E1D31.2090403@candelatech.com>
	 <CABPxzYLaLUdCXULmx7mV5Gk7L_RrnG4Zq-vO6XRCUt0pvm9SJA@mail.gmail.com>
	 <522E5558.4070008@candelatech.com>
	 <CABPxzYKcVyomdXaDxT3mLXQb0sYfM=UdoZwpbsb4qohTkPU3Cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-10 at 14:47 +0530, Krishna Chaitanya wrote:
> On Tue, Sep 10, 2013 at 4:40 AM, Ben Greear <greearb@candelatech.com> wrote:
> 
> > Would forcing them to a lower rate at least theoretically improve
> > the chance that the packets are properly delivered?
> Yes. But we already have a RC algorithm taking care of that.
> Right?

Except if there's periodic interference, like a microwave.  In this
case, where the microwave cycles on and off, the longer it takes to
transmit the frame (ie, a lower rate) the *more* likely it is to get
partially squelched by the microwave turning on in its next cycle.  Here
a faster rate can be more robust since it can transmit the entire frame
in between microwave cycles.

Dan

