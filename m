Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35219 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab0KAPnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 11:43:49 -0400
Received: by iwn10 with SMTP id 10so7166279iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 08:43:49 -0700 (PDT)
From: Ben Gamari <bgamari@gmail.com>
To: =?utf-8?Q?Bj=C3=B6rn?= Smedman <bjorn.smedman@venatech.se>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
In-Reply-To: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
Date: Mon, 01 Nov 2010 11:43:41 -0400
Message-ID: <8762whrqvm.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
> Hi all,
> 
> I have an application that creates and destroys a lot of ap vifs and
> does a lot of monitor frame injection. The recent ath9k rx locking
> fixes have helped with stability in this use-case but there still
> seems to be some tx/beacon related race condition(s). These manifests
> themselves as follows on an AR913x based router running
> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
> 
> 1. TX DMA hangs under simultaneous high RX and TX load
> 2. TX is completely hung but chip is never reset

I have also observed both of these behaviors with just a standard
hostapd single VIF configuration. Quite annoying. It seems to be better
with recent wireless-testing trees.

- Ben
