Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:39039 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYKBJXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 04:23:41 -0500
Date: Sun, 2 Nov 2008 09:23:36 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@linux.intel.com, lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081102092336.GD10983@srcf.ucam.org> (sfid-20081102_102349_114515_BAECB892)
References: <20081031110502.18e33eba@doriath.conectiva> <490B0D75.8020601@tuffmail.co.uk> <20081031142318.GA9009@srcf.ucam.org> <40f31dec0810311135w76c01729lef1a6c93f18c0095@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0810311135w76c01729lef1a6c93f18c0095@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 08:35:47PM +0200, Nick Kossifidis wrote:

> It doesn't leave the radio in a state that's not transmitting, it
> leaves the card in a state that doesn't get any power at all. I don't
> see any reason for this, how do you define "safe" ?

The rfkill core has no concept of what the underlying hardware 
implementation is. The fact that you can see the card at all is a bug 
triggered by the fact that we don't currently support PCIe hotplug on 
this type of machine (I've just sent a patch that adds a workaround for 
that), but the inherent reason for it happening this way is because Asus 
implemented it that way in their platform.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
