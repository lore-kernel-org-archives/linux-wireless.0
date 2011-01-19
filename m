Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11614 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752700Ab1ASLug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:50:36 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0702347834
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 20:50:35 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/8] ath5k: Simplify loop when setting up channels
Date: Wed, 19 Jan 2011 20:51:01 +0900
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6> <20110119092042.19628.81667.stgit@localhost6.localdomain6> <AANLkTinNaMK_QUDVRxQ32XtKiQXmyDeuHGoCv2rWnW=e@mail.gmail.com>
In-Reply-To: <AANLkTinNaMK_QUDVRxQ32XtKiQXmyDeuHGoCv2rWnW=e@mail.gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101192051.01876.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed January 19 2011 20:07:28 you wrote:
> On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> > Simplify confusing code and get rid of an unnecessary variable.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > 
> > @@ -285,8 +285,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
> >                return 0;
> >        }
> > 
> > -       for (i = 0, count = 0; i < size && max > 0; i++) {
> > -               ch = i + 1 ;
> > +       count = 0;
> > +       for (ch = 1; ch < size && count <= max; ch++) {
> 
> Should be <= size now, right?  And maybe rename size to max_channel
> or something like that.

Oh, yeah. Will fix.

bruno
