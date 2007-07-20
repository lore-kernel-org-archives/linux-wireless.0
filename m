Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Bass.Opus1.COM ([192.245.12.9]:2375 "EHLO bass.opus1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbXGTQom (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 12:44:42 -0400
Received: from egdell.wetwork.net ([71.226.119.66])
 by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MJ66DSPAR495OCYZ@Opus1.COM> for
 linux-wireless@vger.kernel.org; Fri, 20 Jul 2007 09:33:56 -0700 (MST)
Date: Fri, 20 Jul 2007 09:33:54 -0700
From: Ehud Gavron <gavron@Wetwork.Net>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
In-reply-to: <1184947521.1962.15.camel@dv>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>
Message-id: <46A0E3F2.5080209@Wetwork.Net>
MIME-version: 1.0
Content-type: multipart/signed;
 boundary=------------ms000302010708080501030005; micalg=sha1;
 protocol="application/x-pkcs7-signature"
References: <46963C0F.3080104@lwfinger.net>
 <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
 <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv>
 <20070720134425.GC7428@tuxdriver.com> <1184947521.1962.15.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000302010708080501030005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Not a developer, just a tester, and not a very good one... but I am a 
_USER_ so here's my take.

The USERs don't want to know what card they have or what driver they 
need or PCI IDs.  That's all stuff that makes them say "Linux Bad, 
*****s good." (Yeah I know, there's the whole driver moreass there and 
PCI VENs too) but anyway...

The driver should have a name that reflects its use and capabilities.

For example, bcm43xx is a reasonable name.  I don't like it personally 
because the google links to the site (berlios.de) that tell me that's 
why I need took a while to find but that's just semantics.

bcm43xx_mac80211 is a less reasonable name.  With respect to the coders 
who have put time into making this usable on by 4306 and almost usable 
on my 4311 I can say that I appreciate the effort... but the name needs 
work.

If I was king of driver package naming, the driver that works with v3 
and v4 firmware and supports crypto functions would be... 
broadcom80211bg or bcm80211g
The driver that only works with v3 (aka bcm43xx) broadcomv3
The driver that only works with v4 (aka bcm43xx_mac80211) broadcomv4

As time advances and bcb43xx_mac80211/broadcomv4 is brought to spec so 
it works great... its code would be integrated into 
broadcom80211g/bcm80211g.

That's my thinking.  As a USER.  As a linux advocate and zealot.

I can tell you there are three things that are the #1 hindrance to 
massive Linux adoption
1. proprietary video cards
2. proprietary network cards
3. the various sundry and astonishingly in-the-way and annoying 
network-managers.

If you can solve #2... you've eliminated 33% of the problem and maybe 
even helped with #3.

Go Lewis Hamilton @ Nurbugring
Go Paul Tracy @ Edmonton

Ehud

Pavel Roskin wrote:
> On Fri, 2007-07-20 at 09:44 -0400, John W. Linville wrote:
>   
>> On Fri, Jul 20, 2007 at 12:43:16AM -0400, Pavel Roskin wrote:
>>     
>>> Actually, the common practice is that the new driver that doesn't
>>> supplant the old driver immediately and for the whole range of hardware
>>> gets a new name.  Think CONFIG_IDE vs CONFIG_ATA and eepro100 vs e100.
>>>       
>>  
>> Yes, this preserves stability for happy bcm43xx users.  Still taking
>> suggestions for the new name for bcm43xx-mac80211... :-)
>>     
>
> b43
> bcm43
> bcm4k3
> bcmwifi
> bcmwlan
> bcm80211
> brcm43xx
> broadcom
>
> I really like the minimalism of b43, which plays well with b44 and
> p54 :)
>
>   
>>> Also, we could introduce a kernel option to enable support for new
>>> devices in your driver.
>>>       
>>  
>> Yes, this is probably worthwhile for those wishing to avoid PCI ID
>> conflicts between the drivers.  I have also been speculating that
>> perhaps we need an option for a secondary PCI ID table, so that a
>> driver could support a large range of PCI IDs but then gracefully
>> bow-out if another driver had a certain ID in its primary table.
>> Does that make any sense?  It would seem to be applicable to a number
>> of drivers in the kernel.
>>     
>
> Yes, I used to hearing complains that orinoco steals IDs from hostap.
> Then it became popular to blacklist orinoco modules.  Quite a disgrace
> for the driver!  Having "weak" IDs for Prism based cards would have
> avoided it.
>
> But please realize that the problem goes far beyond PCI.  Perhaps you
> have heard of CONFIG_USB_LIBUSUAL, which selects the best driver for USB
> storage devices, either the slow but reliable ub, or the SCSI based
> usb-storage, which it too fast for some cheap sticks.
>
> It even has a parameter called "bias", which allows to control how
> conservative the algorithm should be.  That would be hard to emulate
> with "weak entries", but I hope that "bias" is an overkill.
>
>   
>> Yes, we should probably start using a default value for fwpostfix.
>> As dwmw2 suggested, it would also be nice to fall back to an empty
>> fwpostfix if the firmware is not found w/ the default extension.
>>     
>
> Yes, that sounds good.
>
>   

