Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:51962 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295AbYFWNKe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 09:10:34 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1KAloR-0001yr-3f
	for linux-wireless@vger.kernel.org; Mon, 23 Jun 2008 15:10:27 +0200
Date: Mon, 23 Jun 2008 02:22:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fabien Crespel <fabien@crespel.net>
Cc: John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	Matthew Garrett
	<public-mjg-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Dan Williams <public-dcbw-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Thomas Renninger <public-trenn-l3A5Bk7waGM@hugh.gmane.org>,
	Dmitry Torokhov <public-dtor-JGs/UdohzUI@hugh.gmane.org>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080623052206.GE9926@khazad-dum.debian.net> (sfid-20080623_151125_298614_4BFD20F7)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br> <485EAA82.30808@crespel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <485EAA82.30808@crespel.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




On Sun, 22 Jun 2008, Fabien Crespel wrote:
> I've been testing this series of patch today for a new version of 
> asus-laptop, and this patch ("rfkill: do not allow userspace to override 
> ALL RADIOS OFF") introduces a bug in rfkill-input.

More than one, apparently.  Dmitry pointed out that _epo needs to be called
in task context, which rfkill-input was failing to do.

> rfkill_epo() doesn't change the current_state of the tasks, and the 
> various calls to rfkill_schedule_set(..., RFKILL_STATE_ON) don't work if 
> the last current_state stored was already RFKILL_STATE_ON.
>
> Anyway, the whole current_state thing seems completely useless and a 
> source of problems in rfkill-input, since state comparison is already 
> done in rfkill, and rfkill-input is more than likely to become out of 
> sync with the real state.
>
> Therefore I propose this additional patch to remove current_state 
> completely from rfkill-input.

I would like to get rid of it, but I need some sleep before I can think
clearly about this issue.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh


