Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34288
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXKFT2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:28:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC 6 of 6] ssb: Remove the old, now unused, data structure
Date: Tue, 6 Nov 2007 20:26:58 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4730bdac.Oup0h41hJ0GHVCxr%Larry.Finger@lwfinger.net>
In-Reply-To: <4730bdac.Oup0h41hJ0GHVCxr%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711062026.58650.mb@bu3sch.de> (sfid-20071106_192804_933248_CEF2B634)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 November 2007 20:17:00 Larry Finger wrote:
> Patch 6 of 6.
> 
> The old, now unused, data structures and SPROM extraction routines
> are removed.
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-2.6/include/linux/ssb/ssb.h
> ===================================================================
> --- wireless-2.6.orig/include/linux/ssb/ssb.h
> +++ wireless-2.6/include/linux/ssb/ssb.h
> @@ -15,69 +15,6 @@ struct pcmcia_device;
>  struct ssb_bus;
>  struct ssb_driver;
>  
> -
> -struct ssb_sprom_r1 {
> -	u16 pci_spid;		/* Subsystem Product ID for PCI */
> -	u16 pci_svid;		/* Subsystem Vendor ID for PCI */
> -	u16 pci_pid;		/* Product ID for PCI */
> -	u8 il0mac[6];		/* MAC address for 802.11b/g */
> -	u8 et0mac[6];		/* MAC address for Ethernet */
> -	u8 et1mac[6];		/* MAC address for 802.11a */
> -	u8 et0phyaddr:5;	/* MII address for enet0 */
> -	u8 et1phyaddr:5;	/* MII address for enet1 */
> -	u8 et0mdcport:1;	/* MDIO for enet0 */
> -	u8 et1mdcport:1;	/* MDIO for enet1 */
> -	u8 board_rev;		/* Board revision */
> -	u8 country_code:4;	/* Country Code */
> -	u8 antenna_a:2;		/* Antenna 0/1 available for A-PHY */
> -	u8 antenna_bg:2;	/* Antenna 0/1 available for B-PHY and G-PHY */
> -	u16 pa0b0;
> -	u16 pa0b1;
> -	u16 pa0b2;
> -	u16 pa1b0;
> -	u16 pa1b1;
> -	u16 pa1b2;
> -	u8 gpio0;		/* GPIO pin 0 */
> -	u8 gpio1;		/* GPIO pin 1 */
> -	u8 gpio2;		/* GPIO pin 2 */
> -	u8 gpio3;		/* GPIO pin 3 */
> -	u16 maxpwr_a;		/* A-PHY Power Amplifier Max Power (in dBm Q5.2) */
> -	u16 maxpwr_bg;		/* B/G-PHY Power Amplifier Max Power (in dBm Q5.2) */
> -	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
> -	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
> -	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
> -	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
> -	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
> -	u8 oem[8];		/* OEM string (rev 1 only) */
> -};
> -
> -struct ssb_sprom_r2 {
> -	u16 boardflags_hi;	/* Boardflags (high 16 bits) */
> -	u8 maxpwr_a_lo;		/* A-PHY Max Power Low */
> -	u8 maxpwr_a_hi;		/* A-PHY Max Power High */
> -	u16 pa1lob0;		/* A-PHY PA Low Settings */
> -	u16 pa1lob1;		/* A-PHY PA Low Settings */
> -	u16 pa1lob2;		/* A-PHY PA Low Settings */
> -	u16 pa1hib0;		/* A-PHY PA High Settings */
> -	u16 pa1hib1;		/* A-PHY PA High Settings */
> -	u16 pa1hib2;		/* A-PHY PA High Settings */
> -	u8 ofdm_pwr_off;	/* OFDM Power Offset from CCK Level */
> -	u8 country_str[2];	/* Two char Country Code */
> -};
> -
> -struct ssb_sprom_r3 {
> -	u32 ofdmapo;		/* A-PHY OFDM Mid Power Offset */
> -	u32 ofdmalpo;		/* A-PHY OFDM Low Power Offset */
> -	u32 ofdmahpo;		/* A-PHY OFDM High Power Offset */
> -	u8 gpioldc_on_cnt;	/* GPIO LED Powersave Duty Cycle ON count */
> -	u8 gpioldc_off_cnt;	/* GPIO LED Powersave Duty Cycle OFF count */
> -	u8 cckpo_1M:4;		/* CCK Power Offset for Rate 1M */
> -	u8 cckpo_2M:4;		/* CCK Power Offset for Rate 2M */
> -	u8 cckpo_55M:4;		/* CCK Power Offset for Rate 5.5M */
> -	u8 cckpo_11M:4;		/* CCK Power Offset for Rate 11M */
> -	u32 ofdmgpo;		/* G-PHY OFDM Power Offset */
> -};
> -
>  struct ssb_sprom_data {
>  	u8 il0mac[6];		/* MAC address for 802.11b/g */
>  	u8 et0mac[6];		/* MAC address for Ethernet */
> @@ -109,16 +46,6 @@ struct ssb_sprom_data {
>  struct ssb_sprom {
>  	u8 revision;
>  	u8 crc;
> -	/* The valid r# fields are selected by the "revision".
> -	 * Revision 3 and lower inherit from lower revisions.
> -	 */
> -	union {
> -		struct {
> -			struct ssb_sprom_r1 r1;
> -			struct ssb_sprom_r2 r2;
> -			struct ssb_sprom_r3 r3;
> -		};
> -	};
>  	struct ssb_sprom_data data;
>  };


I'd also like to get rid of the "revision" and "crc" fields, as they
are of no use to drivers. So you can rename struct ssb_sprom_data
to struct ssb_sprom and remove the old struct ssb_sprom.

If that creates problems with merging (bisect), just create one big patch.
I like big patches more than hundreds of small ones that change this
and that and in the end revert everything, just for the sake of
having multiple patches. :)

-- 
Greetings Michael.
