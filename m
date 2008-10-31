Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:58344 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYJaOX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 10:23:27 -0400
Date: Fri, 31 Oct 2008 14:23:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@linux.intel.com, lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081031142318.GA9009@srcf.ucam.org> (sfid-20081031_152332_538648_A4BB0764)
References: <20081031110502.18e33eba@doriath.conectiva> <490B0D75.8020601@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <490B0D75.8020601@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 01:51:49PM +0000, Alan Jenkins wrote:

> Matthew: I nagged you twice about different consequences of this 
> commit, so here's a third :).  You said rfkill no longer automatically 
> frobs on suspend/resume, which was what I was worried about last time.  
> Should the core code also be modified so it doesn't do anything when 
> the rfkill device is unregistered?

I think there's definitely an argument in favour of that, though I 
suspect that's a design feature - if you remove the control mechanism 
for a radio, the safe state for that radio to be in is not transmitting.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
