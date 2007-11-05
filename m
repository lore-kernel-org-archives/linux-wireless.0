Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39509
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXKEMxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 07:53:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC] ssb: Add code for SPROM Rev 4
Date: Mon, 5 Nov 2007 13:51:37 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <472c9192.8nd7AOTgl+jWptik%Larry.Finger@lwfinger.net>
In-Reply-To: <472c9192.8nd7AOTgl+jWptik%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711051351.37252.mb@bu3sch.de> (sfid-20071105_125352_206472_AB8C7A5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 November 2007 16:19:46 Larry Finger wrote:
> The BCM4328 has a revision 4 SPROM. The necessary changes to handle the
> layout and different size of this revision are implemented. The size of
> the SPROM is now stored in the ssb_bus struct and used from that location
> whenever possible. For those routines that need the size, but do not have
> access to that struct, a size argument is added.
> 
> Recognition of the PCI_ID of the BCM4328 is also implemented. Note that
> the PCI_ID is 0x4328, but the chipid is 0x4321.
> 
> This code has been tested by Michael Gerdau <mgerdau@tiscali.de>.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---


> Index: wireless-2.6/include/linux/ssb/ssb.h
> ===================================================================
> --- wireless-2.6.orig/include/linux/ssb/ssb.h
> +++ wireless-2.6/include/linux/ssb/ssb.h
> @@ -79,7 +79,39 @@ struct ssb_sprom_r3 {
>  };
>  
>  struct ssb_sprom_r4 {
> -	/* TODO */
> +	u16 pci_spid;		/* Subsystem Product ID for PCI */
> +	u16 pci_svid;		/* Subsystem Vendor ID for PCI */
> +	u16 pci_pid;		/* Product ID for PCI */
> +	u8 il0mac[6];		/* MAC address for 802.11b/g */
> +	u8 et0mac[6];		/* MAC address for Ethernet */
> +	u8 et1mac[6];		/* MAC address for 802.11a */
> +	u8 et0phyaddr:5;	/* MII address for enet0 */
> +	u8 et1phyaddr:5;	/* MII address for enet1 */
> +	u8 et0mdcport:1;	/* MDIO for enet0 */
> +	u8 et1mdcport:1;	/* MDIO for enet1 */
> +	u8 board_rev;		/* Board revision */
> +	u8 country_code:4;	/* Country Code */
> +	u8 antenna_a:2;		/* Antenna 0/1 available for A-PHY */
> +	u8 antenna_bg:2;	/* Antenna 0/1 available for B-PHY and G-PHY */
> +	u16 pa0b0;
> +	u16 pa0b1;
> +	u16 pa0b2;
> +	u16 pa1b0;
> +	u16 pa1b1;
> +	u16 pa1b2;
> +	u8 gpio0;		/* GPIO pin 0 */
> +	u8 gpio1;		/* GPIO pin 1 */
> +	u8 gpio2;		/* GPIO pin 2 */
> +	u8 gpio3;		/* GPIO pin 3 */
> +	u16 maxpwr_a;		/* A-PHY Amplifier Max Power (in dBm Q5.2) */
> +	u16 maxpwr_bg;		/* B/G-PHY Amplifier Max Power (in dBm Q5.2) */
> +	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
> +	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
> +	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
> +	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
> +	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
> +	/* The variables above this point must match those of ssb_sprom_r1 */
> +	/* TODO - add any special ssb_sprom_r4 variables below this point. */
>  };
>  
>  struct ssb_sprom {
> @@ -288,6 +320,7 @@ struct ssb_bus {
>  	/* ID information about the Chip. */
>  	u16 chip_id;
>  	u16 chip_rev;
> +	u16 sprom_size;		/* number of words in sprom */
>  	u8 chip_package;
>  
>  	/* List of devices (cores) on the backplane. */

Larry, I did not forget your patch.
But I need to think a little bit more about this.

The union above is not really what I'd like to have here. In fact,
I think to get the v4 sprom implemented the sprom struct has to be
redesigned.

I think we must leave the path of partitioning the sprom struct into
versions, because that obviously doesn't work anymore.
Instead, I think we must develop _one_ common struct that is capable
of holding the information from any sprom. (Note that the struct layout
does not need to reflect the real hardware layout).

And I think we should also remove the fields that are not needed at all,
like the PCI ID stuff.

something like this:


struct ssb_sprom_pathvar {
	bool this_pathvar_is_available;

	...foobar data
};

struct ssb_sprom {
	u8 wl_mac_addr[ETH_ALEN];
	u8 eth0_mac_addr[ETH_ALEN];
	u8 eth1_mac_addr[ETH_ALEN];

	...

	u8 gpio0;
	u8 gpio1;
	...

	antennagain...

	struct ssb_sprom_pathvar pv0;
	struct ssb_sprom_pathvar pv1;
	...
};

Note that I did _not_ look closely at the pathvar stuff, so this
might be a bad idea to design it this way.
But the point I was going to make with that was; we probably need
some "this data is valid" bits for different parts of the sprom
struct, as for example v1-3 don't have these pathvars (So the drivers
must be told it's invalid data).
The reason for all this "valid-bit" stuff is that I think we should
remove any sprom-versioning knowledge from the drivers. That
should be abstracted.

Any idea on how to improve that?

-- 
Greetings Michael.
