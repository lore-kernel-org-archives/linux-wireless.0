Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:45320 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192Ab0GVFUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 01:20:52 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0408976049
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 14:20:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: ath5k debug mode
Date: Thu, 22 Jul 2010 14:23:28 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <AANLkTimWWGlhEhIRol_5kjhIIEILLgDuMmUXUHCCVUC1@mail.gmail.com>
In-Reply-To: <AANLkTimWWGlhEhIRol_5kjhIIEILLgDuMmUXUHCCVUC1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007221423.28805.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu July 22 2010 13:55:36 Jonathan Guerin wrote:
> Hi all,
> 
> I'm not sure if I'm just misunderstanding something, or if they
> documentation is older than what's happening in practice. I'm trying
> to enable ath5k debug mode so that I can have a poke around in debufs.
> 
> Unfortunately, enabling debug in the compat-wireless distro doesn't
> seem to output the same information as I've been reading about
> elsewhere on the 'net. My understanding is that ath5k should load an
> ath5k directory tree into debugfs:
> http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg00266.html
> 
> This doesn't seem to be happening at the moment - what I CAN see in
> the /debug tree is:
> bdi  gpio  ieee80211  kprobes  mce  pktcdvd  sched_features  tracing  usb 
> x86
> 
> Some of the stuff I expect to see in ath5k is in ieee8022, but I
> cannot write to this tree. Trying to replicate the cat mentioned in
> the link above to set the debug level in this tree fails with a
> 'permission denied' error.
> 
> Trying to load the module with the debug param fails with the following
> error: ath5k: Unknown parameter `debug'
> 
> I'm wondering if someone would be able to point me in the right
> direction to get this working.

seems like ath5k is not compiled with debugging enabled (did you set 
CONFIG_ATH5K_DEBUG=y?), or you are using the wrong (old) module?

bruno
