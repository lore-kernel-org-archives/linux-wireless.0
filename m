Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33220 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbcLGNB5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 08:01:57 -0500
Received: by mail-pf0-f171.google.com with SMTP id d2so77418927pfd.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 05:01:56 -0800 (PST)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
To: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <thomas@eero.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
 <20161202211351.GA5571@localhost>
 <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
 <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com>
 <1481102652.4092.33.camel@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <9197b711-3d48-071a-57d8-53e2a11c26de@gmail.com> (sfid-20161207_140201_673945_2E9D0377)
Date: Wed, 7 Dec 2016 21:55:41 +0900
MIME-Version: 1.0
In-Reply-To: <1481102652.4092.33.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------4553606E237ADF139732D145"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------4553606E237ADF139732D145
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2016年12月07日 18:24, Johannes Berg wrote:
>>> And the flag is refered by 1) as you said.
>>>
>>>
>>> The purpose of the flag is to prevent 1) while 2) is ongoing.
>>>
>>> In other words, 1) has only read access authority to the flag.
>>> However,
>>> previous code updated the flag in 1). In addition, there is no code
>>> for
>>> 2). So I just remove the invalid accessing codes.
>>
>> I don't think 1) has read only access to that flag. A TSF adjust will
>> by definition move the TBTT as well.
>
> It seems that the wording in the spec disagrees with that - it says
> (twice) to set the bit only while the TBTT adjustment procedure is
> ongoing, which isn't the case here?
>
> Then again, what exactly *is* this code doing?
>

> It's called mesh_sync_offset_adjust_tbtt() which matches more closely
> "TBTT adjustment" than "neighbor offset synchronization"?

I think so. Because there is not any code creating "TBTT Adjustment 
Request frame" even though the frame is required by "TBTT adjustment".

> The code
> looks more like offset synchronization though. Perhaps there's some
> confusing and it's kinda doing both?

In theory, updating the flag with 1) looks not correct because it is not 
clearly defined in spec.

In practice, I could consider extending the meaning of the flag over the 
spec to use it to avoid referring the updating TSF value by peer as 
Thomas said. I have took the statistics how many TSF drift 
(ifmsh->sync_offset_clockdrift_max) happens. The attached file shows the 
stats. The horizontal axis shows TSF drift time(usec) and vertical axis 
shows how many time the drift occurred. The graph shows almost drifts 
are under 20usec. In contrast, 2) could causes more than 1000usec drift. 
So 1) looks not so large enough to protect with the flag.

Masashi Honma.

--------------4553606E237ADF139732D145
Content-Type: image/png;
 name="clockdrift.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="clockdrift.png"

