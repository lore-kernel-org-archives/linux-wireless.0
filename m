Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:30526 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYKTNpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 08:45:01 -0500
Received: by nf-out-0910.google.com with SMTP id d3so225365nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 05:44:59 -0800 (PST)
Message-ID: <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com> (sfid-20081120_144508_005072_4F9F8881)
Date: Thu, 20 Nov 2008 14:44:58 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_99801_14322473.1227188699195"
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
	 <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com>
	 <1227109286.26243.54.camel@johannes.berg>
	 <f76a32050811190823r51033a4dqa29de6d1e6663388@mail.gmail.com>
	 <1227126204.26243.62.camel@johannes.berg>
	 <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_99801_14322473.1227188699195
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>> What's your client? Is it using powersave? Anyone know whether
>> multicast-after-dtim works correctly in p54? Or maybe there's a bug
>> hitting with TIM bits? Do you have an extra card that you could use to
>> monitor and see what happens when it times out?
>
> I have tested multiple clients at this time with my XG-601/ISL3880 p54 card:
> - iPod Touch 2G with firmware 2.1.1
> - Sony Vaio with a Marvell 88E8036 (Vista SP1)
> - Amilo Notebook with Intel 4965AGN (stock Ubuntu 8.10)
> - Amilo Notebook with Netgear USB-WLAN-Stick with RTL8187B (stock Ubuntu 8.10)
>
> Interestingly, only the iPod is unusable, with constant timeouts of my
> web-app. The other clients work 99% of the time with an _occasional_
> timeout. I have multiple clients connected at the same time, and never
> saw a simultaneous timeout with any two clients. I have also a wired
> reference connection which never exhibits any timeouts.

I have attached some traffic dumps that happen between my iPod Touch
and the XG-601-based AP (obtained with a RTL8187B in monitor mode):

Observations:

- ipod_http_request_ok.pcap shows how I would like the world to be
(and how it is _occasionally_ with the iPod and _almost always_ with
my other clients). We build a TCP connection, make a http request, get
a TCP ACK, followed swiftly by an answer and the TCP connection
closes.

- Sometimes, however, the http answer does not appear immediately
after the request (about 4-7 secs of delay). The gap is filled by some
"Null function" packets originating on the iPod (maybe it is getting
impatient?). This gets me an application-level timeout. See
ipod_http_request_delayed_answer.pcap .

- Then, there's a scenario that makes the iPod reset any new TCP
connection until I disassociate and reassociate it to the AP (see the
last two pcaps). This seems to happen whenever somebody (must be my
Notebook WLAN) sends probes. The same sequence of events does not
cause anything untoward with my other clients.

It may be Apple's job to fix this - however, iPods work ok with many
APs (including Apple's own AirPort of course) (and the latest madwifi
except for annoying "stuck beacons" resulting in card resets).

Any ideas? Should I forward this info to someone? Anything I should try?
My goal is to make the iPod work with any decent MiniPCI card that
supports AP mode.

Best regards,
  Stefan.

------=_Part_99801_14322473.1227188699195
Content-Type: application/x-gzip; name=ipod_http_request_ok.pcap.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnrfr1a00
Content-Disposition: attachment; filename=ipod_http_request_ok.pcap.gz

