Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38799 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYCUUVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:21:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Fri, 21 Mar 2008 21:20:58 +0100
Cc: Greg KH <greg@kroah.com>, heiko.carstens@de.ibm.com,
	stern@rowland.harvard.edu, hmh@hmh.eng.br, david-b@pacbell.net,
	rpurdie@rpsys.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
	geert@linux-m68k.org, netdev@vger.kernel.org,
	schwidefsky@de.ibm.com, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
	stefanr@s5r6.in-berlin.de, lm-sensors@lm-sensors.org
References: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org> <20080321125950.a5b38bda.akpm@linux-foundation.org> <200803212116.49462.mb@bu3sch.de>
In-Reply-To: <200803212116.49462.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803212120.59067.mb@bu3sch.de> (sfid-20080321_202142_952400_C0497120)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 March 2008 21:16:48 Michael Buesch wrote:
> On Friday 21 March 2008 20:59:50 Andrew Morton wrote:
> > They could of course be switched to using
> > kmalloc(GFP_ATOMIC)+memcpy()+schedule_task().  That's rather slow, but this
> > is not a performance-sensitive area.  But more seriously, this could lead
> > to messages getting lost from a dying machine.
> 
> Well, IMO drivers that need to sleep to transmit some data (to whatever,
> the screen or something) are not useful for debugging a crashing kernel anyway.
> Or how high is the possibility that it'd survive the actual sleep in the
> memory allocation? I'd say almost zero.
> So that schedule_task() is not that bad.

and

transmit_data_func()
{
	if (!oops_in_progress) {
		schedule_transmission_for_later();
	} else {
		/* We crash anyway, so we don't care about
		 * possible deadlocks from memory alloc sleeps
		 * or whatever. */
		close_eyes_and_transmit_it_now();
	}
}


-- 
Greetings Michael.
