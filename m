Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F7EC43444
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 14:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4C620657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 14:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="ZvaqGjRi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbfAPOLf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:11:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54078 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733044AbfAPOLf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 09:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e3bKsXQGIOH+M3/5nvt5URusOdZ8K03R5wypNKNs35I=; b=ZvaqGjRijLC+2ke5PBVsrm/8V
        MM0UOBxe15E+HCRd4RzDo1yYWslOQHstbm1qx2SKmjp3SGZKO+zlR+Gmqv19zNli/s/2j1S343PbB
        nFKVGF65TT3SwstDDT0h2JhVkiuKNzy7OXX79Jx28+pbAn7Nsm7JRx0ZlDo9U0M8EboVY=;
Received: from e5254000004ec.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54886 helo=shell.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gjluj-00041z-0S; Wed, 16 Jan 2019 14:11:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1gjlui-0006Er-B4; Wed, 16 Jan 2019 14:11:28 +0000
Date:   Wed, 16 Jan 2019 14:11:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190116141128.rwl3bzbu7clzomn5@e5254000004ec.dyn.armlinux.org.uk>
References: <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
 <20190111141543.GA2392@n2100.armlinux.org.uk>
 <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
 <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
 <c33521df-9b75-49c8-1bfa-67ff6e7a8b74@broadcom.com>
 <20190116125149.mm3vviqgbfovtxak@e5254000004ec.dyn.armlinux.org.uk>
 <c4a0053e-5312-1b1f-68c9-ef58642698fa@broadcom.com>
 <20190116135643.bomtxuwljjcusxxf@e5254000004ec.dyn.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190116135643.bomtxuwljjcusxxf@e5254000004ec.dyn.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 16, 2019 at 01:56:43PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Jan 16, 2019 at 02:21:32PM +0100, Arend Van Spriel wrote:
