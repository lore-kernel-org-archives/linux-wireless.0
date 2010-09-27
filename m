Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49081 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504Ab0I0Tol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:44:41 -0400
Received: by fxm3 with SMTP id 3so2151245fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:44:40 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Mon, 27 Sep 2010 21:43:52 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009271956.41041.helmut.schaa@googlemail.com> <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com>
In-Reply-To: <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009272143.52283.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 27 September 2010 schrieb Joshua Smith: 
> I have another problem with these cards and hostapd where occasionally they
> will send a beacon but not respond to clients trying to join the network. 
> However, stopping hostapd and restarting it clears this condition.

Most likely a stuck tx queue. Do you have 11n enabled?

A fix to make the tx queue not stuck anymore (at least on rt3052 SoC) is
already in rt2x00 git [1] and [2]. However, I'm not sure if this is the same
issue you're facing.

Helmut

[1] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4758f8c3686911ecff11f39508a60327d42893df
[2] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=0402943d65e6832ba1cd88621d79c0c83a23ddeb
