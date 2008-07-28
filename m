Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36916 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbYG1Czs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 22:55:48 -0400
Date: Sun, 27 Jul 2008 23:55:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080728025543.GB10672@khazad-dum.debian.net> (sfid-20080728_045553_009861_35F2AD12)
References: <488CBBA0.2050106@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <488CBBA0.2050106@overt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Jul 2008, Philip Langdale wrote:
> different objects. I couldn't find one for the hardware kill switch itself but I
> did manage to find one that's emitted when the bluetooth device enters the
> equivalent of the SOFT_BLOCKED state. This is useful for noticing that the
> hardware switch has been released, but it also fires on transitions from UNBLOCKED
> to SOFT_BLOCKED - so I had to try and avoid turning around and unblocking the
> device! I'm not particularly happy with how I did it (ignore-the-next-event)
> but I can't think of a better way.

Can it be used as an event that you just take as a hint to READ the state
of the switch?  I.e. as "switch may have changed state, you better check"
instead of "switch changed state"?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