H4sICKBhJUkAA2lwb2RfaHR0cF9yZXF1ZXN0X29rLnBjYXAAlZV/aBtVHMDfJZmUC5ndKGVUwdeb
ylaSXC5tli51LLGLq7R1YWvX/iFm1+Tlekt2d969jLkxCNv+2BAEUZS1E+Z/MmhRO5RKlYL/b/uj
C/tjMPAPlSIDhwr7q37fSxd2Z0Iw8E3u+z3e+3x/Z+Pnb7/0oQB69tnaQkiH33T+tbff/CGI5uCZ
yVUhjNCplRMvfoqkzMcffbb93IvQrVt+eN+FsnBo9ZU0Sr/wxaP1r74pgQj1HpRbebqA2c1f+7a2
diwj5AvsuC34/T5B6BL73t35E3sX8DWI2bUgeg90Jld9QHyexb/T2EV8A84BccbPaIyKcvWeG38s
bAC1/+bu3puzLzWIAV+XiPwWZkSgBxgtAzQRbmKywdxoEFjk60F0Egwn20be7Y58aBXzyDc9kfeD
L/dr3bXll+sINSMGP3i06x4+v597dieI/hQQl9Z87OILd1f7Gf/GOy35e2rLA5+4+UezU1jWCM07
VKXksEMcRzeNvF48pMTjSWU4cTAWGxpMvk71M8Ss0kNDsVgMj01N5WQlqoTE2chx8n6VOJQUIzM6
nU/h2cmJMUqtbXNInHaIHcloxKApPGme1ysVVU5EY3ifnjOLI3h6BI/mprGemzcNgo+dwPG8kldw
RS8TPKkWmGV2BBMjUnX244xlVcgMmRvXqZyIJ6LKcFTB+8bHpiYnwo0jR0mhbO4H0JxeIXLiLWVw
OCRmCgViAV6F43pBpRCgfNoxjTCm5ByVT6tnVadg6xYN4wF5ICQeJyViEzuF5yGQlCwrB+NR5QCw
ksmoIj+7LzKhGlpV1Uiq4V7TnjUKZlE3tBTWzutWGBdJqQK5DYmjpmGQAsOncJkQK6JW9LNgHzMd
8M5FCYkhkbfGnXatceTec63ZckRy7hEZ2vyLtUal1zMi91eeLq7VuoWlhZFGa0Bb9LP2YJT0vXaj
ka0HUQDakklr/ik3/5fNvxm/rLXk7xGW1M+bfInxt7sshuPQcsfGWUouSLxNpRSWRlWLVm1IsxTG
0pxKKbE/YHbNNIvMVNSdMujJBDxbtqnZ0NmgK6A6hFI4yNQLEjvTuMIheXLOMp2qzQGKHGf2kkNN
i+mlRPQAM1iqYdrqGRVmhJkHlQRYL17k2aq3y9aRB52qZXmr9Q+vVo87W4uXebZ2CUvXP3Rni/Mf
tOOnH3ZaZDHvIpP4IvvdvUgW15gPsMgu9X3vWiQSj/Jh20XWkZ/28vdy/m8t+Fc4/7v/w08/7sTP
efmvcv6vLfm7ast91/7Lzz5uO61POtW/5qn/9h9a0FP/K+DDj2xar19r1n9vs/5PWtX/X04bBwHb
BwAA
------=_Part_99801_14322473.1227188699195
Content-Type: application/x-gzip;
 name=ipod_http_request_delayed_answer.pcap.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnrfs77t1
Content-Disposition: attachment;
 filename=ipod_http_request_delayed_answer.pcap.gz

H4sICGFiJUkAA2lwb2RfaHR0cF9yZXF1ZXN0X2RlbGF5ZWRfYW5zd2VyLnBjYXAAhVRNaBtHFJ5d
KcUsiDo9tOnPYRBpSVztrnYtWY5cJ3aNYhnLRCTyTyGNupJG67E3u9vdUVDsBlQKJRTqNlB6aQ1u
aaEEYuy0hxpaCCmB0kLrQ3DJJbfem0PP7ptV7EZiRQRPu/O9nfm++ea9uf/L7a9EFEUHv/19hCg8
nfKrU6dnRVSBdx7XhQRC73x/4dnPUHz8xtrn7fdPX0bo5s0I5PtQDqGxneYYGntm/cM7323XIYS9
46goC39s8ZW3xP39uSGExOiRH4RIRBSEPumli/1rPBcV24y5kogkGPO4zxMBV5BZENElAHhcFxPo
SRXtf3egQ8sbIAe0zEe4Dq4HFfeO//rR3zLo2d547vmNI5W2lqjYJ6HI+hLXArqiwc7f6tIRMASZ
t0U0B8BcT082Oj1J7VwNPLnR5ck2aFFa/a3N315B6NAL0BHs9mIvH06bInokoCDC+bc6+IU/d1Y4
/xf/hvIfa23+9aCTfzJXwqpJWNlnBiNnfOL71LHLtDaq6XpGG06fSiZTg5nXGL1MnAYbTSWTSZwv
lYqqpmgxaUE+T95tEJ+RmjxP2WIWL8wU8oy5j+GYNOsTTx43ic2yeMZZoZZlqGkliU/QolMbwbMj
eKI4i2lx0bEJPncB62WtrGGLLhM8Y1Q5sjCCiS03/JN43HUtMk8q05SpaT2taMOKhk9M50szhUR7
yiSpLjsngahCLaKmz2qDwzFpvFolLtAbMJ1WDQYbVJd8x05gRppMXTKuGH7Voy5L4AF1ICadJ3Xi
ES+LF2EjWVXVTumKNgRcmYyiqQfryQXDNhuGSbJteYd4zq46NWqbWWyuUDeBa6RugbcxacKxbVLl
9Fm8TIgrGxa9Anje8UFdB0tMiklBadR7tsjiE6UZ2iKtzhZJNXO8NB7e62oRRRZ2C61+4dbk++3S
gLKweHkEBUjDWsOFzOhEBB0DgEf+aFhp/vMl/y73ZiRkBwwyZ75F/68QWtxonX939hvUY4Xcj4BB
a/AI92Ds9Q4PHjanAg9eCPXgReHWx48OPPh6j3vwuNKTWIeyPzfNj2U1HrRKPIvjUzWLxBM4XjEY
I95VDpmOU+NQjfrLMM7o8O56julBY8FYS8HYJ4xBffDxapxPaq/hkzJpuo7f8ILFNVXneN1njsvH
9bQyxAHXsB3PuGxAj3J4UOPotWuBoztSyGkFmZ+lp1xkd7ovstXgIvuk8yLZLYBbD+Ai++DupcOL
5B53Kzipn6ReZ/370/h3u/nfC/jXQvmPtjbv6p38/wHxyP0g2wYAAA==
------=_Part_99801_14322473.1227188699195
Content-Type: application/x-gzip;
 name=ipod_http_request_probe_responses.pcap.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnrfs7ye2