iVBORw0KGgoAAAANSUhEUgAAAoAAAAHrCAYAAABfFiwnAAAABHNCSVQICAgIfAhkiAAAABl0
RVh0U29mdHdhcmUAZ25vbWUtc2NyZWVuc2hvdO8Dvz4AAB6hSURBVHic7d15kKTnQd/x39vd
c88e0srSrnatY4URPoHY8i0fsmMuB3AVIUBCEsAUfwQijpQPcAEm2JUACSEhB6QSDlPmqEqM
wxEQRMaYxFg+ZHxibFmWkGRJlrTH3DPd/eaP3RnNzk7PzO52z8zO8/lUdWn37X6fefftmd2v
nvfo6vXX/8M6Sbqp0z6ymPZV7XQnugEA4PI3Mz2XBx58OA8/8tjKsladOt1mN/NPn0+1Pxlq
NdNsDu3gZgIA0C8jw0PZt288R689nL/62KfT7nTS6qbO/NPnMnRFM1VVpdPuZGmxvdPbCgBA
HzQaVYaHW7ni4GSe8+yb85GPfiqtpcOLqfbV6XbrdDrCDwBgL+l063QWuhlqNbN//0SuueZQ
WktXLqVVVVlaEn8AAHvVwmI7rVYzR665Oq3OWDuNbit1Xe/0dgEAMEDdbjcTE6Np1XWddruz
pZXqus70zFzm5xay1G6n2+2m0WhkqNXK2PhIJsZHU1WNy3osAIC9qt3upK7rMwG4ldm/2bn5
nD41k1ffdDivvOFwbjq4L/tGWplaaOdzJ6fznnu/mDs//3D2H5jM2NjIpmOdOjWT4zcdz/Eb
b8jBg1dkZGQ4CwuLOXnyZD5/7725957P58A2j3W56datTM3MpLO0lKdMttIZGt3pTQIAdrm6
rlO97pu+tm40Np4dm5qazb508xMve3puHGulbi8l3U5S10lVJY1mqtZQ7p1t563v+3Smq0Ym
J8d7jlWnyite8fJMTIynfXbGrq7rVFWVRqORVquV6ZmZvPfP/jyNqt6WsS433bqV07PDOfaM
p+Xp1x3M3Af+MJ+eaW45Ajt1I0tLCxlvVek2WgPeWgBgt+h2u6m++Ru/ZsMAnJtbyHh7Kb/w
ipsz2VlINrpSuNnKVGM4t//Z32RueChjo+fOuM3NLaTdqfN3X/Oq1N1uOp3eh56bzWaqRpU7
/vjODA1VAx1rqzrdoZyePp35mZksts/cLLvRbGZstJXD+0fTbm3fDGO7Hs8Tj0/mB37pR/L8
4cV84G0/mP/5SJX2yOSm6851RjP12BPZf+QpObL0pZxqDKdbiUAAKEG32934EHBd15mams7b
X3I843On0t3CbWImmq382N85mtv/370ZGR5KVVUrY52ems6rXvXKLC0ubhhsSdJut9NsNvOi
F92SO+9878DG2qr5zlimTi3m2V/zbXnty74yNx+ZSDPJ/IkH89lPfCh3/u4deXCp3rYIrOs6
a9+1+uzs50YWu+OZmj6cN//aW/OM6mT+6MfelPdMddMZnhjcxgIAu0Zd12l16/rModx1zM7O
5eWHJ/PU5kI6c/NJkrlOnftn27l535OfFvKZqaVcN97KWPNMVF0/OpaXXTOeD03NZ2x8dGWs
Y8eOZWRkJIuLi1vawE6nk9HRsRw7em1OnHhiw7HuvPM9Pce57bZX9hxrKxY7Y5ma25/v+Okf
yddde+5zo1cczbNvbeVT7/7f+WK3kXZ3OCdPPJbFxcW0O2f3a6OZA+OtXLF/Mu2qylJnIice
vi+LaeT4U0ayODyZE1PtzJw+kcbQSG64eiLz9VhOnXwsi/NLWeouzza2cmC8kQP79qV7Xv4l
dZJuXadOM6em57M4fTqLnTqpGjk4MZSD+ydSd5NuqjRX+rebex5dSNXs5KZrxjNfNbe8XwCA
y0+3rtPKBgG4sLCUWw+NpTMzdeacvyT3zXTzE58+lR992r48+0ArHz/Vzts/O5W3Pv1Avnzi
7KHk9lJuPTScv3js9MqFFwsLSzly5HAWFubT7W79s4YXFro5fORIvvjww5uO9drXfsN56//+
7//Byg2u1xtrK2ZOzeaZ3/ems/H3RP7yN341v/0Xn8sjc1X2HT6eZ91U5YGpbpYmJnNiaji3
fe+/yGuecSxHDo6mkSQzX8yH/+R38qu/96k0Jq/Oybkj+Ynf+sncnDMzcL/1yEL23/bG/Np3
XJs88Du5/S135sTQ/rz6e9+Q1zzjaA4fGEmVZOHxe3LXn7w7v/nHf52xg8Pnb2hdp65bOXFy
MTe88lvzj77hlnz5lUPpTj+Yj/zpu/KO//WJDO1bHb4H87Vv++V8bZKcfm/e8oO/mRzc/BAy
AHAZ2+wq4Ha7nRta7XTnZ1ci8Wn7JvLjL/2K/NT7/jr/4HArv/1wOz/6kpvztPZj6c7NnFmx
qnLD0NjKpcbLY42Pj2VpqX1B9xysqjP3q9nKWCdOnOjx5+j0HGsrOmPPzOtecObikUff/e/z
n+94KFceHM+hkaHMnLw/H7lrPgfHR7JYt1K3J/LM531Zjg4nyVLml4YyOnEkz/3m23No5s35
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
1/XKY/Vrlp9bu16v5QAA9N9FB+BytF3M61fHXq/lAAAMxkUHYK/4u5AoBABg+w30IpALnSW8
kHGXCU4AYC8a5FHRgd0HcFDxBwDApRnIDOCg409YAgB73dre6eeMYN9nAHvF31Yu/DBrCAAw
eBc9A7j29i7Jk6W6tlDXxt7ayOu1HACA/rvoALzYq4BdPQwAsLMGdhEIAAC7kwAEACiMAAQA
KIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAE
ACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwA
BAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiM
AAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAo
jAAEACiMAAQAKIwABAAojAAEACjMJQdgVVUDXQ4AQH9dUgBuFHN1XZ/3/IUuBwCg/y46AJej
baPlq6PuQpcDADAYFx2A68UfAAC7X2unN+BirJ4lFKIAwF40yKOirgIGACjMZTkDaNYPANjr
1vZOP2cE+z4DeCkXfvS6sAQAgP656BnA1RW6/Ou1Ubc25i50OQAA/XfRAbhZrPV6/kKXAwDQ
Xy4CAQAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAE
ACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwA
BAAojAAEACiMAAQAKIwABAAoTGunNwB2lara6S0AgIETgLBWXT/5a0EIwB7kEDAAQGEEIABA
YQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAA
QGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEGEoBVVa08
1nuu1zoAAAxe3wOwqqrUdb3yWB12y8+tjb1eywEA6L9tOwS8HHlJzom9XssBABgM5wACABSm
1e8B187iLc/u9dOgxwcA2GmDPCra9wBcfUh3vd8DALCz+h6A20FQAgB73dre6eeM4LadA7iV
Cz/MFgIADN62ngO4/NzayOu1HACA/hvIIeCNQq7Xc+IPAGB7uA0MAEBhBCAAQGEEIABAYQQg
AEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEE
IABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBh
BCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABA
YQQgAEBhWju9AXBZqqrzl9X19m8HAFwEAQgXY23srReEALBLOQQMAFAYAQgAUBgBCABQGAEI
AFAYAQgAUBgBCABQGAEIAFAYAQgAUBgBCABQGAEIAFCYgQRgVVUrj/We67UOAACD1/cArKoq
dV2vPFaH3fJza2Ov13IAAPpv4IeA67pO8mTkLS9bjr1eywEAGAznAAIAFKY1iEFXz+Itz+5d
TuMDAOy0QR4VHUgAro6y1Yd4AQDYeQMJwEETlADAXre2d/o5I7ht5wBu5cIPs4UAAIPX9xnA
tVfyrg665efWRl6v5QAA9N/AzwHc6nPiDwBge7gNDABAYQQgAEBhBCAAQGEEIABAYQQgAEBh
BCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABA
YQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAA
QGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQg
AEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEEIABAYQQgAEBhBCAAQGEE
IABAYQQgAEBhBhqAVVVtadlGywEA6K9tnQGsqip1XZ8Xe72WAwDQfwMLwF6Rl+Sc2Ou1HACA
wRhIAK6OOgAAdpfWTm/AxVg9Syg0AYC9aJBHRfs+A2j2DwBgdxvIDODqYh1EEApMAGCvW9s7
/ZwR7PsMYF3XK4/l3y//d7MLP8weAgAM3rbeBmY59tZGXq/lAAD030ADcL2g6xV54g8AYHv4
KDgAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACA
wghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAA
gMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghA
AIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMII
QACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIMJACrqlp5rPdcr3UAABi8vgdgVVWp63rl
sTrslp9bG3u9lgMA0H/bdgh4OfKSnBN7vZYDADAYrX4PuBxzsOv5nw0ACtX3AFxt9exev8dd
Jji5JGu/f0QhALvEII+KDuwQ8KDiDwCASzOQGcBBx5+wBAD2urW9088ZwYFdBbzWVi78MGsI
ADB4A5sBXG1t7K2NvF7LAQDov22/CrjX8+IPAGB7+Cg4AIDCCEAAgMIIQACAwghAAIDCCEAA
gMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwghAAIDCCEAAgMIIQACAwrR2
egNgz6iq85fV9fZvBwBsQgBCv6yNvfWCEAB2AYeAAQAKIwABAAojAAEACiMAAQAKIwABAAoj
AAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAK
IwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEACiMAAQAKIwABAAojAAEA
CiMAAQAKIwABAAojAAEACiMAAQAKIwABAAqzawKwqqqd3gQAgCLsigCsqip1XYvAXa6qKu/R
DvMe7Cz7f2fZ/zvL/t9bWju9Acvxl2QlApd/D5e99f6yLPH7u9c/GiXuC4BdYMcDEPa0tYGz
F//veat/pvX2hUAG2BFVvcPTbWtn/DaaATT1DACUrh/ptivOAQQAYPtcVoeAnRsIAHDpdnwG
cPXVvy4AAQAYvB0PwMTVvwAA22lXBGDi8C4AwHbZNQEIAMD2EIAAAIURgAAAhblsAnD5MwjX
uxm0G0RvP/t8+/kZ2B3s/53h+39n2f87p9f+vdDla10WAbh8hfDyY/Ufbvk534Dbxz7ffn4G
di/7f/B8/+8s+3/nbBR56+33C3k/LosA7GX1rWN8A24P+3x38X5sr15/2Sb2/3Za3uf2/86y
/wer1+3xeu33C30/LosAdIsYSudnYOe5VymwnQb9982u+ii49Wp17Q7wlzCl8zNAiVb/++D7
f3utnU2y//eGXRWAm31T+YeP0vkZ2Bn2+85bvf+9H9tr7f62//eGy+IQcOIbDvwM7KzVV0A6
1wm43F0WAdjrH75eJz8yOPb5zvAzsLNWXwG5/Pvl/9r/O8f+31n2/87YyoUfW3k/qvoyeMc2
OzfQN972s8+3l5+B3WO9fW3/D95G56DZ/4Nn/2+/i/17f6vvx2URgAAA9M9lcQgYAID+EYAA
AIURgAAAhRGAAACFEYAAAIURgAAAhRGAAACFEYAAAIURgAAAhRGAAACFEYAAAIURgAAAhWlt
9GRVVectq+u65/J+j1NV1Xnjrl5no695Kdb7ur2e67U9F7qd/RoHAGAzGwZgP+Or1+s3Cq31
lm0WiJdqva+70WvX254L3c5+jQMAsBVbPgS8nfGxU6GzlVC7GKINANhNLukcwKqqLnjGrNfM
3m441Hkhs3Sbvb5fXxcAoN82PAS8rNe5eMvLtjJj1+v1FzJOr/MGd4Otnht4IeOs/fMKRQCg
H7YUgGsN+vy/rY61XTF4oefwJZtfzLKVcZwDCAAMwqaHgEXHGasPU68Oz37tH/sZANguF3UO
4GYzb2uf7/X6C53B28rXHcSsYF3XK4/l3y9/vYuJtvX2j/gDALZLVW9SHr3i5ELvW3chyze6
P+BG58Rdakht5f6Ga89ZvNDt7OefFwDgYmwagBc16A7MaF1Os2iX07YCAHvP/wfrqYCwX6/d
lAAAAABJRU5ErkJggg==
--------------4553606E237ADF139732D145--
