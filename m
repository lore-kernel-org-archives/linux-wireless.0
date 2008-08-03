Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57952 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbYHCApY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:45:24 -0400
Message-ID: <4894FF97.7040600@imap.cc> (sfid-20080803_024603_007202_7A7F8757)
Date: Sun, 03 Aug 2008 02:45:11 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: me@felipebalbi.com
CC: Eugeniy Meshcheryakov <eugen@debian.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc> <20080802082851.GB8213@frodo> <4894D86A.6030108@imap.cc> <20080802231201.GB23361@frodo>
In-Reply-To: <20080802231201.GB23361@frodo>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31A778FAD9BEC90EA3DC52F4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31A778FAD9BEC90EA3DC52F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Aug 2008 02:12:06 +0300, Felipe Balbi wrote:
> hmm... what does lsusb -v -d 057c:6201 reports to you ?

compaq:/home/ts # lsusb -vvd 057c:

Bus 002 Device 002: ID 057c:6201 AVM GmbH WLAN USB v1.1
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x057c AVM GmbH
  idProduct          0x6201 WLAN USB v1.1
  bcdDevice            1.00
  iManufacturer           3=20
  iProduct                2=20
  iSerial                 1 TI964E1FA4C100TNETW
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  bNumConfigurations      0
Device Status:     0x0000
  (Bus Powered)
compaq:/home/ts #=20

>> The device was reported in iwconfig as:
>>
>> wlan0     IEEE 802.11b+/g+  ESSID:"STAF1E469"  Nickname:"acx v0.3.37"
>>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associa=
ted  =20
>>           Bit Rate:54 Mb/s   Tx-Power=3D15 dBm  =20
>>           Retry min limit:7   RTS thr:off  =20
>>           Encryption key:off
>>           Power Management:off
>>           Link Quality:0  Signal level:0  Noise level:0
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>
>> but didn't work. In particular "iwlist wlan0 scan" failed with the mes=
sage:
>>
>> wlan0     Interface doesn't support scanning : Resource temporarily un=
available
>=20
> Did you try setting the parameters by hand ?
>=20
> # iwconfig wlan0 essid <ESSID> key <KEY>
>=20
> and then
>=20
> # dhclient wlan0

compaq:/home/ts # iwconfig wlan0 essid MYESSID
compaq:/home/ts # iwconfig wlan0
wlan0     IEEE 802.11b+/g+  ESSID:"MYESSID"  Nickname:"acx v0.3.37"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated=
  =20
          Bit Rate:54 Mb/s   Tx-Power=3D15 dBm  =20
          Retry min limit:7   RTS thr:off  =20
          Encryption key:off
          Power Management:off
          Link Quality=3D0/100  Signal level=3D100/100  Noise level=3D100=
/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

compaq:/home/ts # iwlist wlan0 scan
wlan0     No scan results

compaq:/home/ts #=20

Next step would be running wpa_supplicant, because my WLAN uses WPA, but:=


# wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf=


rapidly floods my console with messages

ioctl[SIOCSIWENCODEEXT]: Operation not supported
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

and the syslog with

Aug  3 01:55:47 compaq kernel: get_mask 0x00000000, set_mask 0x00040000
Aug  3 01:55:47 compaq kernel: important setting has been changed. Need t=
o update packet templates, too
Aug  3 01:55:47 compaq kernel: updating packet templates
Aug  3 01:55:47 compaq kernel: updating WEP key settings
Aug  3 01:55:47 compaq kernel: setting WEP key 0 as default
Aug  3 01:55:47 compaq kernel: acx_set_status(1):SCANNING
Aug  3 01:55:47 compaq kernel: start_scan: seems like previous scan is st=
ill running. Not starting anew. Please report
Aug  3 01:55:47 compaq kernel: get_mask 0x00000000, set_mask 0x00000000 -=
 after update

until I hit ctrl/C.

# dhclient wlan0

just repeats

DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 5

a couple of times with increasing interval values and finally tells me

No DHCPOFFERS received.
No working leases in persistent database - sleeping.

> It's probably affected by timing as well. That driver sure needs some
> rework.

Yeah, looks like it. I posted a report to the project's Sourceforge
"ACX100 USB" forum, too.

Thanks,
Tilman


--------------enig31A778FAD9BEC90EA3DC52F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIlP+gQ3+did9BuFsRAmbvAKCHDA8IssK2zlz61ksbI3cw4W22XACdHzZh
VDAD0bi/nJ00nd2tINhRqS8=
=bsyt
-----END PGP SIGNATURE-----

--------------enig31A778FAD9BEC90EA3DC52F4--
