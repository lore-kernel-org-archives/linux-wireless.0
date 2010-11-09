Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52707 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab0KIVO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:14:58 -0500
Received: by mail-iw0-f174.google.com with SMTP id 10so1757935iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 13:14:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <33010.82.131.221.21.1289337099.squirrel@webmail.inf.u-szeged.hu>
References: <33010.82.131.221.21.1289337099.squirrel@webmail.inf.u-szeged.hu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Nov 2010 13:14:35 -0800
Message-ID: <AANLkTimwoTBazrsEBmbrW36DOy5bkvuJQnS9VcczO=Wq@mail.gmail.com>
Subject: Re: [Fwd: connecting ieee80211_hw and net_device]
To: Zoltan Herczeg <zherczeg@inf.u-szeged.hu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 9, 2010 at 1:11 PM, Zoltan Herczeg <zherczeg@inf.u-szeged.hu> wrote:
> Hi,
>
> I am developing a wireless driver for a cycle accurate energy simulator,
> and cannot solve the following issue:
>
> I can allocate a "wlan0" and "wlan1" platform device with
> ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
> realized this is not enough to have a wireless interface, since it has no
> receive operation, only transfer. Looking at the other drivers, I found
> that they allocate a net_device with the common alloc_etherdev.
> Unfortunately the register_netdev registers a new eth interface in my
> case, and this interface is not connected to the wlan interface. I set
> wireless_handlers and ieee80211_ptr for this device, still it is totally
> independent from the wlan interface.
>
> Am I missing something? (Sorry if this is a trivial question, I tried
> google but no luck so far)

Have you looked at mac80211_hwsim under drivers/net/wireless ?

 Luis
