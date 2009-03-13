Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:41790 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZCMDbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:31:07 -0400
Received: by gxk11 with SMTP id 11so2582996gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:31:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236742805.6267.9.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
Date: Thu, 12 Mar 2009 23:31:04 -0400
Message-ID: <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com> (sfid-20090313_043119_027055_6C06990B)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 11:40 PM, Jason Andryuk <jandryuk@gmail.com> wr=
ote:
>> You log below has a new error (similar to what you note in your next
>> email). "Unsupported interface type 515". This is very strange and
>> really looks like some corruption as this value is initialized with =
a
>> macro during probe. Could you enable mac and info debugging also (ad=
d
>> 0x3 to your current debug flags)? This code has also changed a bit s=
ince
>> commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d.
>>
>> You can also put a dump_stack() in iwl3945_connection_init_rx_config=
 to
>> see where the call comes from and then trace the value of mode to se=
e
>> where it is set to 515 ... it is supposed to be 2
>> (NL80211_IFTYPE_STATION).
>
> See logs below. =A0I ran with debug=3D0x40003. =A0This is on commit
> "ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f iwl3945: sync tx queue data
> structure with iwlagn" with my patches to make it somewhat usable.
>
>> I am finding it hard to keep track of things as what works and what =
does
>> not work appears to shift. I did install a 64bit system in the hopes=
 of
>> reproducing your issue but could not with a basic open connect. How =
do
>> you connect to the AP? Please provide details that you think will en=
able
>> me to reproduce.
>
> The problem is that as I try older commits to find which one introduc=
ed
> the original error, I find other problems that need to be solved.
> Hopefully I have finally tracked down the commit,
> "ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f iwl3945: sync tx queue data
> structure with iwlagn", that introduced the Microcode SW errors.

Looking at ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f, I found the call
to iwl_reset_qos corrupts priv->iw_mode.  It is 2 before the call and
515 after.

I dumped priv for 32 bytes starting at &priv->last_beacon_time and saw =
this.
iwl data: 00000000: 00 0f 00 ff 03 02 00 00 00 0f 00 ff 03 02 00 00
=2E...............
iwl data: 00000010: 00 0f 00 ff 03 02 00 00 00 0f 00 ff 03 02 00 00
=2E...............

515 =3D 0x0203 =3D 03 02 little endian

We have

struct iwl_ac_qos {
        __le16 cw_min;
        __le16 cw_max;
        u8 aifsn;
        u8 reserved1;
        __le16 edca_txop;
} __attribute__ ((packed));

and

	priv->qos_data.def_qos_parm.ac[0].cw_min =3D cpu_to_le16(cw_min);
	priv->qos_data.def_qos_parm.ac[0].cw_max =3D cpu_to_le16(cw_max);
        priv->qos_data.def_qos_parm.ac[0].aifsn =3D aifs;
        priv->qos_data.def_qos_parm.ac[0].edca_txop =3D 0;
        priv->qos_data.def_qos_parm.ac[0].reserved1 =3D 0;

and
	u16 cw_min =3D 15;      // 0x000f
        u16 cw_max =3D 1023; // 0x03ff
        u8 aifs =3D 2;                //0x02

Which corresponds to the dump and what is showing up in iw_mode.

I don't know why things are going wrong though.

One problem I see is the check of staging_rxon instead of
staging39_rxon in iwl_reset_qos.
(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) =3D=3D 0)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