--------------ms000302010708080501030005
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJMTCC
AvMwggJcoAMCAQICECZcUl3vdk/OJl8KvLfLjOAwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAyNzE5MzcyM1oX
DTA3MTAyNzE5MzcyM1owWTEPMA0GA1UEBBMGR2F2cm9uMQ0wCwYDVQQqEwRFaHVkMRQwEgYD
VQQDEwtFaHVkIEdhdnJvbjEhMB8GCSqGSIb3DQEJARYSZ2F2cm9uQHdldHdvcmsubmV0MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2XOGptpiIykgHs0OM5bmEw5LcT+TbuNT
xtivijtNscWTz7bZv4HV3Mb2vQOm24+VOkmQgdGOZ2fgAQk0aIqX2dRvkDQiLYvN+LLOGm+x
F6eV6+ClMHGZ+n+3BgbW7H93nKWTsLePNrU9yA0FMdIciLFgTVuk34FStjEdcdUSvLQKU+rD
SUeoCYWMmdKea7pqcIi26j4wUlizo5NG9obUnKCLdX8+q88mbKZXO+ZetxkjMn3VsZpsHsws
2CUZbPrUxq7VVsgTebM2Wr+sWWOZJZ5N+h9bkU+KRBxguBR5Yg7elDtBDj5zqlEAhzEelg7b
99Ia2hcvtX0tGguYYQ3QywIDAQABoy8wLTAdBgNVHREEFjAUgRJnYXZyb25Ad2V0d29yay5u
ZXQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQABmHVfcU5B3+0JETMEJbJeTnS2
xncHPUOgoaWTrXlnVpNZrXzbdvFG3Mzp4wfCHZHLBHVtji1q87G6u6ZWcN81ZghZlpBNjdc2
p9iNnRNTZHqAH2g+L2y1WPU/3YNJ3yDxNFjVZYmJrTpgETdzcQR1NFKTNN9zO1sOHZ/+pJxr
xTCCAvMwggJcoAMCAQICECZcUl3vdk/OJl8KvLfLjOAwDQYJKoZIhvcNAQEFBQAwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAyNzE5Mzcy
M1oXDTA3MTAyNzE5MzcyM1owWTEPMA0GA1UEBBMGR2F2cm9uMQ0wCwYDVQQqEwRFaHVkMRQw
EgYDVQQDEwtFaHVkIEdhdnJvbjEhMB8GCSqGSIb3DQEJARYSZ2F2cm9uQHdldHdvcmsubmV0
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2XOGptpiIykgHs0OM5bmEw5LcT+T
buNTxtivijtNscWTz7bZv4HV3Mb2vQOm24+VOkmQgdGOZ2fgAQk0aIqX2dRvkDQiLYvN+LLO
Gm+xF6eV6+ClMHGZ+n+3BgbW7H93nKWTsLePNrU9yA0FMdIciLFgTVuk34FStjEdcdUSvLQK
U+rDSUeoCYWMmdKea7pqcIi26j4wUlizo5NG9obUnKCLdX8+q88mbKZXO+ZetxkjMn3VsZps
Hsws2CUZbPrUxq7VVsgTebM2Wr+sWWOZJZ5N+h9bkU+KRBxguBR5Yg7elDtBDj5zqlEAhzEe
lg7b99Ia2hcvtX0tGguYYQ3QywIDAQABoy8wLTAdBgNVHREEFjAUgRJnYXZyb25Ad2V0d29y
ay5uZXQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQABmHVfcU5B3+0JETMEJbJe
TnS2xncHPUOgoaWTrXlnVpNZrXzbdvFG3Mzp4wfCHZHLBHVtji1q87G6u6ZWcN81ZghZlpBN
jdc2p9iNnRNTZHqAH2g+L2y1WPU/3YNJ3yDxNFjVZYmJrTpgETdzcQR1NFKTNN9zO1sOHZ/+
pJxrxTCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUw
EwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhh
d3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNp
b24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJ
ARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3
MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAo
UHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBD
QTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me
7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQq
E88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEA
AaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
cmwudGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIB
BjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcN
AQEFBQADgYEASIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNw
PP2t4WFiw9k6GX6EsZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq72
6jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYT
AlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNU
aGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQJlxSXe92T84mXwq8t8uM4DAJ
BgUrDgMCGgUAoIIBwzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0wNzA3MjAxNjMzNTRaMCMGCSqGSIb3DQEJBDEWBBTGCyLCx9yxoUJ0TdDon711Z/XiyTBS
BgkqhkiG9w0BCQ8xRTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYD
VQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECECZcUl3vdk/OJl8KvLfL
jOAwgYcGCyqGSIb3DQEJEAILMXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3Rl
IENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0ECECZcUl3vdk/OJl8KvLfLjOAwDQYJKoZIhvcNAQEBBQAEggEAlDS1
HJ5RFAClvrUHvkGF/yrOAiuP9Zdce2HhaNdrTs2HhNjEgqAYFjgEcqR5jrprUxCB1jDmzD/Q
HEOP7A/eMxnWxgKldB0C8bfoKO3149zY0a9KGKUNWiwlp5S2LgRjiXoH9M6SLf4JaOlS6Bn7
TMXkMeQAxtpODG+Q5BqUz3B9tR3Ts0/Lo4bfkwD1rywbHXljujHT/1OSkBfiP0oO7hIoSuFL
RQ+DHB71n9KC6Da0vPAP65y0gT3tGJeBlES+MSb+FHaSBwRZ+TJvCSSmdFA1etWPttc84bl5
Jv9xtTk5jSivhfUo5LrPEaPNdj5Y8DMtO/z8FjVbrGXWm4HZwQAAAAAAAA==
--------------ms000302010708080501030005--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
