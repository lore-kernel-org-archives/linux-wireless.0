Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33841 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbcGRGYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 02:24:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so11041932wma.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2016 23:24:02 -0700 (PDT)
Received: from [192.168.10.110] ([147.83.206.88])
        by smtp.gmail.com with ESMTPSA id r67sm14462700wmb.14.2016.07.17.23.23.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Jul 2016 23:23:59 -0700 (PDT)
From: Joan Josep Aleixendri <jj.aleixendri@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Further question about MAC80211
Message-ID: <da190fb9-fffc-2d03-2e5b-6fb3f53fbf9a@gmail.com> (sfid-20160718_082407_401204_7EAF8EC5)
Date: Mon, 18 Jul 2016 08:23:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there!

I'd like to thank you for your time and all the information you gave me 
last monday; I'm still reading and studying it!

The main goal of our project is to dinamically control the troughtput of 
each virtual interface (ViF) depending on how good the connection is 
between 2 stations and depending on the others ViF throughtputs our 
station (STA structure or local) may have instantiated.

To do that we estimate the airtime of the packet that's about to be send 
and depending on the channel usage we decide if we let the packet flow 
or if we should enqueue or even drop it!

The problems begin when we enqueue a packet that has the txpending flag 
set (it's been in the AC queue once) and our algorithm decides to 
enqueue it again or drop the packet. The tx_pending tasklet begins to 
loop the same packet on tx_frags (stopping the tasklet for some time is 
not a slution either...). The results of enqueueing is connection  lost 
or a huge delay on some packets.

If we drop any packet in tx_frags() mac80211 goes crazy and may 
instantly drop connection and destroy the vif.

Is there any more projects I should check out that drops or enqueue 
packets on mac80211 when it's not supposed to be enqueuing?

Thanks again for your precious time!


Joan Josep Aleixendri

