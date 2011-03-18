Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:24132 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1CRUCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:02:45 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028912.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 22:01:39 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <AANLkTikQ7W4GdY=USphz3FphyS-yEwN+X+jUPwq9x_6z@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
	 <1300463392.13499.110.camel@dev.znau.edu.ua>
	 <AANLkTi=GggwyGkDB+cBG-G3O2c5WdfjCpb5pk8=3yDKz@mail.gmail.com>
	 <1300471917.14872.28.camel@dev.znau.edu.ua>
	 <AANLkTikQ7W4GdY=USphz3FphyS-yEwN+X+jUPwq9x_6z@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Mar 2011 22:01:50 +0200
Message-Id: <1300478510.15393.45.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> >> I don't see the point where my patch is in conflict with your idea.
> > Not your patch, just scan_read32, scan_switchcore, ssb_iounmap,
> > ssb_ioremap. So far ssb_core_name is fine.
> > Yet again, ssb code model is core-sentric which is not actually true
> > from the hardware pint of view. With few workarounds it works fine for
> > sb. For axi we will have more of these.
> >
> > scan_read32, scan_switchcore, ssb_iounmap, ssb_ioremap are all
> > host-driven services. In ssb model host is operating cores and therefore
> > requires all that switch, scan_read, map, unmap etc. While with model
> > where host is providing not core but backplane access the only routine
> > among those above you need is scan_read32 and nothing more (actually you
> > don't need it too as host ops with read(8|16|32) are completely
> > sufficient for scanning). The purpose of scan_read32 for ssb model is
> > that ssb_bus_ops are operating cores which you don't have at the moment
> > when scanning. With host ops designed as u32 (*read32)(struct host
> > *host, phys_addr_t addr) host will do what it supposed to - manage its
> > means of backplane physical access and will have absolutely no need to
> > break into understanding what the core/sprom/otp/etc. is.
> 
> That's what I wanted to hear from the beginning, thanks! :)
> 
> The reason I implemented scan_switchcore is early stage, when I
> prepare bus for reading EROM:
> erombase = ai_scan_read32(bus, 0, SSB_CHIPCO_EROM);
> pci_write_config_dword(bus->host_pci, PCI_BAR0_WIN, erombase);
> In above you can see my hack which works for PCI host only. This hack
> I wanted to replace with scan_switchcore and that functions seems to
> perform exactly this operation.
> 
> AFAIU we need to adjust PCI_BAR0_WIN and PCI_BAR0_WIN2 later, when we
> already have info about core from EROM. In early stage we can not use
> that.
> 
> Anyway with what you said now, I'll re-read your mails again, to fully
> understand your POV.

You still look through the prism of the ssb model. There is absolutely
nothing which prevents PCI(e) host driver to setup windowed access right
away at the _probe before even trying to feed the bcmb code with any
data for detection/scanning/etc. For more generic implementation
scan_read32 still seems to be useful one, but again you can build the
code to use regular host-provided read(8|16|32) ops for the same purpose
as initial scan_read32 as soon as they provide access in regard to
backplane physicall addresses, not cores. As for switch_core - yet again
its host service, and only windowed accesses' hosts. And in any case
host have absolutely _no_ reason to operate cores. The only thigns the
host should care of are:
 ~ provide access to backplane physicall address range;
 ~ manage buscore (mostly that part which is on the host bus side);
 ~ manage host bus interrupt(s);

Sample generic host startup:
* probe
~ initial host device power up and setup (that part of buscore core that
interconnected to host bus the host is at). For e. g. pci(e) its:
  - pci_enable_device
  - pci_request_regions
  - pci_set_master
  - pci_iomap
  - powerup (like xtal for pci)
  - host-specific workarounds (like ldo_war)
~ setup windowed access
  - read pci revision id/vendor id (pci_read_config_word), if required
to decide if second window is sliding or sprom (actually rev_id should
be sufficient for that) read offset 0x0000 from bar0 offset to get
chipid register value
  - at this point host have all the required information to decide on
amount on host-to-backplane windows available and their configuration;
  - call some bcmb_add_bus to get bus detected/scanned/whatever.

At this point scanning code is good to go with any of
bcmb_scan_read32(struct hnd_host *host, phys_addr_t addr) or
bcmb_read32(struct hnd_host *host, phys_addr_t addr) as both of them do
exactly the same.

Either bcmb_scan_read32/bcmb_read32 need window switching or not depends
on the host implementation and is part of the host code. Generic
scanning/detection/etc. code have absolutely nothing to do with window
switching. They are there in ssb because of the design decisions made
towards core-sentric implementation. Desicions which I'm sure should not
blind you while planning for new sb/ai support code.

e. g. for embeddable read implementation will be like following pseudo
code
u32 bcmb_read32(struct hnd_host *host, phys_addr_t addr)
{
	return ioread32(phys_addr_to_embedded(host, addr));
}

while for e. g. pci it could be something like next (again not a real
code, just a general idea):
u32 bcmb_read32(struct hnd_host *host, phys_addr_t addr)
{
	struct pci_win *win;
	u32;

	win = phys_addr_to_pci_win(host, addr);
	claim_win(win);
	tmp = ioread(phys_addr_to_win(win, addr);
	release_win(win);
	return tmp;
}

Have nice day,
George


