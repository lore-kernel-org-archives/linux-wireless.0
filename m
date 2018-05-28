Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:51678 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162007AbeE1OVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 10:21:17 -0400
Date: Mon, 28 May 2018 15:54:33 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kofi Agor <nenekofi@gmail.com>, Enrico Mioso <mrkiko.rs@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>,
        lede-dev@lists.infradead.org
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180528135432.GA1139@makrotopia.org> (sfid-20180528_162146_652902_D892FCF2)
References: <20180327174302.GB1206@makrotopia.org>
 <alpine.LNX.2.21.99.1803280605580.2911@mStation.localdomain>
 <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
 <20180528125039.GA22122@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528125039.GA22122@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Mon, May 28, 2018 at 02:50:40PM +0200, Stanislaw Gruszka wrote:
> I have some updates here.
> 
> ...
> Another issue is that sometimes we do not sent rate probe frames,
> I posted fix for that (revert of my older change):
> https://marc.info/?l=linux-wireless&m=152750671715369&w=2 
> This patch improve performance when mt7620 is connected with Intel iwl7265
> device. With the patch I have 70 Mbits/sec compared to about 17 Mbits/sec
> before. Perhaps it also fix stability issues.

Oh goodness, I didn't expect anything like that to still happen at
this stage. Thanks a lot for investigating the issue!
I've imported the patch to OpenWrt git:
https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=f4a639a3d7d40b4f63c431c2d554c479fbcc6b74

Once we got some feedback from users (please test!) we can push that
also to still be part of the openwrt-18.06 release.

Cheers

Daniel
