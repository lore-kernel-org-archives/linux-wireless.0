Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:32803 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbeBSFz2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 00:55:28 -0500
Date: Sun, 18 Feb 2018 21:55:20 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: cantabile <cantabile.desu@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180218215520.65c1e9fd@cakuba.netronome.com> (sfid-20180219_065626_302048_32653BF8)
In-Reply-To: <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
        <20180214164549.72ee26c3@cakuba.netronome.com>
        <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
        <20180215134738.722654a9@cakuba.netronome.com>
        <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 17 Feb 2018 13:23:29 +0200, cantabile wrote:
> > Thanks for the info.  Would it be cleaner to EXPORT fw_add_devm_name()
> > and just call that in case driver sees FW is already loaded?  That
> > should inform the fw subsystem that we want the image around in case of
> > hibernation, but there is no need to load it immediately?
> 
> No, I don't believe it's cleaner to expose a private function that you 
> don't even really need. Remember that calling request_firmware every 
> time your driver's probe and resume functions are called is normal. It's 
> the expected behaviour.

I'm asking you the extend functionality of a subsystem to be able to
cleanly communicate the intent.  Not export internal functions.

Requesting firmware you don't need and risking failing probe even if FW
is already pre-loaded is not correct.  Reordering you suggest is
brittle and makes little logical sense unless someone guesses your use
case.

Please at least try to do as advised.  Otherwise:

Nacked-by: Jakub Kicinski <kubakici@wp.pl>