Content-Disposition: attachment;
 filename=ipod_http_request_probe_responses.pcap.gz

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
------=_Part_99801_14322473.1227188699195
Content-Type: application/x-gzip; name=ipod_http_request_tcp_reset.pcap.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnrfs8fd3
Content-Disposition: attachment;
 filename=ipod_http_request_tcp_reset.pcap.gz

H4sICLliJUkAA2lwb2RfaHR0cF9yZXF1ZXN0X3RjcF9yZXNldC5wY2FwAIWUz28bRRTHZ50ttVay
SPmltKeRJYpb2V6vY9fOhhCbJMRtEtVKnB8HVHdjj51t3N1ld1xKq6o+UCk9FAJF9AAHo6pSiUhU
oK1QDgjEBQQSh0Y5VpxQKyR+/AXmzbg2sbUulp6982bnfd4bf9/b+eGrzzxIRK1Po4GQDr+P8i8f
H31fRMvwzGxNCCJ0+uu5Zz9C/vQH733cfP7tFYQ2Nvpg34smEEptj6RQ6plPv//u9pclMGE3g7L5
y58nWOQ7nkZjfA4hj7jvrtDX5xEEr3TozRczbE/0NInqdRGdgjWzNQ8Q97Ca36fHOoivAhSIi32M
xqgou5sZOjWOgJqsP/dSffNakyh6vBISn7/HiEAXeX1AkyASsx2WBifwnRsiWgDHQs/K/+6sPLb9
Gq/8l67Kk5CLUOuvbdlQZ7tiyINXe6OLz+Nz/k0R/SMgbu58FNjLF37dHmX8TyKu/IHaVm1fJ39y
IoflMqF5h2qUjDrEcXTTyOvFESUaTSjJ+FAkEhtMHKb6WWJW6UgsEongTC6XlZWw4pOWQrPkrSpx
KCmGFnW6ouKlmekMpdYTt0+ad4gdSpeJQVU8Y17QKxVNjocjOKBnzeIwnh/GY9l5rGdXTIPgk3M4
mlfyCq7oqwTPaAXmWRrGxAhVnSM4bVkVskiWp3Qqx6PxsJIMKzgwlcnNTAebRyZJYdU8AqBlvULk
+BvKYNInpQsFYgFeg+N6QaNQoHzGMY0gpuQ8lc9o5zSnYOsWDeKj8lGfNEtKxCa2ilegEFWWlaFo
WDkGrEQirMiteKFpzShXtTJRm+m1/RNGwSzqRlnF5Qu6FcRFUqrA3fqkMdMwSIHhVbxKiBXSKvo5
8GdMB7LroPgkn8QEMHyzlzTUW3uk6doiVmeLxBbvMmk0FrpaRMhf3nhQ6xc2/9psSgNkcZ/Jgwvw
Vq/WUK/th9cRN3d+rZP/8AUf47+e28OfjD4c+Pnb9cNrtYPC5oe5Nv934I88UVkER0FyJ6fYlVz0
c5n6Vew/XqwQfxD7lzVKif0Oc5VNs8hcRd1ZhXUiCs+WbZZtEDWslRisHUIp/DdsfdHPDjVjOCRP
zlumU7V5cEWOMn/JoabF1qV4+BhzWJph2tpZDfqDuQcV5r10id8U3EePIXJ9PzoBjhM9h0h/RxOj
wHaKD5HddhNPoiy7JRY2CzO6/22EHvPIXjQAPmaZA26R1+uP+Tj1uqioFeEQOJj96BqhXm+y3GP8
CTvRK+J/WbjWd6fO3lOvuGm5FeHpYxYHusZsmt/QT51jbuMBH3MHaluW2R5z7zI9P52vXv2/XkqN
d/XSN7yXZrt66QvIYYf10qM/Wlo+uM5y4FVedeulfwF3gtYLeQcAAA==
------=_Part_99801_14322473.1227188699195--
