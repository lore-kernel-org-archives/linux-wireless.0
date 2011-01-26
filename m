Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1AZXL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 18:11:28 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <AANLkTikYu7E3qriJ9ofw0Xfgbvy6goks=gWwcfaegYFV@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
	 <1296077594.3635.40.camel@jlt3.sipsolutions.net>
	 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
	 <1296078857.3635.41.camel@jlt3.sipsolutions.net>
	 <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
	 <1296079719.3635.47.camel@jlt3.sipsolutions.net>
	 <AANLkTikYu7E3qriJ9ofw0Xfgbvy6goks=gWwcfaegYFV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 00:11:27 +0100
Message-ID: <1296083487.3635.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 00:16 +0200, Arik Nemtsov wrote:

> > If we add the station before the response frame's ACK is received, we
> > still have the race, and we need to delete if we don't get the ACK. If
> > we add the station before we send the assoc response we get rid of this
> > race, but also have to delete if we don't get the ACK. I guess that case
> > is actually nicer in some way since we would have allowed the station to
> > connect, so if spurious data frames go up because we don't get an ACK
> > from the station that's no big deal?
> >
> 
> Maybe there's no need to delete the station even when no ACK is
> received? It will get disconnected after the idle timeout anyway. And
> it already passed authentication, so its not a DOS attack.
> (If that's what you meant as well then I agree)

Yeah -- except there's no timeout in mac80211, of course, so hostapd
really has to delete it.

johannes

