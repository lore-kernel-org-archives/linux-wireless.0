Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Bass.Opus1.COM ([192.245.12.9]:4148 "EHLO bass.opus1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbYHYWJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 18:09:36 -0400
Received: from [10.1.1.5] ([204.17.34.178]) by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MYS38PIX1Q8YAABT@Opus1.COM> for
 linux-wireless@vger.kernel.org; Mon, 25 Aug 2008 15:09:34 -0700 (MST)
Date: Mon, 25 Aug 2008 15:09:25 -0700
From: Ehud Gavron <gavron@wetwork.net>
Subject: Re: [PATCH RFC/RFT] b43: Improve TX power recalculation under load
In-reply-to: <200808252227.59315.mb@bu3sch.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Message-id: <48B32D95.2000105@wetwork.net> (sfid-20080826_000941_163384_5FBA9AE0)
MIME-version: 1.0
Content-type: multipart/signed;
 boundary=------------ms090500050405020805070509; micalg=sha1;
 protocol="application/x-pkcs7-signature"
References: <200808252154.18571.mb@bu3sch.de> <200808252227.59315.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090500050405020805070509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Buesch wrote:
> On Monday 25 August 2008 21:54:18 Michael Buesch wrote:
>   
>> The patch is available here:
>> http://bu3sch.de/patches/wireless-testing/20080825-2146/patches/004-b43-NEW-rewrite-txpower-adjusting.patch
>>     
>
> Here's an updated version with a major bug fixed:
> http://bu3sch.de/patches/wireless-testing/20080825-2227/patches/004-b43-NEW-rewrite-txpower-adjusting.patch
>
>   
iperf, wget, speedtest.net, and sftp all show similar performance.

Ehud
0c:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN 
(rev 01)
    Subsystem: Dell Wireless 1390 WLAN Mini-Card
    Flags: bus master, fast devsel, latency 0, IRQ 17
    Memory at ecffc000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 2
    Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
    Capabilities: [d0] Express Legacy Endpoint IRQ 0
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [13c] Virtual Channel

root@egdell:~# uname -a
Linux egdell 2.6.27-rc3-20080825-wl #1 SMP Mon Aug 25 14:08:15 MST 2008 
x86_64 GNU/Linux
root@egdell:~# dmesg | grep b43
b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
b43-pci-bridge 0000:0c:00.0: setting latency timer to 64
b43-phy0: Broadcom 4311 WLAN found
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
input: b43-phy0 as /class/input/input8
firmware: requesting b43/ucode5.fw
firmware: requesting b43/pcm5.fw
firmware: requesting b43/b0g0initvals5.fw
firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0: Radio turned on by software
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 
ff:ff:ff:ff:ff:ff
b43-phy0 debug: Disabling hardware based encryption for keyidx: 0, mac: 
ff:ff:ff:ff:ff:ff
b43-phy0 debug: Removing Interface type 2
b43-phy0 debug: Wireless interface stopped
b43-phy0 debug: DMA-32 rx_ring: Used slots 32/64, Failed frames 0/0 = 
0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, Failed frames 
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 128/128, Failed frames 
42/41538 = 0.1%, Average tries 1.24
b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, Failed frames 
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 2/128, Failed frames 
0/86 = 0.0%, Average tries 1.00
b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, Failed frames 
0/0 = 0.0%, Average tries 0.00
input: b43-phy0 as /class/input/input9
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 
ff:ff:ff:ff:ff:ff


--------------ms090500050405020805070509
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJMTCC
AvMwggJcoAMCAQICEHnI3J4QLeHCRGcKOR5IaHYwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDkyNzE0NDcxM1oX
DTA4MDkyNjE0NDcxM1owWTEPMA0GA1UEBBMGR2F2cm9uMQ0wCwYDVQQqEwRFaHVkMRQwEgYD
VQQDEwtFaHVkIEdhdnJvbjEhMB8GCSqGSIb3DQEJARYSZ2F2cm9uQHdldHdvcmsubmV0MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA13awzGlBLGAdlZ8tkLZPNEm5mFa91CYv
SQBgHBLC/AabDFRxyEvBnN5yVHWO8keREHViywHneCLCOduF4hOauJ7O/y6TZhThyCIv5owI
ahUSX9zGiTN5JIL2Cnj/Cr72DTWYM+heG0vOUz+XmPIAUtWBuU4P3VtWDbR2qq6ir9JzGc9E
Nhow4wOVpBOkIJjStDUZhVUJqdWg/Ovn1A1nB7pj2f/eypbr8Dg2EdadYIWtjhcO6E8rh3Ff
LRgfhVoLqpAezyhRC+Ck9VGHVM+X6gjCfLf4IpKXiaEsLtNdPUOir6Ft01qODW4XhyCrilhU
CzacmX4EHK2c671FrvsbKwIDAQABoy8wLTAdBgNVHREEFjAUgRJnYXZyb25Ad2V0d29yay5u
ZXQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQB5+ECJAj8t7G6jfjTuwkHCxBU+
4dDgkQAEzU7dwYXuh26oasZUPwQ+TCd7PF7VBz9Ny6qRLuBcZ3zlJto7bVkWxWiGykRYpCn9
LzvqeahkkhGyl14oLiJBtpAweunbWMxdBLiONFfLZjCqAFuuvMdEazarfqWS8as8jYW0OY+R
hDCCAvMwggJcoAMCAQICEHnI3J4QLeHCRGcKOR5IaHYwDQYJKoZIhvcNAQEFBQAwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDkyNzE0NDcx
M1oXDTA4MDkyNjE0NDcxM1owWTEPMA0GA1UEBBMGR2F2cm9uMQ0wCwYDVQQqEwRFaHVkMRQw
EgYDVQQDEwtFaHVkIEdhdnJvbjEhMB8GCSqGSIb3DQEJARYSZ2F2cm9uQHdldHdvcmsubmV0
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA13awzGlBLGAdlZ8tkLZPNEm5mFa9
1CYvSQBgHBLC/AabDFRxyEvBnN5yVHWO8keREHViywHneCLCOduF4hOauJ7O/y6TZhThyCIv
5owIahUSX9zGiTN5JIL2Cnj/Cr72DTWYM+heG0vOUz+XmPIAUtWBuU4P3VtWDbR2qq6ir9Jz
Gc9ENhow4wOVpBOkIJjStDUZhVUJqdWg/Ovn1A1nB7pj2f/eypbr8Dg2EdadYIWtjhcO6E8r
h3FfLRgfhVoLqpAezyhRC+Ck9VGHVM+X6gjCfLf4IpKXiaEsLtNdPUOir6Ft01qODW4XhyCr
ilhUCzacmX4EHK2c671FrvsbKwIDAQABoy8wLTAdBgNVHREEFjAUgRJnYXZyb25Ad2V0d29y
ay5uZXQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQB5+ECJAj8t7G6jfjTuwkHC
xBU+4dDgkQAEzU7dwYXuh26oasZUPwQ+TCd7PF7VBz9Ny6qRLuBcZ3zlJto7bVkWxWiGykRY
pCn9LzvqeahkkhGyl14oLiJBtpAweunbWMxdBLiONFfLZjCqAFuuvMdEazarfqWS8as8jYW0
OY+RhDCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUw
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
6jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNxMIIDbQIBATB2MGIxCzAJBgNVBAYT
AlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNU
aGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQecjcnhAt4cJEZwo5HkhodjAJ
BgUrDgMCGgUAoIIB0DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0wODA4MjUyMjA5MjVaMCMGCSqGSIb3DQEJBDEWBBSPHEtfpWTNwAQmNX0GoGsjsROf2jBf
BgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgYUGCSsGAQQBgjcQ
BDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkp
IEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB5
yNyeEC3hwkRnCjkeSGh2MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB5yNyeEC3hwkRnCjkeSGh2MA0GCSqGSIb3
DQEBAQUABIIBAB1WFI5FgaYDg4Gp2NsSc/RHk7MUZ9g7GfpJHR4eFMxRo8yo8/6G/aReRUhq
bUPk81aunNBDCKUC5z8pBZxFw7gZG1kgzkvzc3Ydh+utSC4AT1zELI3UbIEIdblJwi9lT7VK
VbcCkHNNMFfVDNYjdvDwAkYPJFhXpxo2WZiLXhlw7FSNZCRzkFDfiQWhVJ+eGx8D/FlvKsQT
MfTSpJ/4Na7BksDptGDR6pgoyHTGVuu/PgSarjOHF/XFqQdjrqdk4udCAa4zsK7uUBODE4S2
fzz+QWUtQ9f7azUUhvVIDlvuNSWR0NJ4OXwWvFWFJ9kBMoXquJCU4cHH3mvTK6y6DR0AAAAA
AAA=
--------------ms090500050405020805070509--
