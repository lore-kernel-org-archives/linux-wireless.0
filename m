Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winsoft.com.pl ([109.234.111.213]:42035 "EHLO winsoft.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123Ab3CNOhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 10:37:48 -0400
Message-ID: <5141E0B5.506@winsoft.pl> (sfid-20130314_153751_976210_28B95612)
Date: Thu, 14 Mar 2013 15:37:41 +0100
From: Krzysztof Kolasa <kkolasa@winsoft.pl>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: Re: [PATCH 3.9] iwl3945: fix length of dma buffers
References: <1363261720-4344-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1363261720-4344-1-git-send-email-sgruszka@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020805000309030308040501"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020805000309030308040501
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

On 14.03.2013 12:48, Stanislaw Gruszka wrote:
> commit bdb084b22d8aee66c87af5e9c36bd6cf7f3bccfd
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Wed Feb 13 15:49:08 2013 +0100
>
>      iwlegacy: more checks for dma mapping errors
>  =20
> broke il3945_tx_skb() dma buffer length settings, what results on
> firmware errors like showed below and make 3945 device non usable.
>
> iwl3945 0000:02:00.0: Microcode SW error detected. Restarting 0x8200000=
8.
> iwl3945 0000:02:00.0: Loaded firmware version: 15.32.2.9
> iwl3945 0000:02:00.0: Start IWL Error Log Dump:
> iwl3945 0000:02:00.0: Status: 0x000202E4, count: 1
> iwl3945 0000:02:00.0: Desc 	Time	   asrtPC blink2 ilink1  nmiPC   Line
> iwl3945 0000:02:00.0: SYSASSERT     (0x5) 0000208934 0x008B6 0x0035E 0x=
00320 0x00000 267
> iwl3945 0000:02:00.0: Error Reply type 0x00000001 cmd
>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
> Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>   drivers/net/wireless/iwlegacy/3945-mac.c |   22 ++++++++++++---------=
-
>   1 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wir=
eless/iwlegacy/3945-mac.c
> index 3630a41..c353b5f 100644
> --- a/drivers/net/wireless/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/iwlegacy/3945-mac.c
> @@ -475,6 +475,7 @@ il3945_tx_skb(struct il_priv *il,
>   	dma_addr_t txcmd_phys;
>   	int txq_id =3D skb_get_queue_mapping(skb);
>   	u16 len, idx, hdr_len;
> +	u16 firstlen, secondlen;
>   	u8 id;
>   	u8 unicast;
>   	u8 sta_id;
> @@ -589,21 +590,22 @@ il3945_tx_skb(struct il_priv *il,
>   	len =3D
>   	    sizeof(struct il3945_tx_cmd) + sizeof(struct il_cmd_header) +
>   	    hdr_len;
> -	len =3D (len + 3) & ~3;
> +	firstlen =3D (len + 3) & ~3;
>  =20
>   	/* Physical address of this Tx command's header (not MAC header!),
>   	 * within command buffer array. */
>   	txcmd_phys =3D
> -	    pci_map_single(il->pci_dev, &out_cmd->hdr, len, PCI_DMA_TODEVICE)=
;
> +	    pci_map_single(il->pci_dev, &out_cmd->hdr, firstlen,
> +			   PCI_DMA_TODEVICE);
>   	if (unlikely(pci_dma_mapping_error(il->pci_dev, txcmd_phys)))
>   		goto drop_unlock;
>  =20
>   	/* Set up TFD's 2nd entry to point directly to remainder of skb,
>   	 * if any (802.11 null frames have no payload). */
> -	len =3D skb->len - hdr_len;
> -	if (len) {
> +	secondlen =3D skb->len - hdr_len;
> +	if (secondlen > 0) {
>   		phys_addr =3D
> -		    pci_map_single(il->pci_dev, skb->data + hdr_len, len,
> +		    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
>   				   PCI_DMA_TODEVICE);
>   		if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr)))
>   			goto drop_unlock;
> @@ -611,12 +613,12 @@ il3945_tx_skb(struct il_priv *il,
>  =20
>   	/* Add buffer containing Tx command and MAC(!) header to TFD's
>   	 * first entry */
> -	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
> +	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
>   	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
> -	dma_unmap_len_set(out_meta, len, len);
> -	if (len)
> -		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
> -					       U32_PAD(len));
> +	dma_unmap_len_set(out_meta, len, firstlen);
> +	if (secondlen > 0)
> +		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen, 0,
> +					       U32_PAD(secondlen));
>  =20
>   	if (!ieee80211_has_morefrags(hdr->frame_control)) {
>   		txq->need_update =3D 1;
Patch solves the problem.

Thanks.

Krzysztof


--------------ms020805000309030308040501
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKSTCC
BDUwggMdoAMCAQICAwR6UjANBgkqhkiG9w0BAQUFADA+MQswCQYDVQQGEwJQTDEbMBkGA1UE
ChMSVW5pemV0byBTcC4geiBvLm8uMRIwEAYDVQQDEwlDZXJ0dW0gQ0EwHhcNMDkwMzAzMTI1
MzE4WhcNMjQwMzAzMTI1MzE4WjB3MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBU
ZWNobm9sb2dpZXMgUy5BLjEnMCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MRswGQYDVQQDExJDZXJ0dW0gTGV2ZWwgSUkgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDgsTQjHDyHkul6v20dW1mRYi6PFiw9WBRkAF5lmBCwpN0mNoZU/rgH+iIR
Xkd3cDFGppnt1FGx/g+D89JL/aYdFBD9IfdcAJusMea5wO9iC1T9ahnKn13o9dU9jiPsnm3/
naz4RtkPmzBK5AsaNn2LCD2xdfcl0n1PL4HfPzSiJqOkrQHCoDGtxfcN6QQ6SePsuQA4rqK5
AojzlESPghVv2QPsoohZ0hIZt8vgTOH9M/nV7Qv9aFMnuUdsdtHMV89T+iLdDK3m0R7Gs8p7
7o34mt6N1vlhrs17e0q6MNTsqVs752enMUftUeQE8lxAntBSums9qpWxWDcknU9dOpWfAgMB
AAGjggEBMIH+MA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSA
YhHewGunEOEI8FW0MIO/+o8IYDBSBgNVHSMESzBJoUKkQDA+MQswCQYDVQQGEwJQTDEbMBkG
A1UEChMSVW5pemV0byBTcC4geiBvLm8uMRIwEAYDVQQDEwlDZXJ0dW0gQ0GCAwEAIDAsBgNV
HR8EJTAjMCGgH6AdhhtodHRwOi8vY3JsLmNlcnR1bS5wbC9jYS5jcmwwOgYDVR0gBDMwMTAv
BgRVHSAAMCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZI
hvcNAQEFBQADggEBALDY158kfBcPskynVAEJYYSvpIqF4YdOjcZ+5qxVgxwWcBYw76dbqQl6
S6fuGuSfJ1yuVCzC4oqQavoAjk8PyQRvRzhIXQjvNNicRg0y+u5RwMRAgFZBlSCdvvt6fepv
4qJpHN2WQ6lWBuwVk9WM7BzlozcZg8CNG0SHB6jcMHY7v0R4z/NtsEFoUdTeIxYPFHI1I0qY
pwE/ZE5+2lQA3qoboXc7WluMk2KaUTbMcksEoZP3NDQtqdLIk9B9ZPprslIq6I0xlxbHNhVH
K/DELRbldj3oj+0LPvuGjgemnLuUTn+G5ylqVs+bDJLVNm/OPaGJEt0WxIWq/+9f3DJGG6ww
ggYMMIIE9KADAgECAhBKCv5zChVLZk43YKp8Nn9CMA0GCSqGSIb3DQEBBQUAMHcxCzAJBgNV
BAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQLEx5D
ZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxGzAZBgNVBAMTEkNlcnR1bSBMZXZlbCBJ
SSBDQTAeFw0xMTEwMjIwMDAwMDBaFw0xMzEwMjEwMDAwMDBaMIGKMSEwHwYJKoZIhvcNAQkB
FhJra29sYXNhQHdpbnNvZnQucGwxGTAXBgNVBAMMEEtyenlzenRvZiBLb2xhc2ExETAPBgNV
BAsMCFNvZnR3YXJlMSowKAYDVQQKDCFQLkguVS4gIldJTlNPRlQiIEtyenlzenRvZiBLb2xh
c2ExCzAJBgNVBAYTAlBMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnrBFUe6c
994BmOtZmxgH+F8F/TK4PyneWGqj83krHeSwK1JmqQbTpKG9K+b3SLL0U368KM2Qi1AOT6yd
NcyiDpsZK7RQVPnt3Er0EmX0BAbSUuhfL1ayEnxGDEdZE7Ibo9KoOBCrUnHpLKw/kA2emb0T
3iAZ7/+SATNpds6wAO9PYZGhgS7Qy2O5Zd8yZZA+3sLdOMpAOm2JRWfXz713tii0ImkVMf+n
Vh8lRtnrQHSoVuqG4q7K3dW6ox8qgMMrxIhgUI7qnq5D73W8s0+VV8ELnbg3Oz/jfIIKx0vC
0mpuu+tlqAoMhXqV+lwyx7Gfi9FhFiz9AyGtncMJ41rPeQIDAQABo4ICfjCCAnowDAYDVR0T
AQH/BAIwADAsBgNVHR8EJTAjMCGgH6AdhhtodHRwOi8vY3JsLmNlcnR1bS5wbC9sMi5jcmww
WgYIKwYBBQUHAQEETjBMMCEGCCsGAQUFBzABhhVodHRwOi8vb2NzcC5jZXJ0dW0ucGwwJwYI
KwYBBQUHMAKGG2h0dHA6Ly93d3cuY2VydHVtLnBsL2wyLmNlcjAfBgNVHSMEGDAWgBSAYhHe
wGunEOEI8FW0MIO/+o8IYDAdBgNVHQ4EFgQUR7qmeC1ehqSaZpUA0RELXaKDN9kwDgYDVR0P
AQH/BAQDAgSwMIIBPQYDVR0gBIIBNDCCATAwggEsBgoqhGgBhvZ3AgICMIIBHDAlBggrBgEF
BQcCARYZaHR0cHM6Ly93d3cuY2VydHVtLnBsL0NQUzCB8gYIKwYBBQUHAgIwgeUwIBYZVW5p
emV0byBUZWNobm9sb2dpZXMgUy5BLjADAgEBGoHAVXNhZ2Ugb2YgdGhpcyBjZXJ0aWZpY2F0
ZSBpcyBzdHJpY3RseSBzdWJqZWN0ZWQgdG8gdGhlIENFUlRVTSBDZXJ0aWZpY2F0aW9uIFBy
YWN0aWNlIFN0YXRlbWVudCAoQ1BTKSBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlIGhlcmVp
biBhbmQgaW4gdGhlIHJlcG9zaXRvcnkgYXQgaHR0cHM6Ly93d3cuY2VydHVtLnBsL3JlcG9z
aXRvcnkuMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDARBglghkgBhvhCAQEEBAMC
BaAwHQYDVR0RBBYwFIESa2tvbGFzYUB3aW5zb2Z0LnBsMA0GCSqGSIb3DQEBBQUAA4IBAQC8
awTTYI9X/r8JzuSDH0Rv4E5nCwKvC3pg3nY0d6PSQp/PGPHX8NMmJr9d7X8Ybg/m3OSevQWL
ualksFdNuv9EmmdB1tUSMb/Kfa77aijFCzSFyJ1i0cVe5AvdEKujmc1a5HTbXW9EfOI65LOU
VUefXBnp5GxC0hISPjaBHddLHdE1iMkDLqa7P6whoIhKFcxeb7/GT26/YY8dt5R68y3UL8iC
DzsL33w4VjhB28p874N7BLtczMe/CpnGIGtDY5S0Ug2qKVsh6eLyFP6dkDjfZqpnzt5hOz9J
yg870PMYYDG0FvP+n2RL/Byap4sHoApb55ERwwUgwM+fCFpCkaVxMYIDwjCCA74CAQEwgYsw
dzELMAkGA1UEBhMCUEwxIjAgBgNVBAoTGVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAl
BgNVBAsTHkNlcnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEbMBkGA1UEAxMSQ2VydHVt
IExldmVsIElJIENBAhBKCv5zChVLZk43YKp8Nn9CMAkGBSsOAwIaBQCgggILMBgGCSqGSIb3
DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDMxNDE0Mzc0MVowIwYJKoZI
hvcNAQkEMRYEFE+UL4J13nlqqC+Y2hTGErLQ8lPGMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZwGCSsGAQQBgjcQBDGBjjCBizB3
MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEnMCUG
A1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRswGQYDVQQDExJDZXJ0dW0g
TGV2ZWwgSUkgQ0ECEEoK/nMKFUtmTjdgqnw2f0IwgZ4GCyqGSIb3DQEJEAILMYGOoIGLMHcx
CzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYD
VQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxGzAZBgNVBAMTEkNlcnR1bSBM
ZXZlbCBJSSBDQQIQSgr+cwoVS2ZON2CqfDZ/QjANBgkqhkiG9w0BAQEFAASCAQA0EtupTNfi
4OkG6chfpT6DfKRRVf58h4x0JW0WtB1/0RYqBR405gDhH7FXUNW2Bs+bBdFcaMQvK0qKi40w
B5PnqxE+TxTneiaZJiFOzRmUnXvWwTUBRnIaHjRuSbWIPBRBHKwtGLWSRy4s+j1rnoSFK1Lf
J0sGngfFF6wnnQLQvxilWNrYwbfGYvh1MNcPhJTnY0gsEiI53YeTUTpe+JQLve/cZTF0WOhw
luGeUceli5KMPhzCQabDyGRKQWDox4EkILcr/8NQxfBtYOev4b4xofRVML9EXxEd1gWG/7SA
Xz4dSYkStDxpB9X9220PIq8uIJwEu5lEkZpPVUH8+HimAAAAAAAA
--------------ms020805000309030308040501--
