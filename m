Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:56849 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYKTQba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 11:31:30 -0500
Date: Thu, 20 Nov 2008 16:31:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: drago01 <drago01@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Message-ID: <20081120163124.GA10899@srcf.ucam.org> (sfid-20081120_173135_478019_42C7ED2B)
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com> <20081103170243.GB2417@khazad-dum.debian.net> <200811031820.41165.IvDoorn@gmail.com> <20081112211530.GH2411@tuxdriver.com> <f6ca9fed0811200827y3e07bb6ag8c46e61c44fbc610@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0811200827y3e07bb6ag8c46e61c44fbc610@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 05:27:38PM +0100, drago01 wrote:
> On Wed, Nov 12, 2008 at 10:15 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > So I keep looking at these patches, and I'm not sure about them.
> > It seems that they restore the rfkill state after resume to what it
> > was before the suspend.
> 
> Wouldn't this break hw kill switches?
> If I move the switch while the system is suspended it will ignore this
> event but the hw will still not work.

Whichever driver is responsible for listening to the hardware events 
should handle that in its own resume method. The rfkill state 
restoration code will only be relevant for restoring state set by 
sofware.

> Well the above scenario would be just broken.
> Unless the driver rereads the real hw state and updates the rfkill
> state on resume.

Quite. How else are you going to know if a switch has moved in the 
intervening time?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
