Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:42886 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbYC2QqD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 12:46:03 -0400
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200803291553.03955.IvDoorn@gmail.com>
References: <1206801246.24689.19.camel@Bas>
	 <200803291553.03955.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 17:42:21 +0100
Message-Id: <1206808941.22448.22.camel@Bas> (sfid-20080329_164613_028202_944F01B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Sat, 2008-03-29 at 15:53 +0100, Ivo van Doorn wrote:
> Hi,
> 
> > with the latest changes, I guess in particular the commit "rt2x00: Fix
> > in _atomic() usage" changing the flags for rt2500pci results in infinite
> > calls to the new "rt2x00mc_configure_filter" in rt2x00mac.c. I noticed
> > this after applying the attached patch that I've been using to debug
> > some hostapd problems. All it does is add some printk's, I don't think
> > it can cause the problem, right? 
> 
> Oops...
> I found the problem, patch coming will be released in a few minutes. :)

ok, that fixes it. Thanks!

unfortunately, I still can't get hostapd to work :( Do you have some
ideas about this Ivo? I've already discussed this a bit with Johannes,
but he couldn't find any obvious problems. It seems that EAPOL keys sent
from my laptop to hostapd (running on the rt2500pci) don't arrive. Only
when switching wlan1 to promiscuous, they arrive. Unfortunately then
hostapd hangs (perhaps to unrelated things, perhaps due to the fact that
wlan1 is promiscuous, I don't know.).

Here are some logs:

hostapd, without wlan1 set to promiscuous:
--------------------------------------------------------------------
wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
STA 00:1b:77:a4:db:26 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
wlan1: STA 00:1b:77:a4:db:26 WPA: EAPOL-Key timeout
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKSTART
wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
wlan1: STA 00:1b:77:a4:db:26 WPA: EAPOL-Key timeout
--------------------------------------------------------------------
this repeats for a while, all the time giving EAPOL-Key timeout
messages. tetherial -i mon.wlan1 on the hostapd machine shows that no
EAPOL key's are received, while tetherial on the laptop shows that they
are being sent.

this is the flag status when running hostapd; as printed with
printk(KERN_INFO "rt2500pci filter_flags: %d\n",
rt2x00dev->packet_filter);

rt2500pci filter_flags: 2
rt2500pci MAC changed: 00:0c:f6:14:05:19

hostapd, with wlan1 set to promiscuous:
--------------------------------------------------------------------
authentication: STA=00:1b:77:a4:db:26 auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan1: STA 00:1b:77:a4:db:26 IEEE 802.11: authentication OK (open
system)
wlan1: STA 00:1b:77:a4:db:26 MLME:
MLME-AUTHENTICATE.indication(00:1b:77:a4:db:26, OPEN_SYSTEM)
wlan1: STA 00:1b:77:a4:db:26 MLME:
MLME-DELETEKEYS.request(00:1b:77:a4:db:26)
authentication reply: STA=00:1b:77:a4:db:26 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
MGMT (TX callback) ACK
mgmt::auth cb
wlan1: STA 00:1b:77:a4:db:26 IEEE 802.11: authenticated
MGMT
mgmt::assoc_req
association request: STA=00:1b:77:a4:db:26 capab_info=0x411
listen_interval=10
WME IE - hexdump(len=7): 00 50 f2 02 00 01 00
Validating WME IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
  new AID 1
wlan1: STA 00:1b:77:a4:db:26 IEEE 802.11: association OK (aid 1)
MGMT (TX callback) ACK
mgmt::assoc_resp cb
wlan1: STA 00:1b:77:a4:db:26 IEEE 802.11: associated (aid 1, accounting
session 47EE6A5B-00000004)
wlan1: STA 00:1b:77:a4:db:26 MLME:
MLME-ASSOCIATE.indication(00:1b:77:a4:db:26)
wlan1: STA 00:1b:77:a4:db:26 MLME:
MLME-DELETEKEYS.request(00:1b:77:a4:db:26)
wlan1: STA 00:1b:77:a4:db:26 WPA: event 1 notification
wlan1: STA 00:1b:77:a4:db:26 WPA: start authentication
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state INITIALIZE
wlan1: STA 00:1b:77:a4:db:26 IEEE 802.1X: unauthorizing port
WPA: 00:1b:77:a4:db:26 WPA_PTK_GROUP entering state IDLE
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state AUTHENTICATION
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state AUTHENTICATION2
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state INITPSK
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKSTART
wlan1: STA 00:1b:77:a4:db:26 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=1 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 125 bytes from 00:1b:77:a4:db:26
   IEEE 802.1X: version=1 type=3 length=121
wlan1: STA 00:1b:77:a4:db:26 WPA: received EAPOL-Key frame (2/4
Pairwise)
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:0c:f6:14:05:19 A2=00:1b:77:a4:db:26
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=64): [REMOVED]
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKINITNEGOTIATING
--------------------------------------------------------------------
after this, hostapd hangs, and after ctrl-C it outputs this:
--------------------------------------------------------------------
eloop: could not process SIGINT or SIGTERM in two seconds. Looks like
there
is a bug that ends up in a busy loop that prevents clean shutdown.
Killing program forcefully.
--------------------------------------------------------------------
the flag status; as printed with printk(KERN_INFO "rt2500pci
filter_flags: %d\n", rt2x00dev->packet_filter);

when wlan1 is promiscuous:
device mon.wlan1 entered promiscuous mode
rt2500pci filter_flags: 67
device mon.wlan1 left promiscuous mode
rt2500pci filter_flags: 2

so obviously authentication get's a lot further with wlan1 in
promiscuous mode, and EAPOL keys sent from the laptop are being
received. Any clues as to why this happens? Is 2 (00000010B) the correct
flag status? Or 67 (01000011B). Hope you can see what's going wrong
here.. I don't even know if the issue is with rt2x00 or somewhere else,
although Johannes can use hostapd on a broadcom chipset.

thanks a lot for your help,

Bas

> 
> Ivo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

