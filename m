Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43705 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbYGAQ47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 12:56:59 -0400
Date: Tue, 1 Jul 2008 13:56:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, fcrespel@gmail.com,
	yi.zhu@intel.com
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Message-ID: <20080701165657.GC6962@khazad-dum.debian.net> (sfid-20080701_185704_735651_AB9717E1)
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 Jul 2008, Adel Gadllah wrote:
> The calls to iwl|iwl3945_rfkill_set_hw_state() had to be moved because
> rfkill_force_state() cannot be called from an atomic context.

Yeah, the joys of mutexes.  If this is going to be a severe annoyance to
drivers, I don't see why rfkill could not be changed to use some other
locking primitive that does work on atomic contexes.

But I am not the right person to do it, I am still learning about all
the different locking flavours in Linux.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