> > On 1/16/2019 1:51 PM, Russell King - ARM Linux admin wrote:
> > > On Wed, Jan 16, 2019 at 01:08:21PM +0100, Arend Van Spriel wrote:
> > > > On 1/16/2019 1:12 AM, Russell King - ARM Linux admin wrote:
> > > > > On Mon, Jan 14, 2019 at 12:49:09PM +0100, Arend Van Spriel wrote:
> > > > > > Could you try the compile and load test I suggested earlier. I will try to
> > > > > > replicate things over here as well.
> > > > > 
> > > > > I'm not sure that helps:
> > > > > 
> > > > > [588980.874745] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 286 expected 286
> > > > > [588980.875776] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 281 expected 281
> > > > > [588980.876925] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 2064 expected 2064
> > > > > [589095.542690] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > > > > [589098.262719] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> > > > > [589100.822465] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
> > > > > [589101.814313] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > > > > [589104.410194] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> > > > > [589106.970045] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
> > > > > [589109.530191] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
> > > > > [589110.322685] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > > [601235.163954] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> > > > > [601245.240024] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > > [601264.207886] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > > ...
> > > > > [605377.238304] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > > [605395.118751] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > > [605412.976951] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
> > > > 
> > > > So actually it shows me that we are not getting responses. That and the
> > > > pend8021x is starting to look pretty fishy, but lacking console messages may
> > > > be build issue that I explain further down.
> > > > 
> > > > > Looking at the time the messages (at 589095.542690) are produced, what
> > > > > seems to cause this is when I head out with my LineageOS (TI WiLink
> > > > > based) phone to the car and drive off.  I've suspected that's the case
> > > > > with all the previous iterations of this problem too.
> > > > > 
> > > > > At this point, the LineageOS phone is completely unable to reassociate
> > > > > with the AP, but it can see the AP with varying amounts of signal - it
> > > > > shows medium signal, which drops to nothing when it tries to associate.
> > > > > As soon as it stops, the indicated signal seems to come back... not
> > > > > sure if that's a LineageOS thing or something that is really happening
> > > > > on the Broadcom side.
> > > > > 
> > > > > It looks to me like the older firmware is not happy about a station
> > > > > disappearing off into the distance... surely I can't be the only one
> > > > > who takes an associated station out of range of a BRCM4330 in hostap
> > > > > mode?
> > > > 
> > > > Thanks. Always good to have a scenario to trigger it. I tried setting it up
> > > > over here. Everything looks fine but my stations don't see any beacons
> > > > coming from it :-(
> > > > 
> > > > > I don't seem to have any messages from the firmware, and I can't find
> > > > > anything useful under /sys/kernel/debug for the driver - the only
> > > > > thing I have is:
> > > > > 
> > > > > # tree /sys/kernel/debug/ieee80211/phy5
> > > > > /sys/kernel/debug/ieee80211/phy5
> > > > > ├── features
> > > > > ├── fragmentation_threshold
> > > > > ├── fwcap
> > > > > ├── fws_stats
> > > > > ├── ht40allow_map
> > > > > ├── long_retry_limit
> > > > > ├── revinfo
> > > > > ├── rts_threshold
> > > > > └── short_retry_limit
> > > > 
> > > > That is weird. For SDIO it should also have three additional files:
> > > > 
> > > > forensics
> > > > counters
> > > > console_interval
> > > > 
> > > > The fact that these are absent suggests that sdio.c was not build with DEBUG
> > > > define. How do you build the brcmfmac driver?
> > > 
> > > With a split build tree, and brcmfmac as a module.  I've just moved
> > > drivers/net/broadcom/brcm80211 out of the way and re-built with verbose
> > > mode enabled.  The gcc lines show that they are indeed passed -DDEBUG.
> > > 
> > > If I look inside the sdio.o object, I do find the strings:
> > > 
> > > intrcount:    %u
> > > lastintrs:    %u
> > > pollcnt:      %u
> > > regfails:     %u
> > > 
> > > which are from brcmf_debugfs_sdio_count_read(), and is only built when
> > > DEBUG is defined - so the build looks correct.  I also find this in the
> > > module I have on the target system, so it too was indeed built with
> > > -DDEBUG as intended.
> > > 
> > > Nope, your debugfs support can't possibly work for anyone in 4.20.
> > > 
> > > sdio.c sets up the debugfs stuff in brcmf_sdio_debugfs_create() which
> > > wants wiphy->debugfsdir.  This is called via brcmf_bus_preinit() from
> > > brcmf_sdio_bus_preinit().  This happens before brcmf_cfg80211_attach().
> > > 
> > > This is the key point - brcmf_cfg80211_attach() calls wiphy_register(),
> > > which is where the wiphy's debugfs directory is setup:
> > > 
> > >          /* add to debugfs */
> > >          rdev->wiphy.debugfsdir =
> > >                  debugfs_create_dir(wiphy_name(&rdev->wiphy),
> > >                                     ieee80211_debugfs_dir);
> > > 
> > > Consequently, at the time when brcmf_sdio_debugfs_create() is called,
> > > the debugfs directory has not been setup, so the function merely
> > > returns.
> > 
> > The patch below works for me so can you provide the counters file contents
> > after hitting the issue.
> 
> Thanks, it'll probably be a couple of days before I can get anything -
> no time to rebuild the kernel today.

Hmm, also the patch can't be easily applied:

Content-Type: text/plain; charset=utf-8; format=flowed
                                         ^^^^^^^^^^^^^
basically is an excuse for email programs to break patches when
inserted inline in the email body, by wrapping and changing the
number of space characters at the start of lines.  It's fixable by
the recipient if they are prepared to manually edit almost every
line of the patch and run the result through patch --dry-run a
few times until it applies...

Maybe send patches as plain text attachments?

> > 
> > Regards,
> > Arend
> > ---
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> > b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> > index c496518..3d441c5 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> > @@ -90,6 +90,7 @@ struct brcmf_bus_ops {
> >  	int (*get_memdump)(struct device *dev, void *data, size_t len);
> >  	int (*get_fwname)(struct device *dev, const char *ext,
> >  			  unsigned char *fw_name);
> > +	void (*debugfs_create)(struct device *dev);
> >  };
> > 
> > 
> > @@ -235,6 +236,15 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, const
> > char *ext,
> >  	return bus->ops->get_fwname(bus->dev, ext, fw_name);
> >  }
> > 
> > +static inline
> > +void brcmf_bus_debugfs_create(struct brcmf_bus *bus)
> > +{
> > +	if (!bus->ops->debugfs_create)
> > +		return;
> > +
> > +	return bus->ops->debugfs_create(bus->dev);
> > +}
> > +
> >  /*
> >   * interface functions from common layer
> >   */
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > index 7c1da1f..463754a 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > @@ -1104,6 +1104,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr,
> > struct cfg80211_ops *ops)
> >  	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
> >  	brcmf_feat_debugfs_create(drvr);
> >  	brcmf_proto_debugfs_create(drvr);
> > +	brcmf_bus_debugfs_create(bus_if);
> > 
> >  	return 0;
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > index 0cd5b8d..5f9de61 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > @@ -3143,9 +3143,12 @@ static int brcmf_debugfs_sdio_count_read(struct
> > seq_file *seq, void *data)
> >  	return 0;
> >  }
> > 
> > -static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
> > +static void brcmf_sdio_debugfs_create(struct device *dev)
> >  {
> > -	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
> > +	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> > +	struct brcmf_pub *drvr = bus_if->drvr;
> > +	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> > +	struct brcmf_sdio *bus = sdiodev->bus;
> >  	struct dentry *dentry = brcmf_debugfs_get_devdir(drvr);
> > 
> >  	if (IS_ERR_OR_NULL(dentry))
> > @@ -3165,7 +3168,7 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio
> > *bus)
> >  	return 0;
> >  }
> > 
> > -static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
> > +static void brcmf_sdio_debugfs_create(struct device *dev)
> >  {
> >  }
> >  #endif /* DEBUG */
> > @@ -3477,8 +3480,6 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
> >  	if (bus->rxbuf)
> >  		bus->rxblen = value;
> > 
> > -	brcmf_sdio_debugfs_create(bus);
> > -
> >  	/* the commands below use the terms tx and rx from
> >  	 * a device perspective, ie. bus:txglom affects the
> >  	 * bus transfers from device to host.
> > @@ -4088,6 +4089,7 @@ int brcmf_sdio_get_fwname(struct device *dev, const
> > char *ext, u8 *fw_name)
> >  	.get_ramsize = brcmf_sdio_bus_get_ramsize,
> >  	.get_memdump = brcmf_sdio_bus_get_memdump,
> >  	.get_fwname = brcmf_sdio_get_fwname,
> > +	.debugfs_create = brcmf_sdio_debugfs_create
> >  };
> > 
> >  #define BRCMF_SDIO_FW_CODE	0
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
