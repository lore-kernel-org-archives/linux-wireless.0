Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Gamera.Varna.Net ([217.145.80.8]:60460 "EHLO Gamera.varna.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbeIJPUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 11:20:21 -0400
Received: from [10.43.12.111] (nat-pool-brq-t.redhat.com [213.175.37.10])
        (authenticated bits=0)
        by Gamera.varna.net (8.15.2/8.15.2) with ESMTPSA id w8AAQpJq030899
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2018 13:26:54 +0300
To: linux-wireless@vger.kernel.org
From: Pavlin Georgiev <pavlin@varna.net>
Subject: Troubleshooting hostapd and TLS authentication
Message-ID: <f3edd32c-a62b-5105-db2c-51ebdc49bf83@varna.net> (sfid-20180910_122701_445235_F0A5C941)
Date: Mon, 10 Sep 2018 12:26:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hI,

I would like to test network connection
between simulated Wi-Fi access point and a station by using hostapd.

Both reside on the same tesing machine which does not have Wi-Fi adapter.
I would like to test 802.1x + TLS authentication.


When I run hostapd
then I see error message:
OpenSSL: tls_read_pkcs12 - Failed to use PKCS#12 file 
error:0D0680A8:asn1 encoding routines:ASN1_CHECK_TLEN:wrong tag
OpenSSL: pending error: error:0D07803A:asn1 encoding 
routines:ASN1_ITEM_EX_D2I:nested asn1 error
OpenSSL: tls_global_private_key - Failed to load private key 
error:00000000:lib(0):func(0):reason(0)
TLS: Failed to set global parameters
Failed to set TLS parameters


DETAILS
Distro: RHEL 7.6 Beta

kernel-3.10.0-933.el7.x86_64
NetworkManager-1.12.0-2.el7.x86_64
hostapd-2.6-7.el7.x86_64
openssl-1.0.2k-15.el7.x86_64
wpa_supplicant-2.6-11.el7.x86_64

The simulated AP has interface "wlan1".
The simulated station has "wlan0".


hostapd's CONFIGURATION
# Hostapd configuration for 802.1x client testing
interface=wlan1
driver=nl80211
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=wpa2-eap
country_code=EN
hw_mode=g
channel=7
auth_algs=3
wpa=3
ieee8021x=1
eapol_version=1
wpa_key_mgmt=WPA-EAP WPA-PSK
wpa_passphrase=secret123
eap_reauth_period=3600
eap_server=1
use_pae_group_addr=1
eap_user_file=/etc/hostapd/hostapd.eap_user
ca_cert=/etc/hostapd/ssl/hostapd.ca.pem
dh_file=/etc/hostapd/ssl/hostapd.dh.pem
server_cert=/etc/hostapd/ssl/hostapd.cert.pem
private_key=/etc/hostapd/ssl/hostapd.key.pem
private_key_passwd=redhat


All mentioned certificates exist on the testing machine.
Server certificate and private key match.


CONTENTS OF /etc/hostapd/hostapd.eap_user
# Create hostapd peap user file
# Phase 1 authentication
"user"   MD5     "password"
"test"   TLS,TTLS,PEAP
# Phase 2 authentication (tunnelled within EAP-PEAP or EAP-TTLS)
"TESTERS\test_mschapv2"   MSCHAPV2    "password"  [2]
"test_md5"       MD5         "password"  [2]
"test_gtc"       GTC         "password"  [2]
# Tunneled TLS and non-EAP authentication inside the tunnel.
"test_ttls"      TTLS-PAP,TTLS-CHAP,TTLS-MSCHAP,TTLS-MSCHAPV2 
"password"  [2]


QUESTIONS
1. Are there any errors in the hostapd's configuration?
2. Is the error after start due to certificates?
3. Is the error due to OpenSSL on the testing machine?


Thanks
Pavlin
