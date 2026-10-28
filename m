Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793179149;
	b=hriK94nB2LiX5v8j8Hi9gLYASMYi+kBlcaDbG0ueWEMgyz4tyaJO+3jAm3i6BoM/qtTE
	 QMl7i2a80S+DPg0lKlPyqQM13ekkNvIJ/YJpYpyBc1uFleVe4lpkx6bEZtfJ93Zrjm4pJ
	 M6/TS5OikxEke0Yi3QOuEvSx3uOjzK1V1KjS4hY/pYsmAakLDaqeKbQK8wRUr28Q/ZCEh
	 irTZLnNknlSQt0cgO5YFbgbfcl4KHQh/lgo2IYhFAvA4BEMGan1gTnsEm2AKTz4bsuwSE
	 elhHGjWwp1rSCfg0G/K4VU9xG4/PlX/UZ5gEdOvdezubbhX0Xzv/EStJeVZEJ/oA1OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179149;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:Content-Type:User-Agent:MIME-Version:X-SRS-Rewrite;
	bh=bmyF32F61umXqAeVJjNKwWpVSE49VjYAsQ+LKgZjUw0=;
	b=ikfWxmiftdNYBx9UdVGul1mhb6Vxq7M6ruFZOQZwMLZaI/UnELLiy6yandUT7uVWTohY
	 QGrmiYQB+SCXPyAM55CJEhSew7IPkdRRDMdwZx581W6Va/D4+AatC/xTif18v+URZXwTe
	 LzT7hLkX834Aved0QFuCYgMWFnHuMlKu+kelQSP3NtdldgmQGal8c5GOiE1SQkizEsJT7
	 6mPvqXxEWkVh8lzMLhOE087Z5y5bwdJom4+/LYyXUDKFboTUw7Ls7QFu8zMjJfDNmD3fm
	 1Qzw3ZSZsW7wKWmAp5mitVF/KIljqeFkeHE0cuxlpx60ycx/WnR1HUfIo0Rl971ULpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=fF0LBM3q;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB9606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4EB9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=fF0LBM3q
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
	From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=bmyF32F61umXqAeVJjNKwWpVSE49VjYAsQ+LKgZjUw0=; b=fF0LBM3qGbKpjkFaWNd4tWgzRb
	jFuCKYAlC0HUJFPRKYPwd9dp1vKfdfn0v0EGutM5zGUmyaDNOs9ASCrh6cAhkvIQD19+l/4GEgU9m
	lNFs5yZ1le4FriAAVewmi2dqa+Ghz9AtHBc+RbiA4JCuyEVxenfX+YxijVqGIg5U4fw+qDdcbI1jm
	Yfk+IPBE4qD5MOuBNcRIoJN0OEhUxSssKBznl43iJh6XkW//ysXGPMDq3zKTMCG/RI+KxxhU1MzQW
	mbVI2unHE2wUhgi51sZeBJDQ6QisySgidujazt8EZB589J+zAgQPDOC82YjhWe6W1pcTtsktRrJMN
	mUGakMqQ==;
Received: from [172.31.31.148] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLzoG-00000002RCF-2fwI;
	Wed, 28 Oct 2026 09:19:04 +0000
Message-ID: <1739a03973e92dc36e00354eff115ca0c028a3ef.camel@infradead.org>
Subject: [PATCH] iw: scan: print Time Advertisement and Time Zone elements
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 28 Oct 2026 09:19:04 +0000
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-BD2jEGSliIFBRzkaAFrq"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-BD2jEGSliIFBRzkaAFrq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

An AP configured with hostapd's time_advertisement=3D2 includes the
IEEE 802.11v Time Advertisement and Time Zone elements in its beacons,
but iw shows them only as unknown IEs, and only with -u.

The Time Zone element is just a POSIX TZ string, so print it verbatim.
For Time Advertisement, print the timing capabilities field and, for
method 2, the UTC time at which the TSF timer was zero:

	Time Advertisement:
		 * timing capabilities: 2
		 * UTC time at TSF 0: 2026-10-19 20:50:45.000
	Time Zone: GMT0BST,M3.5.0/1,M10.5.0

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 ieee80211.h |  2 ++
 scan.c      | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/ieee80211.h b/ieee80211.h
index 2e6b68b..a53fb61 100644
--- a/ieee80211.h
+++ b/ieee80211.h
@@ -78,8 +78,10 @@ enum elem_id {
 	EID_HT_OPERATION		=3D 61,
 	EID_SECONDARY_CH_OFFSET		=3D 62,
 	EID_MEASUREMENT_PILOT_TX	=3D 66,
+	EID_TIME_ADVERTISEMENT		=3D 69,
 	EID_RM_ENABLED_CAPABILITIES	=3D 70,
 	EID_OVERLAP_BSS_SCAN_PARAM	=3D 74,
+	EID_TIME_ZONE			=3D 98,
 	EID_INTERWORKING		=3D 107,
 	EID_ADVERTISEMENT		=3D 108,
 	EID_ROAMING_CONSORTIUM		=3D 111,
diff --git a/scan.c b/scan.c
index 2b6e904..871f72f 100644
--- a/scan.c
+++ b/scan.c
@@ -1822,6 +1822,22 @@ static void print_ie(const struct ie_print *p, const=
 uint8_t type, uint8_t len,
 	p->print(type, len, data, ctx);
 }
=20
+static void print_time_adv(const uint8_t type, uint8_t len, const uint8_t =
*data,
+			   const struct ie_context *ctx)
+{
+	printf("\n");
+	printf("\t\t * timing capabilities: %d\n", data[0]);
+
+	/* Time Value, Time Error and Time Update fields are only
+	 * present for timing capabilities value 2 (UTC at TSF 0) */
+	if (data[0] !=3D 2 || len < 17)
+		return;
+
+	printf("\t\t * UTC time at TSF 0: %04d-%02d-%02d %02d:%02d:%02d.%03d\n",
+	       (data[2] << 8) | data[1], data[3], data[4],
+	       data[5], data[6], data[7], (data[9] << 8) | data[8]);
+}
+
 #define PRINT_IGN {		\
 	.name =3D "IGNORE",	\
 	.print =3D NULL,		\
@@ -1850,6 +1866,9 @@ static const struct ie_print ieprinters[] =3D {
 				  print_supp_op_classes, 1, 255, BIT(PRINT_SCAN), },
 	[EID_MEASUREMENT_PILOT_TX] =3D { "Measurement Pilot Transmission",
 				       print_measurement_pilot_tx, 1, 255, BIT(PRINT_SCAN), },
+	[EID_TIME_ADVERTISEMENT] =3D { "Time Advertisement", print_time_adv,
+				     1, 255, BIT(PRINT_SCAN), },
+	[EID_TIME_ZONE] =3D { "Time Zone", print_ssid, 1, 255, BIT(PRINT_SCAN), }=
,
 	[EID_OVERLAP_BSS_SCAN_PARAM] =3D { "Overlapping BSS scan params",
 					 print_obss_scan_params, 14, 255, BIT(PRINT_SCAN), },
 	[EID_HT_OPERATION] =3D { "HT operation", print_ht_op, 22, 22, BIT(PRINT_S=
CAN), },
--=20
2.43.0


--=-BD2jEGSliIFBRzkaAFrq
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
an4lqsRxa8OuuY+EPq2fzHUAAAAAAAA=


--=-BD2jEGSliIFBRzkaAFrq--
